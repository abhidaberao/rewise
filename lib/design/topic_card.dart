

import 'dart:developer';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';
import 'package:myapp/database/db_classes.dart';
import 'package:myapp/database/provider.dart';
import 'package:myapp/design/session_timeline_page.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TopicCard extends StatelessWidget{

  Topic topic;
  Function sscb;
  TopicCard(this.topic,this.sscb);
  DatabaseReference subref = FBProvider.subjects;
  DatabaseReference sesref = FBProvider.sessions;



  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
          margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 0),
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent,width: 0),borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 0,
        child: Theme(
          data: ThemeData(accentColor: Colors.black),
          child: ExpansionTile(
            trailing: Icon(Icons.more_vert),
            childrenPadding: EdgeInsets.all(0),
        title: Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                        children: [ 
                          Expanded(
                          child: 
                            Text(topic.name,style: TextStyle(fontFamily: 'OpenSans',fontSize: 15,fontWeight: FontWeight.bold, ), overflow: TextOverflow.fade, softWrap: false,) ,                          
                        ),
                        
                        ]),
                      ],
                    ),
                  ),
                  
        children: [
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

            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit,size: 15,),
                            Text("  Edit Topic"),
                          ],
                        ),
                        onPressed: (){
                          editTopicDialog(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.list,size: 15,),
                            Text("  Sessions"),
                          ],
                        ),
                        onPressed: (){
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>SessionTimeline(topic),
                            ));                         
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

        ],
                  
                  )));
  }


    editTopicDialog(BuildContext context){

    showDialog(
  context: context,
  builder: (context) {
    TextEditingController topnamec = new TextEditingController(text: topic.name);
    return StatefulBuilder(
      builder: (context, setState) {
        return SimpleDialog(
          elevation: 0,
          contentPadding: EdgeInsets.all(20),
              title: Row(
                children: [
                  Text("Edit Topic", style: TextStyle(fontSize: 20),overflow: TextOverflow.fade, softWrap: false,),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                                           showDialog(context: context,
                  builder: (context) => new SimpleDialog(
                    title: Text("Deleting this subject will delete all topics and session related to it."),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            child: Text('Cancel',style: TextStyle(color: Colors.red),),
                            color: Colors.transparent,
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Delete',style: TextStyle(color: Colors.redAccent),),
                            color: Colors.transparent,
                            onPressed: (){
                         topic.sessions?.forEach((sesId) {
                          sesref.child(sesId).remove();
                        });
                        subref.child(topic.subjectId).child("topics").child(topic.topicId).remove();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        sscb();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  );

                        
                      }),
                    ),
                  )
                ],
              ),
              children: [
                TextFormField(
                  controller: topnamec,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(5.0)))
                  ),
                ),

                Divider(color: Colors.transparent,),
                  CupertinoButton(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.redAccent,
                    child: Row(children: [
                      Text("Save"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: (){
                      subref.child(topic.subjectId).child("topics").child(topic.topicId).child('name').set(topnamec.text);   
                      Navigator.pop(context);
                      sscb();
                    },
                  ),
                ],
            
            );
      },
    );
  },
);
}


  getSessionTiles(Map sessions, Topic topic){
    List<Widget> tiles = new List<Widget>();
    int n=0;
    tiles.add(Container(
      padding: EdgeInsets.only(right:20,left:20,bottom:10),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Planned Revisions",style:TextStyle(fontFamily: 'OpenSans',fontSize: 15,fontWeight: FontWeight.bold))),
          Expanded(
            child:Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.edit,size: 15,),
              onPressed: (){},
            )),  ),          

        ],
      )));
    if(topic.sessions!=null&&topic.sessions.isNotEmpty){topic.sessions.forEach((s) {
      s = sessions[s];
      tiles.add(   TimelineTile(
                    endChild: Card(
                      color: s['sessionStatus']==SessionStatus.COMPLETED.toString()?Colors.redAccent:Colors.white,
                      margin: EdgeInsets.symmetric(vertical:5,horizontal: 10),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          s['revisionNumber']==0?"First Study":"Revision "+s['revisionNumber'].toString(),
                          style: TextStyle(
                            color: s['sessionStatus']==SessionStatus.COMPLETED.toString()?Colors.white:Colors.redAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),),
                      ),
                    ),
                  indicatorStyle: IndicatorStyle(
                    width: 10,
                    color: Colors.grey.shade300
                  ),
                  beforeLineStyle: LineStyle(
                    color: n==0?Colors.transparent:Colors.grey.shade300
                  ),
                  afterLineStyle: LineStyle(
                    color: n==sessions.length-1?Colors.transparent:Colors.grey.shade300
                  ),
                ));

        n++;
    });
    
    return tiles;
    }

    else{
      return [Container(
        child: Center(child: Text("No Sessions."),))];
    }

    
  }

  

  

}

