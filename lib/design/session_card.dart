import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';
import 'package:myapp/database/db_classes.dart';
import 'package:myapp/design/pomodoro_page.dart';
import 'package:myapp/scheduler/sm2_algo.dart';
import 'rew_icon_icons.dart';

class SessionCard extends StatefulWidget{

  Session session;
  Topic topic;
  Subject subject;
  Function setStateCallback;

  SessionCard(this.session,this.subject,this.topic,this.setStateCallback);


  SessionCardState createState() => new SessionCardState(); 
}

class SessionCardState extends State<SessionCard>{

  @override
  Widget build(BuildContext context) {

    Session session = widget.session;
    Subject subject = widget.subject;
    Topic topic = widget.topic;
    double _slider = 8;
    List months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

    List<String> confidenceLevels= [
        "Brainwashed",
        "Leftovers",
        "Doubtful",
        "Average",
        "Pretty-good",
        "Forevermark"
      ];


    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    DatabaseReference uidRef = FirebaseDatabase.instance.reference().child("users").child(user.uid);

    return Card(
      color: session.sessionStatus==SessionStatus.COMPLETED?Colors.grey.shade300:Colors.white,
                      shape: RoundedRectangleBorder(side: BorderSide(width: 1,color: Colors.grey.shade300),borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      child: Theme(
                        data: ThemeData(accentColor: Colors.black,dividerColor: Colors.transparent),
                        child:ExpansionTile(
                          initiallyExpanded: session.sessionStatus==SessionStatus.LIVE?true:false,
                        trailing: session.sessionStatus==SessionStatus.COMPLETED?SizedBox(width: 0,height: 0,):Icon(Icons.arrow_drop_down),
                      title: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: <Widget>[

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                              Expanded(
                                child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Row(children: <Widget>[
                                
                                Text(subject.emoji+" "+subject.name,style: TextStyle(fontFamily: 'OpenSans',fontSize: 13,fontWeight: FontWeight.w300),)
                              ],),

                             Row( 
                               children: [
                                 Flexible(
                             child: Text(topic.name,style: TextStyle(fontFamily: 'OpenSans',fontSize: 17,fontWeight: FontWeight.w600), overflow: TextOverflow.fade, softWrap: false,) ,                               
                             )]),

                            ],)),

                            
                            ]),
                            SizedBox(height: 5,),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                            Wrap(
                              spacing: 5,
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              children: <Widget>[
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: Colors.transparent,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: Colors.grey)),
                                  label: Text(session.revisionNumber==0?"First Study":"Revision "+session.revisionNumber.toString(),style: TextStyle(fontFamily: 'OpenSans',color: Colors.grey,fontSize: 12,fontWeight: FontWeight.bold),),
                                ),        
                                Chip(
                                  labelPadding: EdgeInsets.only(right: 10),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: session.sessionStatus==SessionStatus.COMPLETED?Colors.green.withOpacity(0.2):Colors.red.shade300.withOpacity(0.2),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: session.sessionStatus==SessionStatus.COMPLETED?Colors.green:Colors.red.shade300)),
                                  avatar: Icon(session.sessionStatus==SessionStatus.COMPLETED?Icons.check:session.sessionStatus==SessionStatus.DELAYED?Icons.notifications:Icons.calendar_today,color: session.sessionStatus==SessionStatus.COMPLETED?Colors.green:Colors.red.shade300,size: 15,),
                                  label: Text(session.sessionStatus==SessionStatus.COMPLETED?"Completed":session.sessionStatus==SessionStatus.DELAYED?"Pending":(widget.session.scheduledTime.day.toString()+" "+months[widget.session.scheduledTime.month-1]),style: TextStyle(fontFamily: 'OpenSans',color: session.sessionStatus==SessionStatus.COMPLETED?Colors.green:Colors.red.shade300,fontSize: 12,),),
                                ),                                                      
                              ],
                            )
                              ],
                            ),
                          
                          ],
                        )
                      ),
                      children: <Widget>[
                        Container(
                          
                          child: Column(
                            children: [

                            session.sessionStatus==SessionStatus.COMPLETED?SizedBox(width: 0,height: 0,):Row(
                              children: [
                              Expanded(
                                child: 
                                  Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                    decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                    
                                    ),
                                    child: Center(
                                      child: Column(
                                      children: [





                                      Row(
                                            children: [
                                            Expanded(
                                              child: Align(child: Text("Mastery:",style: TextStyle(fontFamily:"Kelson",color:Colors.white,fontSize:15,fontWeight: FontWeight.w400,),),
                                              alignment: Alignment.centerLeft,)
                                            ),
                                           SizedBox(width: 20,)  ,   
                                          
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              minHeight: 10,
                                              valueColor:  new AlwaysStoppedAnimation<Color>(Colors.white),
                                              backgroundColor: Colors.black.withOpacity(0.2),
                                            value: topic.mastery!=null?topic.mastery/100:0,
                                            
                                          ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text((topic.mastery!=null?(topic.mastery.toInt()).toString():"0")+"%",style: TextStyle(fontFamily:"Kelson",fontSize:15,fontWeight: FontWeight.bold,color: Colors.white),),                                                                                

                                          ]),


                                      SizedBox(height: 5,),

                                        Row(
                                            children: [
                                            Expanded(
                                              child: Align(child: Text("Revision Level:",style: TextStyle(fontSize:15,fontFamily: 'Kelson',fontWeight: FontWeight.w400,color: Colors.white),),
                                              alignment: Alignment.centerLeft,)
                                            ),
                                           SizedBox(width: 20,)  ,   
                                          
                                          Expanded(
                                            child: Text("Lvl. "+(topic.latestRevisionNumber).toString(),style: TextStyle(fontSize:15,fontFamily: 'Kelson',fontWeight: FontWeight.bold,color: Colors.white),),
                                          ),
                                                                                                                          

                                          ]),

                                    

                              ]),
                                    )
                                  ),
                              )
                              ]),
                              
                              session.sessionStatus!=SessionStatus.COMPLETED?Row(
                                children: <Widget>[
                                  Expanded(
                                    child: FlatButton(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.check),
                                          Text("Mark Complete")
                                        ],
                                      ),
                                      onPressed: isDateSame(session)?(){
                                        setState((){
                  showDialog(context: context,
                  builder: (context){

                    double confidence = 5;
                    
                    return StatefulBuilder(
                    builder: (context,setLocalState){
                     return SimpleDialog(
                       contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical:10),
                       backgroundColor: Colors.red.shade900,
                    title: Center(child: Text("Confidence Check.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 15),),),
                    children: [
                      Center(
                        child: Text(confidenceLevels[confidence.toInt()],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
                      ),
                      SliderTheme(
                                            data: SliderThemeData(
    
                                              overlayColor: Colors.white.withOpacity(0.25),
                                              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 2),
                                              thumbColor: Colors.white,
                                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4,disabledThumbRadius: 4),
                                              trackHeight: 5,
                                              disabledActiveTrackColor: Colors.transparent,
                                              disabledInactiveTrackColor: Colors.transparent,
                                              activeTickMarkColor: Colors.white,
                                              activeTrackColor: Colors.transparent,
                                              disabledActiveTickMarkColor: Colors.white,
                                              disabledInactiveTickMarkColor: Colors.white.withOpacity(0.5),
                                              inactiveTickMarkColor: Colors.white.withOpacity(0.5),
                                              inactiveTrackColor: Colors.transparent,
                                              valueIndicatorColor: Colors.transparent,
                                        
                                              
                                            ),
                                            child:
                                              Slider(value: confidence,
                                              onChanged: (value){
                                                setLocalState(() {
                                                  confidence = value;
                                                });
                                              },
                                              min: 0,
                                              max: 5,
                                              divisions: 5,
                                              )
                                          ),
                                          Center(
                                            child: RaisedButton(
                                              shape: StadiumBorder(),
                                              child: Text("Save"),
                                              color: Colors.redAccent,
                                              onPressed: (){
                                                setState(() {
                                                  uidRef.child('data').child('subjects').child(widget.subject.subjectId).child('topics').child(widget.session.topicId).child('confidenceLevel').set(confidence);
                                                  uidRef.child('data').child('subjects').child(widget.subject.subjectId).child('topics').child(widget.session.topicId).child('latestRevisionNumber').set(widget.session.revisionNumber+1);
                                                  uidRef.child('data').child('subjects').child(widget.subject.subjectId).child('topics').child(widget.session.topicId).child('confidenceLevel').set(confidence);
            
                                                  uidRef.child('data').child('sessions').child(widget.session.sessionId).child('sessionStatus').set(SessionStatus.COMPLETED.toString());
                                                  widget.session.confidenceLevel = confidence.toInt();
                                                  SM2Scheduler().schedule(widget.session);
                                                
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          )
                    ],
                  );}
                    
                    );}
                  );
                });
                                      }:null,
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: FlatButton(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.play_arrow),
                                          Text("Start Session")
                                        ],
                                      ),
                                      onPressed: isDateSame(session)?(){
                                        setState(() {
                                          uidRef.child('data').child('sessions').child(session.sessionId).child('timeline').set([DateTime.now().toString()]);
                                        });
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>PomodoroPage(session,topic,subject),
                                            ));
                                      }:null,
                                    ),                                    
                                  )
                                ],
                              ):SizedBox(width: 0,height: 0,),
                            ]
                          ),)
                      ],
                    )));
  }

  isDateSame(Session session){
    DateTime s = session.scheduledTime;
    DateTime t = DateTime.now();
    if(s.day==t.day&&s.month==t.month&&s.year==t.year){
      return true;
    }
    else{
      return false;
    }
  }

  getDifficultyLevel(Session session){
    int d = ((session.eFactor-2.5)*(-83.3)).toInt();
    if(d<5){
      d=5;
    }
    if(d>95){
      d=95;
    }

    return 100-d;
  }
}