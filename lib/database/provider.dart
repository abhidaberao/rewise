
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FBProvider {

static FirebaseAuth auth = FirebaseAuth.instance;
static FirebaseUser user;
static String uid;
static DatabaseReference root;
static DatabaseReference subjects ,sessions ,usernamesRef;


getuser()async{
  user = await auth.currentUser();
}

FBProvider(){
  
   getuser();
   uid = user.uid;
   root = FirebaseDatabase.instance.reference().child("users").child(user.uid);
   subjects = root.child("data").child("subjects");
   sessions = root.child("data").child("sessions");
   usernamesRef = FirebaseDatabase.instance.reference().child("usernames");
}

} 