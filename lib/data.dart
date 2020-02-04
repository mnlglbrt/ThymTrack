
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'timeSeriesMoods.dart';
import 'package:shared_preferences/shared_preferences.dart';


/*final List<MoodEntry> data = [

];*/


final List<TimeSeriesMoods>data = [

];

Map <DateTime, int> onlineData={

};

List<TimeSeriesMoods>selectedData=[];

var pictures = {
  0:"Detresse",
  1:"Effondrement",
  2:"Triste",
  3:"Isolement",
  4:"Lourdeur",
  5:"Questionnement",
  6:"Embrumé",
  7:"brume",
  8:"brume",
  9:"brume",
  10:"brume",
  11:"brume",
  12:"brume",
  13:"brume",
  14:"brume",
  15:"brume",
  16:"brume",
  17:"brume",
  18:"brume",
};