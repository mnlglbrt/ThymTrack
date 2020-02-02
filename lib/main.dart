
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';


void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bipolair',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        //canvasColor: Colors.transparent,
      ),
      home: LoginPage(),
    );
  }
}

///OLD SPLASHSCREEN PAGE
/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tableau_de_bord.dart';
import 'dashBoard.dart';
import 'dart:math';
import 'package:splashscreen/splashscreen.dart';
import 'package:bipo/authentication.dart';
import'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var connectedUser=null;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bipol'Air",
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: "Bipol'Air"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    return

  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Auth();
  }

return
      Stack(
        children:<Widget>[

          SplashScreen(
          seconds: 1,
          navigateAfterSeconds: new AfterSplash(),
          title: new Text("Bipol'Air",textAlign: TextAlign.center,
            style: new TextStyle(
                fontFamily: 'simplePrint',
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 30.0
            ),),
          image: new Image.asset('images/logo.png',width: 200.0,),
          backgroundColor: Colors.teal,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize:200.0,
          onClick: ()=>print("vers Tableau de bord"),
          loaderColor: Colors.white
    ),
      ]);
*/


