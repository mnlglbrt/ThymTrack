import 'package:bipo/dashboard.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'dashboard.dart';
import 'package:clay_containers/clay_containers.dart';
import 'time_series_moods.dart';
import 'data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool signedIn=false;
  @override
  void initState() {
    super.initState();
    signInWithGoogle().whenComplete(() {
      getData().then((x){
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) {
                return DashBoard();
    }));});
  });
        }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(image: DecorationImage(image:AssetImage('images/background.png'),fit: BoxFit.fill)),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset('images/logo.png',height: 100,),
                  Text('Connexion',style:(TextStyle(color: Colors.grey[100])),textScaleFactor: 2.0,textDirection: TextDirection.ltr,),
                  SizedBox(height: 100,),
                  CircularProgressIndicator(valueColor:new AlwaysStoppedAnimation<Color>(Colors.teal[200]),backgroundColor: Colors.grey[200],),
                  SizedBox(height: 200,),
                  _signInButton(),
                  SizedBox(height: 100,)
                ],
              )
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(onTap: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return DashBoard();
              },
            ),
          );
        });
      },

        child: ClayContainer(
          color: Colors.grey[100],
          height: 100,
          width: 100,
          borderRadius: 75,
          depth: 10,
          spread: 10,
          child: Center(
            child: Icon(Icons.input,size: 40,color: Colors.grey[300],),
          ),
        ),
      ),
    );
  }
  Future<Null> getData() async {
    var col = getCollection();
    List<TimeSeriesMoods> myData = [];
    col.then((coll) {
      dataMoods.clear();
      coll.forEach((moo) {
        myData.add(TimeSeriesMoods(
            DateTime.parse(moo.keys.toString().substring(1, 11)),
            int.parse(moo.values.toString().substring(1, moo.values
                .toString()
                .length - 1))));
        print('data : $dataMoods');
      });
      setState(() {
        dataMoods.clear();
        dataMoods = myData;
        sevenDaysData = selectData([
          DateTime.now().subtract(Duration(days: 6)),
          DateTime.now().add(new Duration(days: 1))
        ]);
        thirtyDaysData = selectData([
          DateTime.now().subtract(Duration(days: 31)),
          DateTime.now().add(new Duration(days: 1))
        ]);
        print('data : $dataMoods');
      });
    });
  }

  Future <List<Map<dynamic, dynamic>>> getCollection() async {
    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list = new List();
    CollectionReference collectionRef = Firestore.instance.collection("users")
        .document(uid)
        .collection('moods');
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents; // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();

    return list;
  }



}
