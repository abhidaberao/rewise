

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/semantics.dart';
import 'package:myapp/database/provider.dart';
import 'package:myapp/design/rew_icon_icons.dart';

class ProfilePage extends StatefulWidget{

  Map data;

  ProfilePage(this.data);

  @override
  ProfilePageState createState()=> ProfilePageState();

}

class ProfilePageState extends State<ProfilePage> {

  bool editMode = false;
  bool gtaken = null;
  bool validating = false;
  bool valid = true; 
  bool showNotValid = false;

  @override
  Widget build(BuildContext context) {

    TextEditingController usernameC = new TextEditingController(text: widget.data['username']);
    usernameC.addListener(() {
    });

    return Scaffold(
        backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Expanded(child: SizedBox(),),

              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.red,
              ),
              SizedBox(height: 20,),

              
              Card(
                elevation: 0,
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(left: 20,right:10,bottom:10,top: 10),
                  child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                                                labelText: "Username",
                        disabledBorder: UnderlineInputBorder(borderSide : BorderSide.none),
                    
                      ),
                      enabled: editMode,
                      style: TextStyle(fontSize: 15),
                      
                          textAlign: TextAlign.center,
                          controller: usernameC,
                        )//:Text(widget.data['username'], style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold),softWrap: false,overflow: TextOverflow.fade,),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(0),
                    iconSize: 20,
                    icon: Icon(editMode?Icons.cancel:Icons.edit),
                    onPressed: (){
                      setState(() {
                        editMode = !editMode;
                        gtaken = null;
                        showNotValid = false;
                      });
                    },
                  )
                ],
              )))
              ,

              SizedBox(height: 20,),

              validating?
              Card(
                elevation: 0,
                color: Colors.blue[50],
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      ),
                        SizedBox(
                          width: 10,
                        ),
                      Expanded(
                        child: Text("Validating."),
                      )
                    ],
                  ),
                ),
              ):
              gtaken!=null&&editMode?Card(
                elevation: 0,
                color: gtaken?Colors.red[50]:Colors.green[50],
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        gtaken? Icons.warning:Icons.check,
                        size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      Expanded(
                        child: Text(gtaken?"This username is taken.":"Successfully changed."),
                      )
                    ],
                  ),
                ),
              ):
              SizedBox(width: 0,height: 0,),

              showNotValid?Card(
                elevation: 0,
                color: Colors.grey[100],
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        size: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      Expanded(
                        child: Text("Only use alphabets, numbers and '_'"),
                      )
                    ],
                  ),
                ),
              ):
              SizedBox(width: 0,height: 0,),

              Expanded(child: SizedBox(),),

              RaisedButton(

                color: editMode?Colors.redAccent:Colors.white,
                shape: StadiumBorder(),
                child: Text(editMode?"Save":"Exit",
                style: TextStyle(
                  color: editMode?Colors.white:Colors.redAccent
                ),),
                onPressed: (){
                  if(editMode){
                    changeUsername(usernameC.text);
                  }
                  else{
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      );
  }



 changeUsername(String u){
   
 }

  checkAvailability(String username) async{
    setState(() {
      validating = true;
    });
    if(validate(username)){
      showNotValid = true;
    DatabaseReference usernameRef = FBProvider.usernamesRef;
    DataSnapshot ds = await usernameRef.once();
    Map u = ds.value;
    bool taken = u?.keys?.contains(username);
    if(taken){
      setState(() {
        gtaken = true;
      });
      print(gtaken);
    }
    else{
      setState(() {
        gtaken = false;
      });
      print(gtaken);
    }
        setState(() {
      validating = false;
    });}

    else{
      setState(() {
        validating = false;
        showNotValid = true;
      });
    }
  }

  bool validate(String u){
    List alphaNum = [
      'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
      'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
      '0','1','2','3','4','5','6','7','8','9','_'
    ];
    for(int i = 0;i<u.length;i++){
      if(!alphaNum.contains(u[i])){
        return false;
      }
    }
    return true;
    
  }
  


}
