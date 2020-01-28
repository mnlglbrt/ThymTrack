import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
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
                SizedBox(height: 200,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ClayContainer(
                    color: Colors.grey[100],
                    height: 150,
                    width: 150,
                    borderRadius: 75,
                    depth: 10,
                    spread: 10,
                    child: Center(
                      child: ClayText('f',style: TextStyle(fontFamily: 'productSans'),size: 60,),
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
