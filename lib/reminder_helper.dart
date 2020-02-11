import 'package:bipo/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sign_in.dart';
import 'data.dart';
import 'dashBoard.dart';
import 'package:clay_containers/clay_containers.dart';
import 'main.dart' as main;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


bool activateReminder=true;


/*
Future<void> _showDailyAtTime() async {
  if(activateReminder){
    var time = Time(17, 15, 0);
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
  }}*/
