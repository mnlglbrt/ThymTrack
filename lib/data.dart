
import 'package:bipo/mood_ranges.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'timeSeriesMoods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'time_series_words.dart';


/*final List<MoodEntry> data = [

];*/
var sevenDaysData=selectData([DateTime.now().subtract(Duration(days:6)),DateTime.now().add(new Duration(days: 1))]);
var thirtyDaysData=selectData([DateTime.now().subtract(Duration(days:31)),DateTime.now().add(new Duration(days: 1))]);
DateTime today=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,);

 List<TimeSeriesMoods>dataMoods = [

];

List<TimeSeriesWords>dataWords = [

];

Map <DateTime, int> onlineData={

};

List<TimeSeriesMoods>selectedData=[];



List<TimeSeriesMoods>selectData(List<DateTime> picked){
  List<TimeSeriesMoods> list=[];
  selectedData.clear();
  for(int i = 0 ; i < dataMoods.length; i++ ) {
    if(dataMoods[i].time.isAfter(DateTime(picked[0].year,picked[0].month,picked[0].day,).subtract(Duration(days:1))) && dataMoods[i].time.isBefore(DateTime(picked[1].year,picked[1].month,picked[1].day,).add(Duration(days: 1)))){
      list.add(dataMoods[i]);
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

Map<dynamic, dynamic> getStats(List<TimeSeriesMoods> dataMoods) {
  print('data[0].time: ${dataMoods[0].time}');
  print('datalength-2: ${dataMoods.length-2}');
  print('nbDays: ${DateTime.now().difference(dataMoods[0].time).inDays}');
  print('missedRecs: ${DateTime.now().difference(dataMoods[0].time).inDays-dataMoods.length+2}');
  print('Accuracy: ${(((dataMoods.length-3)/(dataMoods[0].time.difference(DateTime.now()).inDays.toInt()))*100)}');
  Map stats={
   'nbRecords':dataMoods.length,
   'nbDays':DateTime.now().difference(dataMoods[0].time).inDays,
   'missedRecords':DateTime.now().subtract(Duration(days:1)).difference(dataMoods[0].time).inDays-dataMoods.length+2,
   'accuracy':(((dataMoods.length-2)/((DateTime.now().subtract(Duration(days:1))).difference(dataMoods[0].time).inDays.toInt()))*100).toInt(),
 };
  return stats;
}

int stabDays(List<TimeSeriesMoods> dataMoods){
  var stab= dataMoods.where((mood) => rangeColor(mood.value).color== Colors.teal).toList();
  return stab.length;
}


var dayFormatter = new DateFormat('dd/MM/y');
var hourFormatter= new DateFormat('H:mm');



