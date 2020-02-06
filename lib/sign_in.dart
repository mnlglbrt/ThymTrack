import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data.dart';
import 'package:shared_preferences/shared_preferences.dart';
String name;
String email;
String imageUrl;
String uid;
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final data_instance = Firestore.instance;
final fire_users = data_instance.collection('users');

addUserToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('uid', uid);
  prefs.setString('name', name);
  prefs.setString('email', email);
  prefs.setString('imageUrl', imageUrl);
}
deleteUserFromSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('uid', "");
  prefs.setString('name', "");
  prefs.setString('email', "");
  prefs.setString('imageUrl', "");
}

addUser(String uid, Map<String,dynamic> map){
  fire_users.document(uid).setData(map);
}



Future<String> signInWithGoogle() async {


  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =

  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;
  uid=user.uid;
  //addUserToSF();



  Map <String, dynamic> map={
    "name":name,
    "email":email,
    "imageUrl":imageUrl,
    "uid":uid,
    "userType":"patient",
  };
  fire_users.document(uid).setData(map);

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';


}



void signOutGoogle() async{
  await googleSignIn.signOut();
  deleteUserFromSF();
  print("User Sign Out");
}

getUserFromSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  Map<String,String> user={};
  user.update('uid', (dynamic val) =>prefs.getString('uid'),ifAbsent: () => prefs.getString('uid'));
  user.update('name', (dynamic val) =>prefs.getString('name'),ifAbsent: () => prefs.getString('name'));
  user.update('email', (dynamic val) =>prefs.getString('email'),ifAbsent: () => prefs.getString('email'));
  user.update('imageUrl', (dynamic val) =>prefs.getString('imageUrl'),ifAbsent: () => prefs.getString('imageUrl'));
  return user;
}