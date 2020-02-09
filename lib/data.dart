
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'timeSeriesMoods.dart';
import 'package:shared_preferences/shared_preferences.dart';


/*final List<MoodEntry> data = [

];*/
var sevenDaysData=selectData([DateTime.now().subtract(Duration(days:6)),DateTime.now().add(new Duration(days: 1))]);
var thirtyDaysData=selectData([DateTime.now().subtract(Duration(days:31)),DateTime.now().add(new Duration(days: 1))]);
DateTime today=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,);

 List<TimeSeriesMoods>data = [

];

Map <DateTime, int> onlineData={

};

List<TimeSeriesMoods>selectedData=[];



List<TimeSeriesMoods>selectData(List<DateTime> picked){
  List<TimeSeriesMoods> list=[];
  selectedData.clear();
  for(int i = 0 ; i < data.length; i++ ) {
    if(data[i].time.isAfter(DateTime(picked[0].year,picked[0].month,picked[0].day,).subtract(Duration(days:1))) && data[i].time.isBefore(DateTime(picked[1].year,picked[1].month,picked[1].day,).add(Duration(days: 1)))){
      list.add(data[i]);
    }
  }
  return list;
}



double averageMood(List<TimeSeriesMoods> data){
  double sum=0;
  for(int i=0;i<data.length;i++){
    sum=sum+data[i].value;
  }
  double average = sum/data.length;
  return average;
}



List<int> extremMoods(List<TimeSeriesMoods> data){
  int min=100;
  int max=-100;
  for(int i=0;i<data.length;i++){
    if(data[i].value>max){max=data[i].value;}
    if(data[i].value<min){min=data[i].value;}
  }
  List<int> extrems=[];
  extrems.add(min);
  extrems.add(max);
  return extrems;
}


var dayFormatter = new DateFormat('dd/MM/y');
var hourFormatter= new DateFormat('H:mm');



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