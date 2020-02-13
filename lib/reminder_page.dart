/*
import 'package:bipo/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sign_in.dart';
import 'data.dart';
import 'dashboard.dart';
import 'package:clay_containers/clay_containers.dart';
import 'main.dart' as main;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'reminder_helper.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}
bool activateReminder=true;
class _ReminderPageState extends State<ReminderPage> {
  List<TimeOfDay> reminderTime;






Future<Null> selectReminderTime(BuildContext context)async {
  var pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour:20, minute: 0));
  if(pickedTime!=null){
    setState(() {
      reminderTime.add(pickedTime);
      data_instance.collection('users').document(uid).collection(
          "reminderTime").document(reminderTime.toString()).setData({'reminderTime':reminderTime});
    });

  }


}
  @override
  Widget build(BuildContext context) {
    Future<QuerySnapshot> ti=  data_instance.collection('users').document(uid).collection(
        "reminderTime").getDocuments().then((time){
          print('TIME'+ '${time.documents[0].data}');
        reminderTime.add(TimeOfDay(hour:int.parse(time.documents[0].data.toString().substring(0,1)),minute: int.parse(time.documents[0].data.toString().substring(2,3))));
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        centerTitle: true,
        title: new Text(
          "Bipol'Air", textAlign: TextAlign.center,
          textScaleFactor: 0.8,
          style: new TextStyle(
            fontFamily: 'dot',
            color: Colors.white,),),


        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('images/logo.png'),
        ),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Tooltip(message: 'Retour',
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
                            Icons.arrow_back,
                          ),
                        ),
                      ),


                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Bipol'Air peut vous notifier en fin de journée \n afin de ne pas oublier d'enregistrer\nvotre humeur quotidienne.", textAlign: TextAlign.center,textScaleFactor: 1.2,),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Image.asset('images/logo.png',height: 200,),
                    Padding(
                      padding: EdgeInsets.only(right:200.0),
                      child: Text("Rappel :", textAlign: TextAlign.center,textScaleFactor: 1.2),
                    ),
                    Switch(
                      value: activateReminder,
                      onChanged: (value) {
                        setState(() {
                          activateReminder = value;
                        });
                        if(activateReminder){_showDailyAtTime();}
                      },
                      activeTrackColor: Colors.teal[200],
                      activeColor: Colors.teal,
                    ),

                    (activateReminder)?Padding(
                      padding: const EdgeInsets.only(top:250.0),
                      child: FlatButton(color:Colors.teal,child:Text("Choisir l'heure",style:TextStyle(color: Colors.white)),onPressed:()=> selectReminderTime(context),),
                    ):Container(),

                  ],
                ),
              ),





















            ],
          ),
        ),
      ),
    );
  }

  */
/*Future<void> _showDailyAtTime() async {
    //if(activateReminder){
      var time = Time(17, 45, 0);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'repeatDailyAtTime channel id',
          'repeatDailyAtTime channel name',
          'repeatDailyAtTime description');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await main.flutterLocalNotificationsPlugin.showDailyAtTime(
          0,
          "Il est l'heure d'enregistrer votre humeur !",
          "Cliquez pour ouvrir Bipol'air",
          time,
          platformChannelSpecifics);
   // }
}
*//*

}
*/
