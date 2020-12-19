
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web_web/material.dart';
import 'package:flutter_web_web/semantics.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myapp/database/db_classes.dart';
import 'package:myapp/design/rew_icon_icons.dart';
import 'package:myapp/scheduler/sm2_algo.dart';

class PomodoroPage extends StatefulWidget{

  Session session;
  Subject subject;
  Topic topic;
  PomodoroPage(this.session,this.topic,this.subject);

  @override
  _PomodoroPageState createState()=> _PomodoroPageState();

}

class _PomodoroPageState extends State<PomodoroPage> {

  int playPauseCount = 0;
  List<String> confidenceLevels= [
    "Brainwashed",
    "Leftovers",
    "Doubtful",
    "Average",
    "Pretty-good",
    "Forevermark"
  ];

Timer _timer;
int _start = 1500;
int _breakStart = 300; //seconds
int maxStudy = 1500;
int maxBreak = 300;
String mode = "S";

void startStudyTimer() {
  const oneSec = const Duration(seconds: 1);
  mode = "S";
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) => setState(
      () {
        if (_start < 1) {
          timer.cancel();
          startBreakTimer();
        } else {
          _start = _start - 1;
        }
      },
    ),
  );
}

void startBreakTimer() {
  const oneSec = const Duration(seconds: 1);
  mode = "B";
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) => setState(
      () {
        if (_breakStart < 1) {
          timer.cancel();
          startStudyTimer();
        } else {
          _breakStart = _breakStart - 1;
        }
      },
    ),
  );
}

void pauseTimer() {
  setState(() {
    _timer.cancel();
  });
}


  @override
  Widget build(BuildContext context) {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    DatabaseReference uidRef = FirebaseDatabase.instance.reference().child("users").child(user.uid);

    return FutureBuilder(
      future: uidRef.child('data').child('sessions').child(widget.session.sessionId).child('timeline').once(),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot){

        return Container(
      color: Colors.red.shade700,
      child: SafeArea(
      child : Scaffold(
        backgroundColor: Colors.red,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

           Expanded(
             child: Container(
               padding: EdgeInsets.symmetric(horizontal: 40),
               child: Column(
               mainAxisAlignment: MainAxisAlignment.end,
               crossAxisAlignment: CrossAxisAlignment.center,
             children: 
             [
               Text(widget.subject.name+" / "+widget.topic.name+"",style: TextStyle(fontFamily: 'OpenSans',fontSize: 24,color: Colors.white,fontWeight: FontWeight.normal),overflow: TextOverflow.fade, softWrap: false,),
           Text(
                  mode=="S"?((_start~/60).toString()+":"+(_start%60).toString().padLeft(2,'0')+" to break"):((_breakStart~/60).toString()+":"+(_breakStart%60).toString().padLeft(2,'0')+" to study"),
                  style: TextStyle(fontFamily: 'OpenSans',fontSize: 24,color: Colors.red.shade900,fontWeight: FontWeight.normal),overflow: TextOverflow.fade, softWrap: false,),
             ]),
             )
           ),
           Divider(color: Colors.transparent,height: 40,),
             Center(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Center(
                  child: SizedBox(
                  width: MediaQuery.of(context).size.width/1.6,
                  height: MediaQuery.of(context).size.width/1.6,
                  child: CircularProgressIndicator(
                  value: mode=="S"?(maxStudy-_start)/maxStudy:(maxBreak-_breakStart)/maxBreak,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.white.withOpacity(0.25),
                ))
                ),
                Center(
                  child: SizedBox(
                  width: MediaQuery.of(context).size.width/1.6,
                  height: MediaQuery.of(context).size.width/1.6,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.red.shade800.withOpacity(0.5),
                    iconSize: 100,
                    color: Colors.white,
                    icon: Icon((playPauseCount%2==0)?Icons.play_arrow:Icons.pause),
                    onPressed: (){
                      setState(() {
                        if(playPauseCount%2==0){
                          playPauseCount = playPauseCount+1;
                          startStudyTimer();
                          mode= mode;
                        }
                        else{
                          playPauseCount = playPauseCount+1;
                          pauseTimer();
                          mode=mode;
                        }
                        
                      });
                    },
                  )
                  )
                ),
              ],
            ),
          ),

          Expanded(child: Center(
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                color: Colors.redAccent,
                child: Text("Cancel",style: TextStyle(color: Colors.white),),
                shape: StadiumBorder(),
                onPressed: _timer!=null?(){
                  pauseTimer();
                  showDialog(context: context,
                  builder: (context) => new SimpleDialog(
                    title: Text("Are you sure you want to cancel this session."),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            child: Text('No',style: TextStyle(color: Colors.red),),
                            color: Colors.transparent,
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Yes',style: TextStyle(color: Colors.redAccent),),
                            color: Colors.transparent,
                            onPressed: (){
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  );
                }:null,
              ),
              Text("/",style: TextStyle(fontFamily: 'OpenSans',fontSize: 24,color: Colors.red.shade900,fontWeight: FontWeight.normal)),
              RaisedButton(
                child: Text("Mark Complete",style: TextStyle(color: Colors.grey.shade800),),
                shape: StadiumBorder(),
                onPressed: (){
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
                                                 Navigator.of(context).pop();
                                              },
                                            ),
                                          )
                    ],
                  );}
                    
                    );}
                  );
                },
              )
            ],
          )
          ))
        ],
      )
      )));
      });
  }

}
