
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/database/db_classes.dart';

class SM2Scheduler{

  SM2Scheduler();
  


  List<int> getSequence(Session session) {

    //returns a sequnce upto the interval which is above 365 days

    
    int c = session.confidenceLevel;
    double e = session.eFactor;
    int revisionNumber = session.revisionNumber;
    int nextRevisionNumber = revisionNumber+1;
    int r = nextRevisionNumber;
    List<int> sequence = new List<int>();
    int interval = 0;
    if(revisionNumber!=0){
      interval = session.scheduledTime.difference(session.lastSchedule).inDays;
    }

    if(c<3 || session.sessionStatus==SessionStatus.DELAYED){
      sequence.add(1);
      sequence.add(6);
      interval = 6;
      while(interval<365){
        interval = (interval*e).toInt();
        sequence.add(interval);
    }
    }
    else{
      while(interval<365){
        interval = getInterval(interval,e,r);
        sequence.add(interval);
        r=r+1;
    }
    }

    return sequence;
  }

  double getNewEfactor(double e, int c){
    e = e+(0.1 - (5-c)*(0.08+(5-c)*0.02));  

    if(e<1.3){
      e = 1.3;
    }

    if(e>2.5){
      e = 2.5;
    }

    return e;
  }

  int getInterval(int oldInterval,double e,int r){
    if(r==1){
      return 1;
    }
    if(r==2){
      return 6;
    }
    else{
      return (oldInterval*e).toInt();
    }
  }

  schedule(Session session) async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    DatabaseReference uidRef = FirebaseDatabase.instance.reference().child("users").child(user.uid);
    
    double e = getNewEfactor(session.eFactor, session.confidenceLevel);  //  easiness factor is bound 1.3 <= e <= 2.5
    double mastery = ((e*82.5)-106.25).roundToDouble();

    List<int> sequence = getSequence(session);
    Session initialSession = session; 
    print(sequence);

    if(sequence.isNotEmpty){
      for(int n=0;n<sequence.length;n++){

        var actualNextSessionMap;
        
        if(initialSession.nextSessionId!=null){
          var actualNextSessionSnap = await uidRef.child('data').child('sessions').child(initialSession.nextSessionId).once();
          actualNextSessionMap = actualNextSessionSnap.value;
        }


        String nextSessionKey = initialSession.nextSessionId==null? uidRef.child('data').child('sessions').push().key : initialSession.nextSessionId;



        uidRef.child('data').child('sessions').child(nextSessionKey).child('revisionNumber').set(initialSession.revisionNumber+1);
        uidRef.child('data').child('sessions').child(nextSessionKey).child('topicId').set(session.topicId);
        uidRef.child('data').child('sessions').child(nextSessionKey).child('subjectId').set(session.subjectId);
        uidRef.child('data').child('sessions').child(nextSessionKey).child('scheduledTime').set(initialSession.scheduledTime.add(Duration(days: sequence[n])).toString());
        uidRef.child('data').child('sessions').child(nextSessionKey).child('sessionStatus').set(SessionStatus.SCHEDULED.toString());
        uidRef.child('data').child('sessions').child(nextSessionKey).child('sessionType').set(SessionType.REVISION.toString());
        uidRef.child('data').child('subjects').child(session.subjectId).child('topics').child(session.topicId).child('sessions').child((initialSession.revisionNumber+1).toString()).set(nextSessionKey);
        uidRef.child('data').child('subjects').child(session.subjectId).child('topics').child(session.topicId).child('mastery').set(mastery);  
        uidRef.child('data').child('sessions').child(nextSessionKey).child('confidenceLevel').set(session.confidenceLevel);
        uidRef.child('data').child('sessions').child(nextSessionKey).child('eFactor').set(e);
        uidRef.child('data').child('sessions').child(initialSession.sessionId).child('nextSessionId').set(nextSessionKey);
        uidRef.child('data').child('sessions').child(nextSessionKey).child('prevSessionId').set(initialSession.sessionId);
        uidRef.child('data').child('sessions').child(nextSessionKey).child('lastSchedule').set(initialSession.scheduledTime.toString());


        initialSession = new Session(
          revisionNumber: initialSession.revisionNumber+1,
          sessionId: nextSessionKey,
          scheduledTime: initialSession.scheduledTime.add(Duration(days: sequence[n])),
          nextSessionId: initialSession.nextSessionId!=null?actualNextSessionMap['nextSessionId']:null
        );
      }
    }
  }

}