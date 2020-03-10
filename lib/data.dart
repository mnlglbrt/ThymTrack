import 'package:bipo/mood_ranges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'time_series_moods.dart';
import 'time_series_words.dart';
import 'words.dart';

Map<DateTime,List<Word>> selectedWordsToday={today:[]};

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
  if(data.isNotEmpty){
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
  Map<dynamic, dynamic> stats={
   'nbRecords':dataMoods.length,
   'nbDays':DateTime.now().difference(dataMoods[0].time).inDays,
   'missedRecords':DateTime.now().subtract(Duration(days:1)).difference(dataMoods[0].time).inDays-dataMoods.length+2,
   'accuracy':(((dataMoods.length-2)/((DateTime.now().subtract(Duration(days:1))).difference(dataMoods[0].time).inDays.toInt()))*100),
 };
  return stats;
}



int stabDays(List<TimeSeriesMoods> dataMoods){
  var stab= dataMoods.where((mood) => rangeColor(mood.value).color== Colors.teal).toList();
  return stab.length;
}


var selectedPoint=0;

String messageFromMood(mood){
  return (mood<-49)?"Prenez contact avec quelqu'un\n\nqui pourra vous écouter.":
  (mood<-9)?"Positivez !\n\nFocalisez-vous sur ce qui va.":
  (mood<15)?"Ravi de vous voir en forme !\n\nPassez une bonne journée.":
  (mood<50)?"Quelle mine incroyable !\n\nJe suis sûr que votre\njournée sera excellente.":
  (mood<70)?"Quel enthousiasme !\n\nPensez a vous ménager.":
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


class Range {
  int start;
  int end;
  Color color;
  String name;
  String detail;

  Range(this.start, this.end, this.color, this.name, this.detail);

}

List<Range>moodLadder=[
  new Range(-100,-75,Colors.red[200],"Dépression sévère","Pense souvent au suicide - Isolement total - Reste assis ou couché toute la journée - Sentiment d'être inutile"),
  new Range(-75,-50,Colors.red[200],"Dépression sévère","Culpabilise beaucoup - Idées suicidaires - Peu d'activité - Tristesse, pleurs"),
  new Range(-50,-30,Colors.yellow[200],"Légère dépression","Perte d'appétit - Isolement - Sommeil agité - Démoralisé - Parle lentement et peu"),
  new Range(-30,-10,Colors.yellow[200],"Légère dépression","Légères angoisses - Troubles paniques - Troubles de la mémoire - Perte d'attention - Mélancolie"),
  new Range(-10,10,Colors.teal[400],"Zone de confort","Légers troubles de la concentration - Retrait social lors d'évènements - Possibles agitations"),
  new Range(10,30,Colors.teal[400],"Zone de confort","Bien dans sa peau - Pas de tristesse ni d'euphorie - Humeur modérée"),
  new Range(30,50,Colors.teal[400],"Zone de confort","Confiance et estime de soi excellentes - Besoin de travailler, bouger - Optimiste - Entreprenant - Trés sociable"),
  new Range(50,60,Colors.yellow[200],"Hypomanie","Hyperactif - En exaltation pour tout - Émotions et actions exagérées - Parle beaucoup - Ressent le besoin de séduire"),
  new Range(60,70,Colors.yellow[200],"Hypomanie","Ego surdimensionné - Parle rapidement - Pensées multiples - Projets multiples"),
  new Range(70,85,Colors.red[200],"Manie","Paranoïa - Imprudences - Manque considérable de sommeil - Incohérences - Légères psychoses"),
  new Range(85,100,Colors.red[200],"Manie","Hallucinations - Délires - Psychoses graves - Altération du jugement - Addictions excessives et dangereuses"),
];

void updateToday(){
  today=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,);
}