import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/pages/auth_page.dart';
import 'package:myapp/pages/syllabus.dart';
import 'package:myapp/design/rew_icon_icons.dart';
import 'package:myapp/pages/stats_page.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'database/auth.dart';

Future<void> main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
        ));

  WidgetsFlutterBinding.ensureInitialized();


  final FirebaseApp app = await Firebase.initializeApp(
    name: 'rewise-77',
    options: FirebaseOptions(
          appId: '1:168741031551:android:03ccd93e5750b6b6b6f94a',
          apiKey: 'AIzaSyC9VYxXWS3nZRf30OzxHyytTfvmiFcofvg',
          projectId: 'rewise-77',
          messagingSenderId: '168741031551',
          databaseURL: 'https://rewise-77.firebaseio.com/',
          )
  );
  runApp(MaterialApp(
    title: 'Rewise',
    theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RootPage(auth: new Auth(),app : app),
  ));

}


class RootPage extends StatefulWidget{

  RootPage({Key key, this.auth,this.app}) : super(key: key);

  final BaseAuth auth;
  final FirebaseApp app;

@override
_RootPageState createState() => new _RootPageState();

}

class _RootPageState extends State<RootPage>{

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  String _userId = "", username;
  DatabaseReference rootRef,userRootRef,uidRef,usernamesRef;

  @override
  void initState() {
    super.initState();

    FirebaseDatabase database;
   database = FirebaseDatabase(app: widget.app);
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(20000000);
    rootRef = database.reference();
    userRootRef = FirebaseDatabase.instance.reference().child('users');
    usernamesRef = FirebaseDatabase.instance.reference().child('usernames');



    widget.auth.getCurrentUser().then((user){
      
      setState(() {
        if(user!= null){
          _userId = user?.uid;
          if(user.emailVerified){
          uidRef = FirebaseDatabase.instance.reference().child("users").child(user.uid);
          authStatus = user?.uid == null? AuthStatus.NOT_LOGGED : AuthStatus.LOGGED;
          }
          else {
            authStatus = AuthStatus.NOT_LOGGED;
          }
        }
        else{
          authStatus = AuthStatus.NOT_LOGGED;
        }
      });

    });
  }

  @override
  void dispose(){
    super.dispose();
    //cancel subs here
  }


  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        uidRef = FirebaseDatabase.instance.reference().child("users").child(user.uid);

      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED;
    });
  }

  void logoutCallback() {
    setState(() {
      widget.auth.signOut();
      authStatus = AuthStatus.NOT_LOGGED;
      _userId = "";
    });
  }


@override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED:
        return new AuthPage(
          auth: widget.auth,
          loginCallback: loginCallback,
          rootRef: rootRef
        );
        break;
      case AuthStatus.LOGGED:
        if (_userId.length > 0 && _userId != null) {
          return new MyHomePage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
            uidRef: uidRef,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }



buildWaitingScreen(){
  return Container(
    child: Center(
      child: Image.asset("gifs/hourglass.gif")
    ),
  );
}

}