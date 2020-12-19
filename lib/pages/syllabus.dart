


import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/semantics.dart';
import 'package:ionicons/ionicons.dart';
import 'package:myapp/design/rew_icon_icons.dart';
import 'package:myapp/design/subject_card.dart';
import 'package:myapp/database/db_classes.dart';

class SyllabusPage extends StatefulWidget{

  var data;
  Function setStateCallback;
  final DatabaseReference uidref;
  SyllabusPage(this.data,this.uidref,this.setStateCallback);

  @override
  _SyllabusPageState createState()=> _SyllabusPageState();

}

class _SyllabusPageState extends State<SyllabusPage> {

  TextEditingController scontroller = new TextEditingController();

  spcb(){
    widget.setStateCallback();
    setState(() {
      
    });
    print("syllabus page reset");
  }

  @override
  Widget build(BuildContext context) {
    
    scontroller.addListener(() {
      setState(() {
        
      });
    });

    return Container(
      color: Colors.white,
      child: SafeArea(
      child : Scaffold(
      body:Column(children: [
        Expanded(child:  Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        
          child: GridView.count(
            crossAxisCount: 2,
            children: getSubjectCards(),
          ),
        
      ),),
      Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(vertical : 0, horizontal: 30),
      child: TextFormField(
        autofocus: false,
        controller: scontroller,
        decoration: InputDecoration(
          hintText: "find subject",
          icon: Icon(Ionicons.search_outline,size: 20,),
          contentPadding: EdgeInsets.symmetric(horizontal:0),
          border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(0.0))),
        ),
      ),)
      ],),
      )));
  }


List<Widget> getSubjectCards(){
Map subjects = widget.data['data']!=null?widget.data['data']['subjects']:null;
List<Widget> subcardlist = new List<Widget>();

subjects?.forEach((id, subdata) {
  /*List<Topic> topics = [];
  Map rawTopics = subdata["topics"];

  if(subdata["topics"]!=null){
  rawTopics?.forEach((topicId, topicdata) {
    topics.add(new Topic(
      topicId: topicId,
      name: topicdata['name'],
      subjectId: id,

    ));
   });}*/
  Subject subject = new Subject.idMapToObj(id, subdata);
  if(subject.name.toLowerCase().contains(scontroller.text.toLowerCase()))
  {subcardlist.add(SubjectCard(subject,widget.data,widget.uidref,spcb));}
 });
 return subcardlist;
}

}

