
import 'package:flutter_web/material.dart';
import 'package:flutter_web/semantics.dart';
import 'package:myapp/design/rew_icon_icons.dart';

class StatsPage extends StatefulWidget{

  Map data;
  StatsPage(this.data);
  @override
  _StatsPageState createState()=> _StatsPageState();

}

class _StatsPageState extends State<StatsPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
      child : Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("🍅 Lifetime"),
                          Text("10K Hr", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: 'Kelson',color: Colors.redAccent),),
                          SizedBox(height: 10,),
                          Text("🎯 Mastery"),
                          Text("96 %", style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontFamily: 'Kelson',color: Colors.redAccent),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                //thickness: 1,
                indent: 40,
                //endIndent: 40,
              ),
              Center(child: Text("Section under work!"),)
            ],
          ),
        ),
      ),
      )));
  }


}

class TabCard extends StatefulWidget{

  Widget content1,content2;
  String title1,title2;
  TabCard({this.title1,this.content1,this.title2,this.content2});

  @override
  TabCardState createState()=> TabCardState();

}

class TabCardState extends State<TabCard>{

  int tab = 1;


  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all((20)),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.only(top:10,left:20,right:20),
          title: Row(children: [
            GestureDetector(
              child: Text(widget.title1, style: TextStyle(fontSize: 15,color: tab==1?Colors.black:Colors.grey),),
              onTap: (){
                setState(() {
                  tab = 1;
                });
              },
            ),
            Text(" / ", style: TextStyle(fontSize: 15,color: Colors.grey),),
            GestureDetector(
              child: Text(widget.title2, style: TextStyle(fontSize: 15,color: tab==2?Colors.black:Colors.grey),),
              onTap: (){
                setState(() {
                  tab = 2;
                });
              },
            ),          ],),
          subtitle: tab==1?widget.content1:widget.content2,
        ),
      ),
    );

  }
}