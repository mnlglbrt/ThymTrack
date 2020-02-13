import 'package:bipo/mood_ranges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'time_series_moods.dart';
import 'time_series_words.dart';


var sevenDaysData=selectData([DateTime.now().subtract(Duration(days:6)),DateTime.now().add(new Duration(days: 1))]);

var thirtyDaysData=selectData([DateTime.now().subtract(Duration(days:31)),DateTime.now().add(new Duration(days: 1))]);

DateTime today=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,);

List<TimeSeriesMoods>dataMoods = [];

List<TimeSeriesMoods>selectedData=[];

List<TimeSeriesWords>dataWords = [];



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



num averageMood(List<TimeSeriesMoods> data){
  double sum=0;
  if(dataMoods.length>0){
  for(int i=0;i<data.length;i++){
    sum=sum+data[i].value;
  }
  double average = sum/data.length;
  return average;}
  else{return 0;}
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
  if (dataMoods.length>0){
  Map stats={
   'nbRecords':dataMoods.length,
   'nbDays':DateTime.now().difference(dataMoods[0].time).inDays,
   'missedRecords':DateTime.now().subtract(Duration(days:1)).difference(dataMoods[0].time).inDays-dataMoods.length+2,
   'accuracy':(((dataMoods.length-2)/((DateTime.now().subtract(Duration(days:1))).difference(dataMoods[0].time).inDays.toInt()))*100),
 };
  return stats;}
}



int stabDays(List<TimeSeriesMoods> dataMoods){
  var stab= dataMoods.where((mood) => rangeColor(mood.value).color== Colors.teal).toList();
  return stab.length;
}



String messageFromMood(mood){
  return (mood<-49)?"Prenez contact avec quelqu'un\n\nqui pourra vous écouter.":
  (mood<-9)?"Positivez !\n\nFocalisez-vous sur ce qui va.":
  (mood<15)?"Ravi de vous voir en forme !\n\nPassez une bonne journée.":
  (mood<50)?"Quelle mine incroyable !\n\nJe suis sûr que votre\njournée sera excellente.":
  (mood<70)?"Quel anthousiasme !\n\nPensez a vous ménager.":
  (mood<=100)?"Vous êtes au summum du UP!\n\nAttention à ne pas dépasser les limites.":'';
}






//FORMATTERS
DateTime stringToDateTime(String string){
  return DateTime.parse(string);
}

int stringToInt(String string){
  return int.parse(string);
}

var dayFormatter = new DateFormat('dd/MM/y');
var hourFormatter= new DateFormat('H:mm');



