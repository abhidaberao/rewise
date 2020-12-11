
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:ionicons/ionicons.dart';
import 'package:myapp/database/db_classes.dart';
import 'package:myapp/database/provider.dart';
import 'package:myapp/design/rew_icon_icons.dart';
import 'package:myapp/design/topic_card.dart';
import 'package:myapp/database/provider.dart';

class SubjectPage extends StatefulWidget{
  
  var data;
  final DatabaseReference uidref;
  Function sscb;
  Subject subject;
  SubjectPage(this.subject,this.data,this.uidref,this.sscb);

  @override
  _SubjectPageState createState()=> _SubjectPageState();

}

class _SubjectPageState extends State<SubjectPage> {

  TextEditingController scontroller = new TextEditingController();

  void _sscb(){
    setState(() {
      
    });
    print("subject page reset");
  }

  @override
  Widget build(BuildContext context) {

    scontroller.addListener(() {
      setState(() {
        
      });
    });

    return Container(
      color: Colors.redAccent,
      child: SafeArea(
      child : 
      Hero(
        tag: widget.subject.subjectId+'scaf',
      child:Scaffold(
        backgroundColor: Colors.redAccent,
        appBar: AppBar(
          actions: [
          IconButton(icon: Icon(Icons.edit, color: Colors.white, size: 20),
          onPressed: (){
            editSubjectDialog();
          },
          )
        ],
          backgroundColor: Colors.redAccent.shade200,
          title: 
          Text(widget.subject.name,overflow: TextOverflow.fade, softWrap: false,),),
        
      body: Column(
          children: [
            Expanded(
              child: Container(child: FutureBuilder(
                  future: FBProvider.subjects.child(widget.subject.subjectId).child("topics").once(),
                  builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot){
                  var tpdata;
                  if(snapshot.hasData && snapshot.data!=null){
                    tpdata = snapshot.data.value;
              return SingleChildScrollView( 
                child:Column(
                  children: getTopicCard(tpdata),
                ));
                  }
                  else{
                    return Container(
                      child: Center(
                        child: Icon(
                          Icons.cloud_circle
                        ),
                      ),
                    );
                  }

                }),),
            ),
            Container(
        color: Colors.black.withOpacity(0.25),
        padding: EdgeInsets.symmetric(vertical : 0, horizontal: 30),
      child: TextFormField(
        controller: scontroller,
        decoration: InputDecoration(
          hintText: "find topic",
          hintStyle: TextStyle(color: Colors.white),
          icon: Icon(Ionicons.search_outline,size: 20,color: Colors.white,),
          contentPadding: EdgeInsets.symmetric(horizontal:0),
          border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(0.0))),
        ),
      ),),
          ]
        ),

      floatingActionButton: 
      
        FlatButton(
                    color: Colors.white,                  
                    shape: StadiumBorder(),
                    child: FittedBox(child: 
                                        Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[Icon(Icons.add,color: Colors.redAccent,),Text(" Topic",style: TextStyle(color: Colors.redAccent,fontFamily: "Kelson"),)],),),
                    onPressed: (){
                        newTopicDialog(widget.data);
                    },
                  ),       
                  ),
      )));
  }

  getTopicCard(Map tpdata){
    List _topics = new List();
    tpdata?.forEach((tid, tdata) {
      _topics.add(Topic.idMapToObj(tid, tdata));
    });

    if(_topics.isNotEmpty){
    List<Widget> topicCards = []; 
    _topics.forEach((topic) { 
      
      if(topic.name.toLowerCase().contains(scontroller.text.toLowerCase())){
        topicCards.add(
        TopicCard(topic,_sscb)
      );
      }
    });
  return topicCards;}
  else{
    return [Text("")];
  }
  }

  newTopicDialog(var data){
    List<DropdownMenuItem> subjects = [];
    Map submap = data['data']['subjects'];
    submap.forEach((id, subdata) { 
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
              title: 
              RichText(
                overflow: TextOverflow.fade, softWrap: false,
                text: TextSpan(
                  text: '',
                  style: TextStyle(fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(text: 'New Topic in ',style: TextStyle(fontSize: 20,color: Colors.black) ),
                    TextSpan(text: widget.subject.name, style: TextStyle(fontSize: 20, color: Colors.red)),
                  ],
                ),
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
                  CupertinoButton(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.redAccent,
                    child: Row(children: [
                      Text("Add"),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: (){
                      String newTopicKey = widget.uidref.child('data').child('subjects').child(widget.subject.subjectId).child("topics").push().key;
                      widget.uidref.child('data').child('subjects').child(widget.subject.subjectId).child("topics").child(newTopicKey).child('name').set(topnamec.text);
                      widget.uidref.child('data').child('subjects').child(widget.subject.subjectId).child("topics").child(newTopicKey).child('subjectId').set(widget.subject.subjectId);
                      widget.uidref.child('data').child('subjects').child(widget.subject.subjectId).child("topics").child(newTopicKey).child('latestRevisionNumber').set(0);
                      widget.uidref.child('data').child('subjects').child(widget.subject.subjectId).child("topics").child(newTopicKey).child('mastery').set(0);

                      setState((){

                      });

                      Navigator.pop(context);
                      
                    },
                  ),
                ],
            
            );
      },
    );
  },
);
}

    editSubjectDialog(){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    DatabaseReference uidRef = FirebaseDatabase.instance.reference().child("users").child(user.uid);

    TextEditingController subnamec = new TextEditingController(text: widget.subject.name);
    showDialog(
        context: context,
        builder: (context){

          String sel_emoji = widget.subject.emoji;

        return StatefulBuilder(
          builder: (context,setState)=> SimpleDialog(
          elevation: 0,
          contentPadding: EdgeInsets.all(20),
              title: Row(
                children: [
                  Expanded(
                    child: Text("Edit Subject"),
                  ),
                  IconButton(
                    color: Colors.grey,
                    padding: EdgeInsets.all(0),
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
                              widget.subject.topics?.forEach((t) {
                                t.sessions?.forEach((s) {
                                  uidRef.child('data').child('sessions').child(s).remove();
                                });
                              });
                              uidRef.child('data').child('subjects').child(widget.subject.subjectId).remove();

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              setState((){

                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  );
                    },
                  )
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EmojiPicker(
                          onEmojiSelected: (emoji,category){
                            setState(() {
                              sel_emoji = emoji.emoji;
                            });
                            Navigator.of(context).pop();
                          }
                          ),
                        ]
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
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(5.0)))
                  ),
                ),),
                
                
                ]),
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
                      uidRef.child("data").child("subjects").child(widget.subject.subjectId).child("name").set(subnamec.text);
                      uidRef.child("data").child("subjects").child(widget.subject.subjectId).child("emoji").set(sel_emoji);
                      Navigator.pop(context);
                      setState(() {
                        
                      });
                    },
                  ),

                ],
            ));});
  }
  



}


 

