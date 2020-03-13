import 'package:cloud_firestore/cloud_firestore.dart';
import 'data.dart';
import 'sign_in.dart';
class Note {
  Note(this.date, this.note);

  final DateTime date;
  final String note;


  @override
  String toString() {
    return '{ ${this.date}, ${this.note} }';
  }



}



Future <List<Map<dynamic, dynamic>>> getNotesCollection() async {
  List<DocumentSnapshot> templist;
  List<Map<dynamic, dynamic>> list = new List();
  CollectionReference collectionRef = Firestore.instance.collection("users")
      .document(uid)
      .collection('notes');
  QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

  templist = collectionSnapshot.documents; // <--- ERROR

  list = templist.map((DocumentSnapshot docSnapshot) {
    return docSnapshot.data;
  }).toList();

  return list;
}