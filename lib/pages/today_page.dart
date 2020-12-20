


import 'package:flutter_web_ui/ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/database/db_classes.dart';
import 'package:myapp/database/provider.dart';
import 'package:myapp/design/session_card.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/semantics.dart';
import 'package:myapp/design/rew_icon_icons.dart';

class TodayPage extends StatefulWidget{

  var data;
  TodayPageFilters filters;
  Function setStateCallback;
  TodayPage(this.data,this.filters,this.setStateCallback);

  @override
  _TodayPageState createState()=> _TodayPageState();

}

class _TodayPageState extends State<TodayPage> {
  
  Session _session = new Session();
  Subject _subject = new Subject();
  Topic _topic = new Topic();

  @override
  Widget build(BuildContext context) {

    var root = widget.data['data'];
    Map subjectMap = root!=null?root['subjects']:null;
    Map topicMap = {};

    if(subjectMap!=null){
    subjectMap.forEach((subId, subData) { 
      Map localTopics = subData['topics'];
      localTopics?.forEach((topId, topdata) { 
        topicMap[topId] = topdata;
      });
    });}

    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = FBProvider.user;
    final uid = user.uid;
    DatabaseReference uidRef = FirebaseDatabase.instance.reference().child("users").child(user.uid);

    return Container(
      color: Colors.white,
      child: SafeArea(
      child : Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Scaffold(
            body: Column(
              children: [
               Expanded(
                 child: Container(
              padding: EdgeInsets.all(5),
              child: FutureBuilder(
                future: uidRef.child('data').child('sessions').once(),
                builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot){

                  if(snapshot.hasData&&snapshot.data!=null){
                    scheduleDelayedCards(snapshot.data.value, uidRef);
                  } 

                return (snapshot.hasData&&snapshot.data!=null)?SingleChildScrollView(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: snapshot.data.value!=null?getSessionCards(filterTime(filterHidden(snapshot.data.value,widget.filters), widget.filters), topicMap, subjectMap):[Center(child:Text('No sessions.'))],
                )
              ):Center(child: Icon(Icons.cloud_circle),);
                },
              ),
            ),),
            

            
            ]),

          ),
        ],
      )
      ));
  }

  scheduleDelayedCards(Map sessionMap,DatabaseReference uidref){
    DateTime today = DateTime.now();
    sessionMap?.forEach((sid, sdata) {
      DateTime target = DateTime.parse(sdata['scheduledTime']);
      String status = sdata['sessionStatus'];
      if( target.isBefore(today)
          &&(target.day!=today.day
          || target.month!=today.month
          || target.year!=today.year)
          &&(status==SessionStatus.SCHEDULED.toString() || status==SessionStatus.LIVE.toString() )
          ){

          uidref.child('data').child('sessions').child(sid).child('sessionStatus').set(SessionStatus.DELAYED.toString());
          uidref.child('data').child('sessions').child(sid).child('scheduledTime').set(DateTime.now().toString());

      }
    });

  }

  getSessionCards(Map sessionMap,Map topicMap, Map subjectMap){

  List<Widget> cardlist = new List<Widget>();


    
    List idOrder = sortByTime(sessionMap);

    idOrder.forEach((sesId) {
      
      Map sesData = sessionMap[sesId];
     Session _session = new Session.idMapToObj(sesId,sesData);
      Subject _subject = new Subject.idMapToObj(sesData['subjectId'], subjectMap[sesData['subjectId']]);
     Topic _topic = new Topic.idMapToObj(sesData['topicId'], topicMap[sesData['topicId']]);
      cardlist.add(new SessionCard(_session,_subject,_topic,widget.setStateCallback));
     });

    return cardlist;
  }

  Map filterHidden(Map sessionMap, TodayPageFilters filters){

    Map filteredMap = new Map(); 

    if(filters.hideCompleted){
      sessionMap.forEach((sesId, sesData) { 
        if(sesData['sessionStatus']==SessionStatus.COMPLETED.toString()){
        }
        else{
          filteredMap[sesId] = sesData;
        }
    });

        return filteredMap;
    }

    else{
      return sessionMap;
    }


  }

    Map filterTime(Map sessionMap, TodayPageFilters filters){
    Map filteredMap = new Map(); 
    DateTime today = DateTime.now();

    if(filters.timeMode == "Today"){
      sessionMap.forEach((sesId, sesData) { 
        DateTime sesDate = DateTime.parse(sesData['scheduledTime']);
        if(sesDate.day==today.day&&sesDate.month==today.month&&sesDate.year==today.year){
          filteredMap[sesId] = sesData;
        }
        else{
        }
    });

        return filteredMap;
    }
        if(filters.timeMode == "Month"){
      sessionMap.forEach((sesId, sesData) { 
        DateTime sesDate = DateTime.parse(sesData['scheduledTime']);
        if(sesDate.month==today.month&&sesDate.year==today.year){
          filteredMap[sesId] = sesData;
        }
        else{
        }
    });

        return filteredMap;
    }
        if(filters.timeMode == "Week"){
      int weekday = today.weekday;
      int daysAfter = 7-weekday;
      int daysBefore = weekday-1;
      sessionMap.forEach((sesId, sesData) { 
        DateTime sesDate = DateTime.parse(sesData['scheduledTime']);
        int diff = sesDate.difference(today).inDays;
        if(sesDate.month==today.month&&sesDate.year==today.year){
          if((diff<daysAfter) || (diff>(-daysBefore))){
            filteredMap[sesId] = sesData;
          }
        }
        else{
        }
    });

        return filteredMap;
    }
  }


 List sortByTime(Map sessionMap){
  
  Map timeIdMap = new Map();
  List timeList = new List();
  List orderedIdList = new List();
  sessionMap.forEach((tid, tdata) {
    timeList.add(tdata['scheduledTime']);
    timeIdMap[tdata['scheduledTime']] = tid;
  }); 
  timeList.sort();
  timeList.forEach((time) {
    orderedIdList.add(timeIdMap[time]);
  });

  return orderedIdList;

 }


}

class TodayPageFilters{
  bool hideCompleted = true;
  String timeMode = "Today"; // "Week", "Month"

  TodayPageFilters({this.hideCompleted,this.timeMode});
}