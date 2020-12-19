import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web/material.dart';
import 'package:myapp/database/db_classes.dart';
import 'package:myapp/pages/stats_page.dart';
import 'package:myapp/pages/subject_page.dart';
import 'package:myapp/pages/syllabus.dart';
import 'rew_icon_icons.dart';
import 'package:myapp/database/db_classes.dart';

class SubjectCard extends StatefulWidget{

  Subject subject;
  var data;
  DatabaseReference uidref;
  Function setStateCallback;
  SubjectCard(this.subject,this.data,this.uidref,this.setStateCallback);
  SubjectCardState createState() => new SubjectCardState();
}

class SubjectCardState extends State<SubjectCard>{

  void cscb(){
    widget.setStateCallback();
    setState(() {
      
    });
    print("subject card reset");
  }

@override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: (){
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubjectPage(widget.subject,widget.data,widget.uidref,cscb),
        ));
      },
      child:
      Hero(
        tag: widget.subject.subjectId+'scaf',
        child:Card( 
                elevation: 5,
                shadowColor: Colors.red,
                color:Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(width: 0,color: Colors.grey.shade300)),
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child: 
              Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[Text(widget.subject.name,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'OpenSans',fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),overflow: TextOverflow.fade, softWrap: false,),
                
                        widget.subject.emoji!=null?Expanded(
                          child: Center(
                            child: Text(widget.subject.emoji,style: TextStyle(fontSize: 50),),
                          ),
                        ):SizedBox(height: 0,width: 0,),

                        Center(child: LinearProgressIndicator(
                            value: 0.5,
                            backgroundColor: Colors.red,
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),),
                      ],
                    ),
                  ),)));
  }


 Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

}