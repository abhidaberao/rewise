import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/semantics.dart';
import 'package:myapp/design/rew_icon_icons.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/database/auth.dart';
import 'package:fluttie/fluttie.dart';

class AuthPage extends StatefulWidget{

  AuthPage({this.auth, this.loginCallback,this.rootRef});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  DatabaseReference rootRef;
  @override
  _AuthPageState createState()=> _AuthPageState();

}

class _AuthPageState extends State<AuthPage> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference userRootRef,usernameRef;

  double currentOpacity = 0;
  String signmode = "Login", option = "New user?";
  TextEditingController emailc = new TextEditingController();
  TextEditingController passc = new TextEditingController();
  var fluttie = Fluttie();
  FluttieAnimationController _fluttieAnimationController;

  

  Color primaryColor = Colors.red;
  Color accentColor = Colors.redAccent;

  bool emailValidity = false, passValidity = false;
  String emailWarning = "email", passWarning = "password";
  String _errorMessage;
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();

    userRootRef = widget.rootRef.child('users');
    usernameRef = widget.rootRef.child('usernames');

    WidgetsBinding.instance.addPostFrameCallback((timestamp){
      setState(() {
        currentOpacity = 1;
      });

      emailc.addListener(() {
        validateEmail(emailc.text);
      });

      passc.addListener(() {
        validatePass(passc.text);
      });

    });

    
  }


  validateEmail(String email){
    setState(() {
      emailValidity = EmailValidator.validate(email);
      emailWarning = "not a valid mail";
    });
  }

  validatePass(String pass){
    if(pass.length<8){
      setState(() {
        passValidity = false;
        passWarning = "at least 8 letters";
      });
    }
    else{
      setState(() {
        passValidity = true;
      });
    }
  }

bool validateAndSave(){
  if(emailValidity && passValidity){
    return true;
  }
  else{
    return false;
  }
}

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (signmode == "Login") {
          print('here');
          userId = await widget.auth.signIn(emailc.text, passc.text);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(emailc.text, passc.text);
          widget.auth.sendEmailVerification();
          createNodeForUser(userId,emailc.text);
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && (signmode == "Login")) {
          if(await widget.auth.isEmailVerified()){
          widget.loginCallback();
          }
          else{
            _showVerifyEmailSentDialog();
          }
        }
        if (userId.length > 0 && userId != null && (signmode == "Signup")) {
          setState(() {
            signmode = "Login";
          });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
  }

  createNodeForUser(userId,email){
    userRootRef.child(userId).set({
      "email" : email,
      "username" : userId
    });
    usernameRef.child(userId).set(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
      children : [ 
        SafeArea(
        child: 
        Scaffold(
      body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width/1.6,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedOpacity(
                opacity: currentOpacity,
                duration: Duration(seconds: 3),
                child: Text("Hello,",style: TextStyle(fontFamily: 'Kelson', color: Colors.black, fontWeight: FontWeight.w400,fontSize: 30),),
        
              ),

              AnimatedOpacity(
                opacity : currentOpacity,
                duration: Duration(seconds: 2),
                child: Text("This is Rewise.",style: TextStyle(fontFamily: 'Kelson', color: Colors.black, fontWeight: FontWeight.w300, fontSize: 30),), 
                ),
                SizedBox(height: 30),
              AnimatedOpacity(
                opacity: currentOpacity,
                duration: Duration(seconds: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ButterTextField(
                      bcontroller: emailc,
                      btext: "email",
                      validity: emailValidity,
                      warning: emailWarning,
                      bicon: Icon(Icons.mail_outline),
                      btype: TextInputType.emailAddress,),
                    SizedBox(height: 15),
                    ButterTextField(
                      bcontroller: passc,
                      btext: "password",
                      validity: passValidity,
                      warning: passWarning,
                      bicon: Icon(Icons.lock_outline),
                     // btype: TextInputType.visiblePassword,
                     ),                    
                    SizedBox(height:30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                          alignment: Alignment.centerLeft,
                            child: IconButton(
                                    icon: Icon(RewIcons.google,color: accentColor,),
                                    onPressed: (){
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      widget.auth.signInWithGoogle().then((FirebaseUser user){
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if(signmode=="Signup"){
                                          createNodeForUser(user.uid,user.email);
                                          widget.loginCallback();
                                        }
                                        if(signmode=="Login"){
                                          if(user.metadata.creationTime==user.metadata.lastSignInTime){
                                            print(".........new but by mistake here......");
                                            createNodeForUser(user.uid,user.email);
                                            widget.loginCallback();                                           
                                          }
                                          else{
                                            print(".........old really......");
                                            widget.loginCallback();
                                          
      
                                          }
                                        }
                                        
                                      });
                                      
                                    },
                                  ),
                              
                            ),
                        ),
                        
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(child: Text(signmode,style: TextStyle(color : Colors.white),), 
                            onPressed: validateAndSubmit,
                      color: accentColor,
                      shape: StadiumBorder(),
                      ),),
                          ),
                    ],),

                    

                    FlatButton(child: Text(option,style: TextStyle(color:Colors.grey),),
                            shape: StadiumBorder(),
                            onPressed: (){
                              setState(() {
                                if(signmode=="Login"){
                                  signmode="Signup";
                                  option = "Old user?";
                                }
                                else{
                                  signmode="Login";
                                  option = "New user?";
                                }
                              });
                            },
                            ), 
                  ],
                ),
              ),
            ],
            ),),
      ),
      )),
      Visibility(
        visible: _isLoading,
        child: Opacity(
                opacity: 0.9,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Opacity(child: Image.asset("gifs/hourglass.gif"),opacity: 1.0,),
                  ),
                ),
          ),
      ),
      ]));
  }


_showVerifyEmailSentDialog(){
    return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Verify Email'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('We have sent a confirmation mail to you,'),
              Text('please verify your mail and login.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Resend Email'),
            onPressed: () {
              widget.auth.sendEmailVerification();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


}

class ButterTextField extends StatelessWidget{

String btext, warning;
Icon bicon;
TextEditingController bcontroller;
TextInputType btype;
bool validity;

ButterTextField({this.btext,this.bcontroller,this.bicon,this.btype,this.validity,this.warning});

@override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          labelText: (validity==null)?null:(validity?null:warning),
          icon: bicon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: btext
        ),
        controller: bcontroller,
        keyboardType: btype,
       // obscureText: (btype==TextInputType.visiblePassword)?true:false,
      ),
    );
  }

}