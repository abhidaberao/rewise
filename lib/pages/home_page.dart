import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:myapp/database/db_classes.dart';
import 'package:myapp/design/drawer.dart';
import 'package:myapp/pages/auth_page.dart';
import 'package:myapp/pages/syllabus.dart';
import 'package:myapp/design/rew_icon_icons.dart';
import 'package:myapp/pages/stats_page.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/today_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:myapp/database/auth.dart';
import 'package:emoji_picker/emoji_picker.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,this.auth, this.logoutCallback,this.userId,this.uidRef}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  String userId;
  final DatabaseReference uidRef;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  int _counter = 0;
  TabController _tabController;
  int navIndex = 1;
  String _username = "_";
  AnimationController _animationController1,_animationController2;
  Animation _animation1, _animation2;

  //syllabus page members
  String newTopicMode = "topic";
  TodayPageFilters todayFilters = new TodayPageFilters(
    hideCompleted: true,
    timeMode: "Today"
  );  

  setStateCallback(){
    setState(() {
      
    });
    print("homepage reset");
  }

  GlobalKey drawer = new GlobalKey();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _animationController1 = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    _animation1 = IntTween(begin: 200, end: 100).animate(_animationController1);
    _animation1.addListener(() => setState(() {}));
    _animationController2 = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    _animation2 = IntTween(begin: 100, end: 200).animate(_animationController2);
    _animation2.addListener(() => setState(() {}));
  }

  String getTitle(){
    switch(navIndex){
      case 0:
      return 'Stats';
      break;

      case 1:
      return todayFilters.timeMode;
      break;

      case 2:
      return 'Topic Map';
      break;
    }
  }

  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return 
    widget.uidRef!=null?FutureBuilder(
      future: widget.uidRef.once(),
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot){
        var data;
        if(snapshot.hasData && snapshot.data!=null){
          data = snapshot.data.value;
        return Container(
      color: Colors.white,
      child: SafeArea(
      child : Scaffold(
        key: scaffoldState,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(getTitle(),style: TextStyle(color:Colors.black, fontFamily: 'Kelson',),),

        actions: [
          navIndex==1?IconButton(icon: Icon(Icons.calendar_today, color: Colors.black, size: 25),
          onPressed: (){
            filterDialog();
          },
          ):SizedBox(width:0,height:0),
        ],
        
      ),

      drawer: HomeDrawer(data,widget.logoutCallback),

      body: Center(
        child: IndexedStack(
          index: navIndex,
          children: <Widget>[
            StatsPage(data),
            TodayPage(data,todayFilters,setStateCallback),
            SyllabusPage(data,widget.uidRef,setStateCallback),

          ],
        )
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal:0),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Expanded(
              flex: 50,
              child: SizedBox(),
            ),

            Expanded(
              flex: 100,
              child: ButtonTheme(
                child: 
                  OutlineButton(
                    borderSide: BorderSide(style: BorderStyle.none),
                    shape: StadiumBorder(),
                    child: Icon(RewIcons.speedometer, color: navIndex==0?Colors.redAccent:Colors.grey,),
                    onPressed: (){
                      if(navIndex==1){
                        _animationController1.forward().whenComplete((){
                          setState(() {
                            navIndex = 0;
                          });
                        });
                      }
                      if(navIndex==2){
                        _animationController2.reverse().whenComplete((){
                          setState(() {
                            navIndex = 0;
                          });
                        });
                      }                      
                    },
                  ),                
              ),
            ),

            Expanded(
              flex: 50,
              child: SizedBox(),
            ),            

            Expanded(
              flex: _animation1.value,
              child: ButtonTheme(
                child: 
                  FlatButton(
                    color: Colors.redAccent.withOpacity((1.0-_animationController1.value).abs()),
                    shape: StadiumBorder(),
                    child: FittedBox(child: navIndex!=1?Icon(RewIcons.calendar, color: navIndex==1?Colors.black:Colors.grey,):
                                        Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[Icon(Icons.add,color: Colors.white,),Text(" Task",style: TextStyle(color: Colors.white,fontFamily: "Kelson"),)],),),
                    onPressed: (){
                      if(navIndex==1){
                        //newSessionDialog(data);
                      }
                      else{
                      buttonAnimationFrom(1, 2);
                    }
                    },
                  ),                
              ),
            ),

            Expanded(
              flex: 50,
              child: SizedBox(),
            ),

            Expanded(
              flex: _animation2.value,
              child: ButtonTheme(
                child: 
                FlatButton(
                    color: Colors.redAccent.withOpacity((_animationController2.value).abs()),                    
                    shape: StadiumBorder(),
                    child: FittedBox(child: navIndex!=2?Icon(RewIcons.book, color: navIndex==2?Colors.black:Colors.grey,):
                                        Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[Icon(Icons.add,color: Colors.white,),Text(" New",style: TextStyle(color: Colors.white,fontFamily: "Kelson"),)],),),
                    onPressed: (){
                      if(navIndex==2){
                        newSubjectDialog();
                      }
                      else{
                      buttonAnimationFrom(2, 1);
                      }
                    },
                  ),            
              ),
            ),

            Expanded(
              flex: 50,
              child: SizedBox(),
            ),

          ],
        ),
        //currentIndex: navIndex,
        //selectedItemColor: Colors.black,
        //unselectedItemColor: Colors.grey,
        //backgroundColor: Colors.white,
        /*items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(RewIcons.speedometer),
            title: Text("stats")),
          BottomNavigationBarItem(
            icon: Icon(RewIcons.book),
            title: Text("Today")),
          BottomNavigationBarItem(
            icon: Icon(RewIcons.calendar),
          title: Text("planner")),
        ],*/
        //showSelectedLabels: false,
        //showUnselectedLabels: false,

        /*onTap: (n){
          setState(() {
            navIndex = n;
          });
        },*/

      ),
    ))));
      }
      
      else{
        return Center(child: Image.asset("gifs/hourglass.gif"));
      }
      },
    ):Center(child: Text("loading"));
  }

  buttonAnimationFrom(int expand,int minimize){
    if(expand==1 && minimize==2){
      _animationController2.reverse();
      _animationController1.reverse().then((value){
        setState(() {
          navIndex = 1;
        });
      });
    }
    if(expand==2 && minimize==1){
      _animationController2.forward();
      _animationController1.forward().then((value){
        setState(() {
          navIndex = 2;
        });
    });
  }
  }





  filterDialog(){
    showDialog(
      //barrierColor: Colors.black.withOpacity(0.8),
      barrierDismissible: false,
        context: context,
        builder: (context){

          bool localHideCompleted = todayFilters.hideCompleted;

        return StatefulBuilder(
          builder: (context,setLocalState)=> SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
              title: null,
              children: [
                
                Row(children: [
                  Expanded(
                    child: CupertinoButton(
                     padding: EdgeInsets.all(10),                     
                    color: todayFilters.timeMode=="Today"?Colors.redAccent.shade100:Colors.redAccent,
                    child: Row(children: [
                      Icon(Icons.wb_sunny,size: 20,),
                      Text("  Today",style: TextStyle(fontSize: 15),),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    onPressed: (){
                      setState(() {
                        setLocalState((){
                        todayFilters.timeMode = "Today";
                        });
                      });
                    },
                  ),),


                 VerticalDivider(color: Colors.transparent,),
                  Expanded(
                    child: CupertinoButton(
                     padding: EdgeInsets.all(10),                     
                    color: todayFilters.timeMode=="Week"?Colors.redAccent.shade100:Colors.redAccent,
                    child: Row(children: [
                      Icon(Icons.calendar_view_day,size: 20,),
                      Text("  Week",style: TextStyle(fontSize: 15),),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    onPressed: (){
                        setState(() {
                        setLocalState((){
                        todayFilters.timeMode = "Week";
                        });
                      });
                    },
                  ),),

                  VerticalDivider(color: Colors.transparent,),
                  Expanded(
                    child: CupertinoButton(
                     padding: EdgeInsets.all(10),                     
                    color: todayFilters.timeMode=="Month"?Colors.redAccent.shade100:Colors.redAccent,
                    child: Row(children: [
                      Icon(Icons.calendar_today,size: 20,),
                      Text("  Month",style: TextStyle(fontSize: 15),),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    onPressed: (){
                          setState(() {
                        setLocalState((){
                        todayFilters.timeMode = "Month";
                        });
                      });
                    },
                  ),),
                ],),

                  Divider(color: Colors.transparent,),
                                    CupertinoButton(
                    padding: EdgeInsets.all(10),
                    color: todayFilters.hideCompleted?Colors.redAccent.shade100:Colors.redAccent,
                    child: Row(children: [
                      Icon(localHideCompleted?Icons.radio_button_checked:Icons.radio_button_unchecked),
                      Text("  Hide completed tasks",style: TextStyle(color: Colors.white),),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    onPressed: (){
                      setState(() {
                        setLocalState((){
                        todayFilters.hideCompleted = !todayFilters.hideCompleted;
                        localHideCompleted = todayFilters.hideCompleted;
                        });
                      });
                    },
                  ),

                  Divider(color: Colors.transparent,),

                  CupertinoButton(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Row(children: [
                      Icon(Icons.close,color: Colors.black,),
                      Text("  Close",style: TextStyle(color: Colors.black),),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  
                ],
            ));});
  }

  newNodeDialog(var data){
    showDialog(
        context: context,
        builder: (_) => new SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
              title: null,
              children: [
                CupertinoButton(
                    color: Colors.redAccent,
                    child: Row(children: [
                      Icon(Icons.flag),
                      Text("  Add Topic"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    onPressed: (){
                     Navigator.pop(context);
                    newTopicDialog(data);
                    },
                  ),
                  Divider(color: Colors.transparent,),
                  CupertinoButton(
                    color: Colors.redAccent,
                    child: Row(children: [
                      Icon(Icons.book),
                      Text("  Add Subject"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                      newSubjectDialog();
                    },
                  ),
                  Divider(color: Colors.transparent,),
                  CupertinoButton(
                    color: Colors.white,
                    child: Row(children: [
                      Icon(Icons.close,color: Colors.black,),
                      Text("  Cancel",style: TextStyle(color: Colors.black),),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  
                ],
            ));
  }

  newSubjectDialog(){
    TextEditingController subnamec = new TextEditingController();
    showDialog(
        context: context,
        builder: (context){

          String sel_emoji = "📕";

        return StatefulBuilder(
          builder: (context,setState)=> SimpleDialog(
          elevation: 0,
          contentPadding: EdgeInsets.all(20),
              title: Row(
                children: [
                  Text("  New Subject")
                ],
              ),
              children: [
                Row(
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.grey.shade300,
                      ),
                      
                      child: IconButton(
                  iconSize: 30,
                  color: Colors.grey.shade500,
                  padding: EdgeInsets.all(0),
                  icon: Text(sel_emoji,style: TextStyle(fontSize: 25),),
                onPressed: (){
                  showDialog(context: context,
                  builder: (context) => new Center(
                    child: Container(
                      child: Text("lol")
                        /*
                        EmojiPicker(
                          onEmojiSelected: (emoji,category){
                            setState(() {
                              sel_emoji = emoji.emoji;
                            });
                            Navigator.of(context).pop();
                          }
                          ),*/
                        
                    )
                  ),
                  );
                  
                }
                ),),

                VerticalDivider(),
                Expanded(
                  child: TextFormField(
                  controller: subnamec,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10,right: 10),
                    hintText: "Quantum Physics",
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(5.0)))
                  ),
                ),),
                
                
                ]),
                Divider(color: Colors.transparent,),
                  CupertinoButton(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.redAccent,
                    child: Row(children: [
                      Text("Add"),   
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: (){
                      String newkey = widget.uidRef.child("data").child("subjects").push().key;
                      widget.uidRef.child("data").child("subjects").child(newkey).child("name").set(subnamec.text);
                      widget.uidRef.child("data").child("subjects").child(newkey).child("emoji").set(sel_emoji);
                      Navigator.pop(context);
                      setStateCallback();
                    },
                  ),

                ],
            ));});
  }

  newTopicDialog(var data){
    List<DropdownMenuItem> subjects = [];
    Map submap = data['data']!=null?data['data']['subjects']:null;
    submap?.forEach((id, subdata) { 
      subjects.add(DropdownMenuItem<String>(
                        value: id,
                        child: new Text(subdata['name']),
                      ));
    });
     subjects.add(DropdownMenuItem<String>(
                        value: '0',
                        child: new Text('Select subject'),
                      ));


    showDialog(
  context: context,
  builder: (context) {
    String subjectDropValue = '0';
    TextEditingController topnamec = new TextEditingController();
    return StatefulBuilder(
      builder: (context, setState) {
        return SimpleDialog(
          elevation: 0,
          contentPadding: EdgeInsets.all(20),
              title: Row(
                children: [
                  Icon(Icons.book),
                  Text("  New Topic")
                ],
              ),
              children: [
                TextFormField(
                  controller: topnamec,
                  decoration: InputDecoration(
                    hintText: "Schrödinger's cat",
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(5.0)))
                  ),
                ),
                Divider(color: Colors.transparent,),
                new DropdownButton(
                  value: subjectDropValue,
                    items: subjects,
                    onChanged: (value) {
                      setState(() {
                        subjectDropValue = value;
                      });
                    },
                  ),
                Divider(color: Colors.transparent,),
                  CupertinoButton(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.redAccent,
                    child: Row(children: [
                      Text("Add"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: (){
                      widget.uidRef.child('data').child('subjects').child(subjectDropValue).child("topics").push().child('name').set(topnamec.text);         
                      Navigator.pop(context);
                      setState(() {
                      });
                    },
                  ),
                ],
            
            );
      },
    );
  },
);

   
  }

/*
  newSessionDialog(var data){
    List<DropdownMenuItem> subjects = [];
    Map<String,List<DropdownMenuItem>> topics = new Map<String,List<DropdownMenuItem>>();

    Map submap = data['data']!=null?data['data']['subjects']:null;
    
    submap?.forEach((id, subdata) { 
      subjects.add(DropdownMenuItem(
                        value: id,
                        child: new Text(subdata['name']),
                      ));
      
      topics[id] = new List<DropdownMenuItem>();
      topics[id].add(
        DropdownMenuItem(
                        value: '0',
                        child: new Text('Topic'),
                      )
      );
      if(subdata["topics"]!=null){subdata["topics"].forEach((topicid, topicdata) { 

        topics[id].add(
          new DropdownMenuItem(
                        value: topicid,
                        child: new Text(topicdata['name']),
                      ));
        
      });}
    });
     subjects.add(DropdownMenuItem(
                        value: '0',
                        child: new Text('Subject'),
                      ));


    showDialog(
  context: context,
  builder: (context) {
    String subjectDropValue = '0';
    String topicDropValue = '0';

    return StatefulBuilder(
      builder: (context, setState) {
        return SimpleDialog(
          elevation: 0,
          contentPadding: EdgeInsets.all(20),
              title: Row(
                children: [
                  Icon(Icons.alarm_add),
                  Text("  New Session")
                ],
              ),
              children: [
               
                new DropdownButton(
                  value: subjectDropValue,
                    items: subjects,
                    onChanged: (value) {
                      setState(() {
                        subjectDropValue = value;
                        topicDropValue = '0';
                      });
                    },
                  ),
                  Container(
                    child: subjectDropValue=='0'?null:DropdownButton(
                  value: topicDropValue,
                    items: topics[subjectDropValue],
                    onChanged: (value) {
                      setState(() {
                        topicDropValue = value;
                      });
                    },
                  ),
                  ),
                  

                Divider(color: Colors.transparent,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    CupertinoButton(
                    padding: EdgeInsets.all(0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Row(children: [
                      Text("Schedule"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: subjectDropValue!='0'&&topicDropValue!='0'?(){

                      Session newSession = new Session(
                        topicId: topicDropValue,
                        revisionNumber: 0,
                        sessionStatus: SessionStatus.SCHEDULED,
                        sessionType: SessionType.STUDY
                      );

                     DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime.now().add(Duration(days: 365*5)), onChanged: (date) {
                            print('change $date');
                          },
                          
                          onConfirm: (date) {
                            newSession.scheduledTime = new DateTime(
                              date.year,date.month, date.day
                            );

                      addSession(subjectDropValue, topicDropValue, newSession,data);
                      
                          }, 
                          
                          currentTime: DateTime.now(),
                          theme: DatePickerTheme(
                            /*doneStyle: TextStyle(
                              color: Colors.redAccent
                            ),*/
                          ),
                          );

                      
                    }:null,
                  ),

                    CupertinoButton(
                        padding: EdgeInsets.all(0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Row(children: [
                      Text("Now"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: subjectDropValue!='0'&&topicDropValue!='0'?(){

                      Session newSession = new Session(
                        topicId: topicDropValue,
                        revisionNumber: 0,
                        scheduledTime: DateTime.now(),
                        sessionStatus: SessionStatus.SCHEDULED,
                        sessionType: SessionType.STUDY
                      );
                      
                      addSession(subjectDropValue, topicDropValue, newSession,data);
                     
                    }:null,
                  ),
                  ],)
                ],
            
            );
      },
    );
  },
);

   
  }
*/

addSession(subjectDropValue,topicDropValue,newSession,data){

  List timeline = data['data']['subjects'][subjectDropValue]['topics'][topicDropValue]['sessions'];
  bool timelineExists = timeline!=null && timeline.isNotEmpty;
  if(timelineExists){
    showDialog(context: context,
  builder: (context) {
    return SimpleDialog(
      title: Text("Overwrite?"),
      contentPadding: EdgeInsets.all(25),
      children: [
        Text("A session timeline already exists for the selected topic, continuing will replace old timeline with new"),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);

                      setState(() {
                      });
                },
                child: Text("Cancel")),
            ),
            Expanded(
              child: FlatButton(
                onPressed: (){
                  String newSessionKey = widget.uidRef.child('data').child('subjects').child(subjectDropValue).child("topics").child(topicDropValue).child("sessions").push().key;
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('revisionNumber').set(0);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('topicId').set(topicDropValue);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('subjectId').set(subjectDropValue);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('scheduledTime').set(newSession.scheduledTime.toString());
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('sessionStatus').set(newSession.sessionStatus.toString());
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('sessionType').set(newSession.sessionType.toString());
                  widget.uidRef.child('data').child('subjects').child(subjectDropValue).child('topics').child(topicDropValue).child('sessions').child(0.toString()).set(newSessionKey);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('confidenceLevel').set(5);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('eFactor').set(2.5);

                  Navigator.pop(context);
                  Navigator.pop(context);

                      setStateCallback();
                },
                child: Text("Continue")),
            ),
          ],
        )
      ],
    );
  });
  }
  else{
    String newSessionKey = widget.uidRef.child('data').child('subjects').child(subjectDropValue).child("topics").child(topicDropValue).child("sessions").push().key;
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('revisionNumber').set(0);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('topicId').set(topicDropValue);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('subjectId').set(subjectDropValue);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('scheduledTime').set(newSession.scheduledTime.toString());
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('sessionStatus').set(newSession.sessionStatus.toString());
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('sessionType').set(newSession.sessionType.toString());
                  widget.uidRef.child('data').child('subjects').child(subjectDropValue).child('topics').child(topicDropValue).child('sessions').child(0.toString()).set(newSessionKey);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('confidenceLevel').set(5);
                  widget.uidRef.child('data').child('sessions').child(newSessionKey).child('eFactor').set(2.5);

                  Navigator.pop(context);

                      setStateCallback();
  }
  
  

}

}