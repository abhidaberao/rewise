
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FBProvider {

static FirebaseAuth auth = FirebaseAuth.instance;
static User user = auth.currentUser;
static String uid = user.uid;
static DatabaseReference root = FirebaseDatabase.instance.reference().child("users").child(user.uid);
static DatabaseReference subjects = root.child("data").child("subjects");
static DatabaseReference sessions = root.child("data").child("sessions");
static DatabaseReference usernamesRef = FirebaseDatabase.instance.reference().child("usernames");



FBProvider();

} 