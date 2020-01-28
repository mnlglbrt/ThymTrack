import 'package:bipo/dashBoard.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'dashBoard.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    print(name);
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
                  SizedBox(height: 300,),
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
          height: 150,
          width: 150,
          borderRadius: 75,
          depth: 10,
          spread: 10,
          child: Center(
            child: ClayText('G',style: TextStyle(fontFamily: 'productSans'),size: 60,),
          ),
        ),
      ),
    );
  }
}
