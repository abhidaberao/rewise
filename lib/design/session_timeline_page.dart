
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:myapp/database/db_classes.dart';
import 'package:myapp/database/provider.dart';
import 'package:myapp/design/rew_icon_icons.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SessionTimeline extends StatefulWidget{

  Topic topic;
  SessionTimeline(this.topic);

  @override
  SessionTimelineState createState()=> SessionTimelineState();

}

class SessionTimelineState extends State<SessionTimeline> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: SafeArea(
      child : Scaffold(
        appBar: AppBar(
          title: Text("Sessions"),
        ),
        backgroundColor: Colors.red,
      body: Center(
        child: FutureBuilder(
          future: FBProvider.sessions.once(),
          builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot){

            Map sessionMap = snapshot?.data?.value;
            return Center(
              child: ListView(
              padding: EdgeInsets.all(10),
          children: snapshot.hasData&&snapshot.data!=null?getTimelineTiles(sessionMap):[Center(child:Text("No Sessions."))],
        ));
          }
        ),
      ),
      )));
  }



  getTimelineTiles(Map sessionMap){
    List<Widget> l = new List<Widget>();
    List sessions = widget.topic.sessions;
    if(sessions==null?false:sessions.isNotEmpty){
          sessions.forEach((sid) {
            Map session = sessionMap[sid];
            l.add(new TimelineTile(


              beforeLineStyle: LineStyle(
                thickness: 3,
                color: session['revisionNumber']==0?Colors.transparent:Colors.black.withOpacity(0.2)
              ),
              afterLineStyle: LineStyle(
                thickness: 3,
                color: session['revisionNumber']==(sessions.length-1)?Colors.transparent:Colors.black.withOpacity(0.2)
              ),
              indicatorStyle: IndicatorStyle(
                drawGap: true,
                width: 35,
                height: 35,
                color: session['sessionStatus']==SessionStatus.COMPLETED.toString()?Colors.red[900]:Colors.red,
                padding: EdgeInsets.symmetric(horizontal:10),
                indicator: CircleAvatar(
                  radius: 20,
                    backgroundColor: Colors.black.withOpacity(0.25),
                    child: CircleAvatar(
                      radius:14,
                      backgroundColor: session['sessionStatus']==SessionStatus.COMPLETED.toString()?Colors.transparent:session['revisionNumber']==widget.topic.latestRevisionNumber?Colors.white:Colors.red,
                      child: Icon(session['sessionStatus']==SessionStatus.COMPLETED.toString()?
                        Icons.check:(session['revisionNumber']==widget.topic.latestRevisionNumber?
                        Icons.play_arrow:Icons.lock_outline),
                        size: 17,
                        color: session['revisionNumber']==widget.topic.latestRevisionNumber?Colors.redAccent:Colors.white,
                        ),
                    ),
                  ),

                
              ),





              endChild: Card(
                shape: RoundedRectangleBorder(side: BorderSide(color: session['revisionNumber']==widget.topic.latestRevisionNumber?Colors.white:Colors.transparent,width: 2),borderRadius: BorderRadius.all(Radius.circular(10))),
                color: session['sessionStatus']==SessionStatus.COMPLETED.toString()?Colors.black.withOpacity(0.4):Colors.black.withOpacity(0.1),
                elevation: 0,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(session['revisionNumber']==0?"First Study":"Revision "+session['revisionNumber'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                              SizedBox(width: 0,height: 5,),
                              Text(session['scheduledTime'].substring(0,10),style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Center(child: Text("+10 xp",style: TextStyle(color: Colors.white)),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
    });
    }
    else{
      l.add(Text("No Sessions."));
    }

    return l;
  }

}