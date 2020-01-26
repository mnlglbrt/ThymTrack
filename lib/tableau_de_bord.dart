
import 'dart:io';
import 'animated_button.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'data.dart';
import 'dart:io';
import 'dart:convert';
import 'mood_ranges.dart';
import 'chartDisp.dart';
import 'timeSeriesMoods.dart';
import'package:path_provider/path_provider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'dart:convert';
import 'dart:async';


class TableauDeBord extends StatefulWidget {
  TableauDeBord({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _TableauDeBordState createState() => _TableauDeBordState();

}

class _TableauDeBordState extends State<TableauDeBord> {
  ///JSON VARIABLES
  File jsonFile;
  Directory dir;
  String filename="MoodData.json";
  bool fileExists=false;
  Map<String, dynamic> fileContent;
  ///
  ///OTHER VARIABLES
  var dayFormatter = new DateFormat('dd/MM/y');
  var hourFormatter= new DateFormat('H:mm');
  List<TimeSeriesMoods>empty = [];
  int moodFromSlide = 0;
  var todayMood=data.where((i) => i.time.day == DateTime.now().day);
  TextStyle white=TextStyle(color: Colors.white);
  TextStyle black=TextStyle(color: Colors.black);
  ///



  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + filename);
      fileExists = jsonFile.existsSync();
      if (fileExists) this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
      if (fileExists) this.setState(() => fileToData(jsonFile));
    });
    selectedData=selectData(initialRange);

  }


  void createFile(Map<String,dynamic> content,Directory dir, String fileName){
    print("Creating file");
    File file = new File(dir.path + "/" + filename);
    file.createSync();
    fileExists=true;
    file.writeAsStringSync(json.encode(content));

  }


  void writeToFile (String key, String value){
    print("writing to file");
    Map<String, dynamic> content= {key:value};
    if(fileExists){
      print("file exists");
      Map<String, dynamic> jsonFileContent=json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    }else{
      print("File does not exists");
      createFile(content, dir, filename);
      this.setState(()=>fileContent=json.decode(jsonFile.readAsStringSync()));
    }}

  void dataToFile(List<TimeSeriesMoods>data){
   for (var i = 0; i < data.length; i++) {
      writeToFile(data[i].time.toString(), data[i].value.toString());
    }
  }

  void fileToData(File jsonFile) {
    fileContent=json.decode(jsonFile.readAsStringSync());
    var keyList= fileContent.keys.toList();
    var valueList = fileContent.values.toList();
    for (var i = 0; i <= fileContent.length-1; i++) {
      data.add(TimeSeriesMoods(stringToDateTime(keyList[i]),stringToInt(valueList[i])));
    }

  }


  @override
  var buttonRadius=BorderRadius.circular(30.0);
  var sliderColor=Colors.teal;
  var buttonColor = Colors.red;
  var buttonTextColor=Colors.grey[900];
  var buttonHeight = 0.0;
  var buttonWidth = 0.0;
  dynamic buttonChild=Text('');
  bool buttonVisible=true;
  List<DateTime>initialRange=[DateTime(2015,1,1),DateTime.now().subtract(new Duration(days: 1))];



  Widget build(BuildContext context) {
    var screenSize=MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: new Text("Bipol'Air",textAlign: TextAlign.center,textScaleFactor: 2.0,
            style: new TextStyle(
              fontFamily: 'simplePrint',
              fontStyle: FontStyle.italic,
              color: Colors.white,),),
        ),
        leading: Image.asset('images/logo.png'),
        actions: <Widget>[


        ],
        backgroundColor:Colors.teal,
        //rangeColor(moodFromSlide).color[rangeColor(moodFromSlide).shade],
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
                  Flexible(flex:6,
                    child: Container(
                      color: Colors.grey[100],
                      child: (selectedData.isEmpty == true) ? Container(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("aucune entrée", textScaleFactor: 1.3,),
                              Text("Utilisez le slider ci-dessous pour entrer votre humeur.", textScaleFactor: 1.1,textAlign: TextAlign.center,),
                              Text("Attribuez-lui une note entre -100 et +100", textScaleFactor: 1.1,textAlign: TextAlign.center,),
                            ],
                          )) :

                      SimpleTimeSeriesChart(
                          <charts.Series<TimeSeriesMoods, DateTime>>[
                            charts.Series<TimeSeriesMoods, DateTime>(
                              id: 'Moods',
                              colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
                              domainFn: (TimeSeriesMoods moods, _) => moods.time,
                              measureFn: (TimeSeriesMoods moods, _) => moods.value,
                              data: selectedData,
                            )
                          ]),
                    ),
                  ),
                  ///DATE RANGE SELECTOR
                  (data.isNotEmpty)?Flexible(flex:1,
                    child: new MaterialButton(
                        color: Colors.deepOrangeAccent,
                        onPressed: () async {
                          final List<DateTime> picked = await DateRangePicker.showDatePicker(
                              context: context,
                              initialFirstDate: new DateTime.now().subtract(new Duration(days: 7)),
                              initialLastDate: new DateTime.now(),
                              firstDate: new DateTime(2015),
                              lastDate: new DateTime(2050)
                          );
                          if (picked != null && picked.length == 2) {
                            setState(() {
                              selectedData.clear();
                              selectedData=selectData(picked);
                            });
                          }
                        },
                        child: new Text("Pick date range")
                    ),
                  ):Container(),

                  Flexible(flex:4,
                    child: Container(
                        color: Colors.grey[100],
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:BorderRadius.circular(50.0),
                              child:Container(
                                color: rangeColor(moodFromSlide).color,
                                height: 35,
                              width: 100,

                              child:Text(moodFromSlide.toString(),textScaleFactor: 2.2,textAlign: TextAlign.center,),

                            )),
                            Slider(activeColor:sliderColor,
                            min: -100.0,
                              max: 100.0,
                              value: moodFromSlide.toDouble(),
                              divisions: 40,
                              label: '$moodFromSlide',
                              onChanged: (newMood) =>
                              {setState(() {
                                sliderColor=rangeColor(newMood.toInt()).color;
                                moodFromSlide = newMood.toInt();
                                animateContainerGoGreen();
                              })},
                            ),
                            Center(
                              child: AnimatedContainer(
                                height: buttonHeight,
                                width: buttonWidth,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.bounceIn,
                                child: ClipRRect(
                                  borderRadius: buttonRadius,
                                  child: RaisedButton(padding: EdgeInsets.all(0),child: buttonChild,color: buttonColor, onPressed: () =>
                              {
                                  setState(() {
                                    if(todayMood.isEmpty){///Ajout de l'humeur entrée à data ; copie de data vers json
                                    data.add(TimeSeriesMoods(DateTime.now(), moodFromSlide));
                                    dataToFile(data);
                                    selectedData=selectData(initialRange);
                                    animateContainerGoGrey();}
                                    else{
                                        dialogEntryExist("Humeur déjà enregistrée", "Attendez demain ou modifiez l'humeur d'aujourd'hui.");}

                                  })},
                              ),
                                ),
                              ),
                            )],
                        )
                    ),
                  ),
//Container(child: Text(fileContent.toString())),

                  (selectedData.isEmpty)?Flexible(flex:6,child:Text("Pas dentrée")):
                  Flexible(flex:6,
                    child: SingleChildScrollView(
                      child: ListView.builder
                        (reverse:true,
                          itemCount: selectedData.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return InkWell(
                              onLongPress: ()=>{dialogChangeEntry("Modification de l'entrée", "Utilisez le slider pour modifier l'humeur du",selectedData[index].time)},///TO DO : implementer la dialog modif value
                              child: Container(
                                width : screenSize.width,
                                decoration : BoxDecoration(
                                  border: Border(
                                    left: BorderSide( //                   <--- left side
                                      color: rangeColor(selectedData[index].value).color[rangeColor(selectedData[index].value).shade],
                                      width: 25.0,
                                    ),
                                    top: BorderSide( //                    <--- top side
                                      color: Colors.grey[700],
                                      width: 3.0,
                                    ),
                                    right: BorderSide( //                    <--- top side
                                      color: Colors.grey[700],
                                      width: 3.0,
                                    ),
                                    bottom: BorderSide( //                    <--- top side
                                      color: rangeColor(selectedData[index].value).color[rangeColor(selectedData[index].value).shade],
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Padding(padding: const EdgeInsets.only(left:30.0, bottom:5.0,top:5.0),
                                    child: Container(width: 130.0,
                                    height: 40.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Text(dayFormatter.format(selectedData[index].time).toString(),textScaleFactor: 1.1,style: TextStyle(color: Colors.black,  fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                                        new Text(hourFormatter.format(selectedData[index].time).toString(),textScaleFactor: 1.1,style: TextStyle(color: Colors.black,  fontWeight: FontWeight.normal),textAlign: TextAlign.left),
                                      ],
                                    ),),),
                              new Text("     ",textAlign: TextAlign.left,),
                              new Text(selectedData[index].value.toString(),textScaleFactor: 1.4,style: TextStyle(fontWeight: FontWeight.bold,color:rangeColor(selectedData[index].value).color[rangeColor(selectedData[index].value).shade], )),
                                  ],
                                ),
                              ),
                            );}
                      ),
                    ),
                  ),





                ]),
              )

    );
  }
  ///
  ///
  ///
  ///
  ///             FONCTIONS           FONCTIONS           FONCTIONS
  ///
  ///
  ///

  Future<void> dialogEntryExist(String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Attendre demain'),
              onPressed: () {
                Navigator.of(context).pop();
              },

            ),
            FlatButton(
              child: Text('Modifier'),
              onPressed: () {
                setState(() {
                  data.removeWhere((i) => i.time.day == DateTime.now().day);
                  data.add(TimeSeriesMoods(DateTime.now(),moodFromSlide));
                  jsonFile.deleteSync();
                  fileContent.clear();
                  createFile(fileContent, dir, filename);
                  data.forEach((e)=>writeToFile(e.time.toString(), e.value.toString()));
                  fileContent = json.decode(jsonFile.readAsStringSync());
                  //fileToData(fileContent);
                  animateContainerGoGrey();
                  selectedData=selectData(initialRange);
                });

                Navigator.of(context).pop();
              },

            ),
          ],
        );
      },
    );
  }


  Future<void> dialogChangeEntry(String title, String content,DateTime date) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content+" "+dayFormatter.format(date).toString()),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },

            ),
            FlatButton(
              child: Text('Modifier'),
              onPressed: () {
                setState(() {
                  data.removeWhere((i) => i.time.day == DateTime.now().day);
                  data.add(TimeSeriesMoods(DateTime.now(),moodFromSlide));
                  jsonFile.deleteSync();
                  fileContent.clear();
                  createFile(fileContent, dir, filename);
                  data.forEach((e)=>writeToFile(e.time.toString(), e.value.toString()));
                  fileContent = json.decode(jsonFile.readAsStringSync());
                  //fileToData(fileContent);
                  selectedData=selectData(initialRange);
                  animateContainerGoGrey();

                });

                Navigator.of(context).pop();
              },

            ),
          ],
        );
      },
    );
  }



  animateContainerGoGreen() {
    if(buttonWidth==50){print(buttonColor.toString());}
    else{
    setState(() {
      buttonChild=Center(child: Icon(Icons.add_circle_outline,color: Colors.white,));
     buttonColor=Colors.teal;
      buttonWidth = 50;
        buttonHeight = 50;
        buttonRadius=BorderRadius.circular(30.0);
    });
        }}


  animateContainerGoGrey() {
    setState(() {
      buttonChild=ListView(scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
          Padding(
            padding: const EdgeInsets.only(left:20.0),
            child: Text('Humeur enregistrée', style:TextStyle(color: (rangeColor(moodFromSlide).color==Colors.yellow)?Colors.black:Colors.white)),
          ),
          Padding(
            padding: EdgeInsets.only(left:10.0),
            child: Icon(Icons.done_outline,color: (rangeColor(moodFromSlide).color==Colors.teal)?Colors.white:Colors.lightGreen,),
          ),
          ])],
      );
      buttonColor=rangeColor(moodFromSlide.toInt()).color;
      buttonWidth = 200;
      buttonHeight = 50;
      buttonRadius=BorderRadius.circular(10.0);
    });
  }





  moodChanged(value) {
    setState(() {
      moodFromSlide = value;
    });
  }


DateTime stringToDateTime(String string){
  return DateTime.parse(string);
}

int stringToInt(String string){
    return int.parse(string);
}


  List<TimeSeriesMoods>selectData(List<DateTime> picked){
    List<TimeSeriesMoods> list=[];
    selectedData = [];
    for(int i = 0 ; i < data.length; i++ ) {
      if(data[i].time.isAfter(picked[0]) && data[i].time.isBefore(picked[1].add(new Duration(days:2)))){
        list.add(data[i]);
      }
    }
    print(list.toString());
    return list;
  }

}





class SimpleTimeSeriesChart extends StatelessWidget {
  const SimpleTimeSeriesChart(this.seriesList);

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return SimpleTimeSeriesChart(
      _createSampleData(),
    );
  }

  final List<charts.Series<TimeSeriesMoods, DateTime>> seriesList;

  @override
  Widget build(BuildContext context) => charts.TimeSeriesChart(
    seriesList,
    animate: false,
    dateTimeFactory: const charts.LocalDateTimeFactory(),
    domainAxis: charts.DateTimeAxisSpec(
      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
        day: charts.TimeFormatterSpec(
          format: 'EEE',
          transitionFormat: 'EEE',
        ),hour: charts.TimeFormatterSpec(
        format: 'H:mm',
        transitionFormat: 'H:mm',
      ),
        minute: charts.TimeFormatterSpec(
          format: 'H:mm',
          transitionFormat: 'H:mm',
        ),
      ),
    ),
  );

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesMoods, DateTime>> _createSampleData() {
    return <charts.Series<TimeSeriesMoods, DateTime>>[
      charts.Series<TimeSeriesMoods, DateTime>(
        id: 'Moods',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesMoods moods, _) => moods.time,
        measureFn: (TimeSeriesMoods moods, _) => moods.value,
        data: selectedData,
      )
    ];
  }
}