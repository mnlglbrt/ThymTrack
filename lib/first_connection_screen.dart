import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'data.dart';
import 'mood_ranges.dart';
import 'time_series_moods.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'dart:async';
import 'package:clay_containers/clay_containers.dart';




class FirstLogScreen extends StatefulWidget {
  FirstLogScreen({Key key}) : super(key: key);


  @override
  _FirstLogScreenState createState() => _FirstLogScreenState();

}

class _FirstLogScreenState extends State<FirstLogScreen> {


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          centerTitle: true,
          backgroundColor: Colors.teal,

          title: new Text(
            "Bienvenue", textAlign: TextAlign.center,
            textScaleFactor: 0.8,
            style: new TextStyle(
              fontFamily: 'dot',
              color: Colors.white,),),

          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/logo.png'),
          ),
        ),

        body:SingleChildScrollView(
          child:Column(
            children: <Widget>[
              Tooltip(message: 'Suivant',
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0,),
                    child: ClayContainer(
                      borderRadius: 75,
                      depth: 20,
                      spread: 10,
                      width: 40,
                      height: 40,
                      color: Colors.teal,
                      child: CircleAvatar(
                        radius: 35,
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_forward,
                          ),
                        ),
                      ),


                    ),
                  ),
                ),
              ),
            ],
          )
        )
    );
  }
}