import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'data.dart';
import 'main.dart' as main;
import 'my_chart.dart';
import 'mood_ranges.dart';
import 'time_series_moods.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:clay_containers/clay_containers.dart';
import 'sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'ladder_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'medals.dart';
import 'medals_page.dart';
//import 'first_connection_screen.dart';



class DashBoard extends StatefulWidget {
  DashBoard({Key key}) : super(key: key);


  @override
  _DashBoardState createState() => _DashBoardState();

}

class _DashBoardState extends State<DashBoard> {


  @override
  void initState() {
    super.initState();
    dataMoods.clear();
    getData().then((x){newMedal=newMedalToday();});
    getMedals();
    getReminderPrefs().then((bool){
      setState(() {
        reminderButtonVisible=bool;
      });
    });

  }


  PageController pageController = PageController();


  int moodFromSlide = 0;
  var sliderColor = Colors.teal;

  var addButtonRadius = BorderRadius.circular(30.0);
  var addButtonColor = Colors.red;
  var buttonTextColor = Colors.grey[900];
  var addButtonHeight = 0.0;
  var addButtonWidth = 0.0;
  dynamic addButtonChild = Text('');
  bool newMedal;

  List<DateTime>initialRange = [
    DateTime.now().subtract(new Duration(days: 6)),
    DateTime.now()
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext bsContext;
  String message = "";
  TimeSeriesMoods todayMood;
  var listdates = [];
  var listmood = [];
  bool reminderButtonVisible=true;
  TextStyle white = TextStyle(color: Colors.white);
  TextStyle black = TextStyle(color: Colors.black);

  //var doc;


  Widget build(BuildContext context) {


    int nbTabs=(dataMoods.length<7)?1:3;
    return StreamBuilder<QuerySnapshot>(
        stream: fire_users.document(uid).collection('moods').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (dataMoods.isEmpty) {
           // Navigator.push(context, MaterialPageRoute(builder: (context){return FirstLogScreen();}));
            dataMoods.add(TimeSeriesMoods(today, 0));
            return Scaffold(
              key: _scaffoldKey,
              body: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  decoration: BoxDecoration(image: DecorationImage(
                      image: AssetImage('images/background.png'),
                      fit: BoxFit.fill)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset('images/logo.png', height: 100,),

                      Text('Connexion en cours...',
                        style: (TextStyle(color: Colors.grey[100])),
                        textScaleFactor: 2.0,),
                      SizedBox(height: 300,),
                      CircularProgressIndicator(backgroundColor: Colors.white,),
                      SizedBox(height: 100,)
                    ],
                  )
              ),
            );
          } else if(dataMoods.length>7) {
            var screenSize = MediaQuery
                .of(context)
                .size;
            var selectedData = selectData(initialRange);
            bool newMedal=newMedalToday();
            message = "Comment vous sentez-vous aujourd'hui?";
            return DefaultTabController(length: nbTabs,
              child: new Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  elevation: 10.0,
                  centerTitle: true,
                  backgroundColor: Colors.teal,
                  title: new Text(
                    "ThymTrack", textAlign: TextAlign.center,
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
                        Tooltip(message: 'Réglages',
                          child: FlatButton(
                            onPressed: () {
                              showOptionsMenu(snapshot);
                              /*Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                    return SettingPage();
                                  }), ModalRoute.withName('/'));*/
                            },
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
                                    child: Icon((newMedal)?Icons.new_releases:Icons.menu,
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
                ),



                body: TabBarView(
                    children: <Widget>[


                      ///                                                      CHART 7 DAYS
                      Column(
                        children: <Widget>[
                          Flexible(flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  (dataMoods.length>2)?ClayContainer(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0),
                                          child: Text('7 derniers jours', style: TextStyle(fontFamily: 'dot',color:Colors.grey[600], ),),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text('Moyenne :',style: TextStyle(color: Colors.grey[400]),),
                                            Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Opacity(opacity:1.0,child: new Text(averageMood(sevenDaysData).toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(averageMood(sevenDaysData).toInt()).color[rangeColor(averageMood(sevenDaysData).toInt()).shade], ))),
                                            )),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ):Container(),

                                  Card(elevation: 0.0,
                                    color: Colors.grey[100],
                                    child: Container(
                                      height: 350.0,
                                      //color: Colors.grey[100],
                                      child: (sevenDaysData.isEmpty == true)
                                          ? Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text("Aucune entrée",
                                                textScaleFactor: 1.3,),
                                              Text(
                                                "Utilisez le + pour entrer votre humeur.",
                                                textScaleFactor: 1.1,
                                                textAlign: TextAlign.center,),
                                              Text(
                                                "Attribuez-lui une note entre -100 et +100",
                                                textScaleFactor: 1.1,
                                                textAlign: TextAlign.center,),
                                            ],
                                          ))
                                          :

                                      SimpleTimeSeriesChart(
                                          <charts.Series<
                                              TimeSeriesMoods,
                                              DateTime>>[
                                            charts.Series<
                                                TimeSeriesMoods,
                                                DateTime>(
                                              id: 'Moods',
                                              colorFn: (TimeSeriesMoods moods,
                                                  _) {
                                                return (rangeColor(
                                                    moods.value.toInt())
                                                    .color == Colors.red)
                                                    ? charts.MaterialPalette.red
                                                    .shadeDefault.darker
                                                    :
                                                (rangeColor(moods.value)
                                                    .color == Colors.yellow)
                                                    ? charts.MaterialPalette
                                                    .yellow.shadeDefault.darker
                                                    :
                                                (rangeColor(moods.value)
                                                    .color == Colors.teal)
                                                    ? charts.MaterialPalette
                                                    .teal.shadeDefault.darker
                                                    : charts.MaterialPalette
                                                    .pink.shadeDefault;
                                              },
                                              domainFn: (TimeSeriesMoods moods,
                                                  _) => moods.time,
                                              measureFn: (TimeSeriesMoods moods,
                                                  _) => moods.value,
                                              data: sevenDaysData,
                                            )
                                              ..setAttribute(
                                                  charts.rendererIdKey,
                                                  'customPoint'),
                                            charts.Series<
                                                TimeSeriesMoods,
                                                DateTime>(
                                              id: 'Moods',
                                              colorFn: (TimeSeriesMoods moods,
                                                  _) {
                                                return (rangeColor(
                                                    averageMood(sevenDaysData)
                                                        .toInt()).color ==
                                                    Colors.red) ? charts
                                                    .MaterialPalette.red
                                                    .shadeDefault.darker :
                                                (rangeColor(
                                                    averageMood(sevenDaysData)
                                                        .toInt()).color ==
                                                    Colors.yellow) ? charts
                                                    .MaterialPalette.yellow
                                                    .shadeDefault.darker :
                                                (rangeColor(
                                                    averageMood(sevenDaysData)
                                                        .toInt()).color ==
                                                    Colors.teal)
                                                    ? charts.MaterialPalette
                                                    .teal.shadeDefault.darker
                                                    : charts.MaterialPalette
                                                    .pink.shadeDefault;
                                              },
                                              domainFn: (TimeSeriesMoods moods,
                                                  _) => moods.time,
                                              measureFn: (TimeSeriesMoods moods,
                                                  _) => moods.value,
                                              data: sevenDaysData,
                                            )
                                          ]),
                                    ),
                                  ),


                                  ///                                                      LIST 7 DAYS
                                  (sevenDaysData.isEmpty)
                                      ? Text("Pas d'entrée")
                                      :
                                  Flexible(flex: 2,
                                    child: makeList(sevenDaysData),
                                  ),

                                ]),
                          ),
                        ],
                      ),


                      ///                                                      CHART 30 DAYS
                      Column(
                        children: <Widget>[
                          Flexible(flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  (dataMoods.length>2)?ClayContainer(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0),
                                          child: Text('30 derniers jours', style: TextStyle(fontFamily: 'dot',color:Colors.grey[600], ),),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text('Moyenne :',style: TextStyle(color: Colors.grey[400]),),
                                            Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Opacity(opacity:1.0,child: new Text(averageMood(thirtyDaysData).toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(averageMood(thirtyDaysData).toInt()).color[rangeColor(averageMood(thirtyDaysData).toInt()).shade], ))),
                                            )),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ):Container(),

                                  Card(elevation: 0.0,
                                      color: Colors.grey[100],
                                      child: Container(
                                        height: 350.0,
                                        //color: Colors.grey[100],
                                        child: (thirtyDaysData.isEmpty == true)
                                            ? Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text("Aucune entrée",
                                                  textScaleFactor: 1.3,),
                                                Text(
                                                  "Utilisez le slider pour entrer votre humeur.",
                                                  textScaleFactor: 1.1,
                                                  textAlign: TextAlign.center,),
                                                Text(
                                                  "Attribuez-lui une note entre -100 et +100",
                                                  textScaleFactor: 1.1,
                                                  textAlign: TextAlign.center,),
                                              ],
                                            ))
                                            :

                                        SimpleTimeSeriesChart(
                                            <charts.Series<
                                                TimeSeriesMoods,
                                                DateTime>>[
                                              charts.Series<
                                                  TimeSeriesMoods,
                                                  DateTime>(
                                                id: 'Moods',
                                                colorFn: (TimeSeriesMoods moods,
                                                    _) {
                                                  return (rangeColor(
                                                      moods.value.toInt())
                                                      .color == Colors.red)
                                                      ? charts.MaterialPalette
                                                      .red.shadeDefault.darker
                                                      :
                                                  (rangeColor(moods.value)
                                                      .color == Colors.yellow)
                                                      ? charts.MaterialPalette
                                                      .yellow.shadeDefault
                                                      .darker
                                                      :
                                                  (rangeColor(moods.value)
                                                      .color == Colors.teal)
                                                      ? charts.MaterialPalette
                                                      .teal.shadeDefault.darker
                                                      : charts.MaterialPalette
                                                      .pink.shadeDefault;
                                                },
                                                domainFn: (
                                                    TimeSeriesMoods moods,
                                                    _) => moods.time,
                                                measureFn: (
                                                    TimeSeriesMoods moods,
                                                    _) => moods.value,
                                                data: thirtyDaysData,
                                              )
                                                ..setAttribute(
                                                    charts.rendererIdKey,
                                                    'customPoint'),
                                              charts.Series<
                                                  TimeSeriesMoods,
                                                  DateTime>(
                                                id: 'Moods',
                                                colorFn: (TimeSeriesMoods moods,
                                                    _) {
                                                  return (rangeColor(
                                                      averageMood(
                                                          thirtyDaysData)
                                                          .toInt()).color ==
                                                      Colors.red) ? charts
                                                      .MaterialPalette.red
                                                      .shadeDefault.darker :
                                                  (rangeColor(averageMood(
                                                      thirtyDaysData).toInt())
                                                      .color == Colors.yellow)
                                                      ? charts.MaterialPalette
                                                      .yellow.shadeDefault
                                                      .darker
                                                      :
                                                  (rangeColor(averageMood(
                                                      thirtyDaysData).toInt())
                                                      .color == Colors.teal)
                                                      ? charts.MaterialPalette
                                                      .teal.shadeDefault.darker
                                                      : charts.MaterialPalette
                                                      .pink.shadeDefault;
                                                },
                                                domainFn: (
                                                    TimeSeriesMoods moods,
                                                    _) => moods.time,
                                                measureFn: (
                                                    TimeSeriesMoods moods,
                                                    _) => moods.value,
                                                data: thirtyDaysData,
                                              )
                                            ]),
                                      )),


                                  ///                                                      LIST 30 DAYS
                                  (selectedData.isEmpty)
                                      ? Text("Pas d'entrée")
                                      :
                                  Flexible(flex: 2,
                                    child: makeList(thirtyDaysData),
                                  ),

                                ]),
                          ),
                        ],
                      ),


                      ///                                                                 GRAPH FOR SELECTED RANGE
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  (dataMoods.length>2)?ClayContainer(
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left:20.0),
                                            child: ///DATE RANGE SELECTOR

                                            ClayContainer(
                                              surfaceColor: Colors.teal,
                                              color: Colors.grey[100],
                                              parentColor: Colors.white,

                                              height: 30,
                                              borderRadius: 75,
                                              depth: 40,
                                              spread: 10,
                                              child: new InkWell(
                                                  onTap: () async {
                                                    final List<
                                                        DateTime> picked = await DateRangePicker
                                                        .showDatePicker(
                                                      context: context,
                                                      initialFirstDate: initialRange[0],
                                                      initialLastDate: initialRange[1],
                                                      firstDate: new DateTime(2019),
                                                      lastDate: new DateTime(2050),
                                                      locale: Locale('fr','FR'),
                                                    );
                                                    if (picked != null &&
                                                        picked.length == 2) {
                                                      setState(() {
                                                        getData();
                                                        initialRange = picked;
                                                        selectedData.clear();
                                                        selectedData =
                                                            selectData(picked);
                                                      });
                                                    }
                                                  },


                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: <Widget>[
                                                          new Text('${new DateFormat(
                                                              "dd/MM/yyyy").format(
                                                              initialRange[0])}',
                                                              textScaleFactor: 0.8,
                                                              style: white),
                                                          new Icon(Icons.arrow_left,
                                                              color: Colors.white),
                                                          new Icon(Icons.calendar_today,
                                                              color: Colors.white),
                                                          new Icon(Icons.arrow_right,
                                                              color: Colors.white),
                                                          new Text('${new DateFormat(
                                                              "dd/MM/yyyy").format(
                                                              initialRange[1])}',
                                                              textScaleFactor: 0.8,
                                                              style: white),
                                                        ]
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text('Moyenne :',style: TextStyle(color: Colors.grey[400]),),
                                              Center(child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Opacity(opacity:1.0,child: new Text(averageMood(selectedData).toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(averageMood(selectedData).toInt()).color[rangeColor(averageMood(selectedData).toInt()).shade], ))),
                                              )),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ):Container(),

                                  Card(elevation: 0.0,
                                      child: Container(
                                        height: 350.0,
                                        color: Colors.grey[100],
                                        child: (selectedData.isEmpty == true)
                                            ? Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Text("Aucune entrée",
                                                  textScaleFactor: 1.3,),
                                                Text(
                                                  "Utilisez le + pour entrer votre humeur.",
                                                  textScaleFactor: 1.1,
                                                  textAlign: TextAlign.center,),
                                                Text(
                                                  "Attribuez-lui une note entre -100 et +100",
                                                  textScaleFactor: 1.1,
                                                  textAlign: TextAlign.center,),
                                              ],
                                            ))
                                            :

                                        SimpleTimeSeriesChart(
                                            <charts.Series<
                                                TimeSeriesMoods,
                                                DateTime>>[
                                              charts.Series<
                                                  TimeSeriesMoods,
                                                  DateTime>(
                                                id: 'Moods',
                                                colorFn: (TimeSeriesMoods moods,
                                                    _) {
                                                  return (rangeColor(
                                                      moods.value.toInt())
                                                      .color == Colors.red)
                                                      ? charts.MaterialPalette
                                                      .red.shadeDefault.darker
                                                      :
                                                  (rangeColor(moods.value)
                                                      .color == Colors.yellow)
                                                      ? charts.MaterialPalette
                                                      .yellow.shadeDefault
                                                      .darker
                                                      :
                                                  (rangeColor(moods.value)
                                                      .color == Colors.teal)
                                                      ? charts.MaterialPalette
                                                      .teal.shadeDefault.darker
                                                      : charts.MaterialPalette
                                                      .pink.shadeDefault;
                                                },
                                                domainFn: (
                                                    TimeSeriesMoods moods,
                                                    _) => moods.time,
                                                measureFn: (
                                                    TimeSeriesMoods moods,
                                                    _) => moods.value,
                                                data: selectedData,
                                              )
                                                ..setAttribute(
                                                    charts.rendererIdKey,
                                                    'customPoint'),

                                              charts.Series<
                                                  TimeSeriesMoods,
                                                  DateTime>(
                                                id: 'Moods',
                                                colorFn: (TimeSeriesMoods moods,
                                                    _) {
                                                  return (rangeColor(
                                                      averageMood(selectedData)
                                                          .toInt()).color ==
                                                      Colors.red) ? charts
                                                      .MaterialPalette.red
                                                      .shadeDefault.darker :
                                                  (rangeColor(
                                                      averageMood(selectedData)
                                                          .toInt()).color ==
                                                      Colors.yellow) ? charts
                                                      .MaterialPalette.yellow
                                                      .shadeDefault.darker :
                                                  (rangeColor(
                                                      averageMood(selectedData)
                                                          .toInt()).color ==
                                                      Colors.teal)
                                                      ? charts.MaterialPalette
                                                      .teal.shadeDefault.darker
                                                      : charts.MaterialPalette
                                                      .pink.shadeDefault;
                                                },
                                                domainFn: (
                                                    TimeSeriesMoods moods,
                                                    _) => moods.time,
                                                measureFn: (
                                                    TimeSeriesMoods moods,
                                                    _) => moods.value,
                                                data: selectedData,
                                              )
                                            ]),
                                      )),





                                  ///                                                      LIST PERSO WITH SELECTED RANGE
                                  (selectedData.isEmpty)
                                      ? Text("Pas d'entrée")
                                      :
                                  Flexible(flex: 2,
                                      child: makeList(selectedData)
                                  ),

                                ]),
                          ),
                        ],
                      ),


//Container(child: Text(fileContent.toString())),


                    ]),
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TabBar(dragStartBehavior: DragStartBehavior.down,
                          isScrollable: true,
                          tabs: <Widget>[
                            //Container(height:screenSize.height/20,width: screenSize.width/8,child: Row(mainAxisAlignment:MainAxisAlignment.center,children: <Widget>[Icon(Icons.add_circle_outline,color: Colors.teal),],)),
                            Container(height: screenSize.height / 20,
                                width: screenSize.width / 8,
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.show_chart, color: Colors.teal),
                                    Text('7j',
                                      style: TextStyle(color: Colors.teal),)
                                  ],))),
                            Container(height: screenSize.height / 20,
                                width: screenSize.width / 8,
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.show_chart, color: Colors.teal,),
                                    Text('1m',
                                        style: TextStyle(color: Colors.teal))
                                  ],))),

                            Padding(
                              padding: EdgeInsets.only(left: screenSize.width /
                                  8),
                              child: Container(height: screenSize.height / 20,
                                  width: screenSize.width / 3,
                                  child: Center(child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: <Widget>[
                                      Icon(Icons.calendar_today,
                                          color: Colors.teal),
                                      Text('Perso',
                                          style: TextStyle(color: Colors.teal))
                                    ],))),
                            ),
                          ]),
                    ],
                  ),
                  color: Colors.white,
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    showMenuAddMood(snapshot);
                  },
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation
                    .centerDocked,
              ),
            );
          }
          else{
            print('AVERAGE : ${averageMood(sevenDaysData)}');
            return DefaultTabController(length: nbTabs,
              child: new Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  elevation: 10.0,
                  centerTitle: true,
                  backgroundColor: Colors.teal,
                  title: new Text(
                    "ThymTrack", textAlign: TextAlign.center,
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
                        Tooltip(message: 'Réglages',
                          child: FlatButton(
                            onPressed: () {
                              showOptionsMenu(snapshot);
                              /*Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) {
                                      return SettingPage();
                                    }), ModalRoute.withName('/'));*/
                            },
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
                                      Icons.menu,
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
                ),



                body: TabBarView(
                    children: <Widget>[


                      ///                                                      CHART 7 DAYS
                      Column(
                        children: <Widget>[
                          Flexible(flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  (dataMoods.length>2)?ClayContainer(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0),
                                          child: Text('7 derniers jours', style: TextStyle(fontFamily: 'dot',color:Colors.grey[600], ),),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text('Moyenne :',style: TextStyle(color: Colors.grey[400]),),
                                            Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Opacity(opacity:1.0,child: new Text(averageMood(sevenDaysData).toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(averageMood(sevenDaysData).toInt()).color[rangeColor(averageMood(sevenDaysData).toInt()).shade], ))),
                                            )),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ):Container(),

                                  Card(elevation: 0.0,
                                    color: Colors.grey[100],
                                    child: Container(
                                      height: 350.0,
                                      //color: Colors.grey[100],
                                      child: (sevenDaysData.isEmpty == true)
                                          ? Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text("Aucune entrée",
                                                textScaleFactor: 1.3,),
                                              Text(
                                                "Utilisez le + pour entrer votre humeur.",
                                                textScaleFactor: 1.1,
                                                textAlign: TextAlign.center,),
                                              Text(
                                                "Attribuez-lui une note entre -100 et +100",
                                                textScaleFactor: 1.1,
                                                textAlign: TextAlign.center,),
                                            ],
                                          ))
                                          :

                                      SimpleTimeSeriesChart(
                                          <charts.Series<
                                              TimeSeriesMoods,
                                              DateTime>>[
                                            charts.Series<
                                                TimeSeriesMoods,
                                                DateTime>(
                                              id: 'Moods',
                                              colorFn: (TimeSeriesMoods moods,
                                                  _) {
                                                return (rangeColor(
                                                    moods.value.toInt())
                                                    .color == Colors.red)
                                                    ? charts.MaterialPalette.red
                                                    .shadeDefault.darker
                                                    :
                                                (rangeColor(moods.value)
                                                    .color == Colors.yellow)
                                                    ? charts.MaterialPalette
                                                    .yellow.shadeDefault.darker
                                                    :
                                                (rangeColor(moods.value)
                                                    .color == Colors.teal)
                                                    ? charts.MaterialPalette
                                                    .teal.shadeDefault.darker
                                                    : charts.MaterialPalette
                                                    .pink.shadeDefault;
                                              },
                                              domainFn: (TimeSeriesMoods moods,
                                                  _) => moods.time,
                                              measureFn: (TimeSeriesMoods moods,
                                                  _) => moods.value,
                                              data: sevenDaysData,
                                            )
                                              ..setAttribute(
                                                  charts.rendererIdKey,
                                                  'customPoint'),
                                            charts.Series<
                                                TimeSeriesMoods,
                                                DateTime>(
                                              id: 'Moods',
                                              colorFn: (TimeSeriesMoods moods,
                                                  _) {
                                                return (rangeColor(
                                                    averageMood(sevenDaysData)
                                                        .toInt()).color ==
                                                    Colors.red) ? charts
                                                    .MaterialPalette.red
                                                    .shadeDefault.darker :
                                                (rangeColor(
                                                    averageMood(sevenDaysData)
                                                        .toInt()).color ==
                                                    Colors.yellow) ? charts
                                                    .MaterialPalette.yellow
                                                    .shadeDefault.darker :
                                                (rangeColor(
                                                    averageMood(sevenDaysData)
                                                        .toInt()).color ==
                                                    Colors.teal)
                                                    ? charts.MaterialPalette
                                                    .teal.shadeDefault.darker
                                                    : charts.MaterialPalette
                                                    .pink.shadeDefault;
                                              },
                                              domainFn: (TimeSeriesMoods moods,
                                                  _) => moods.time,
                                              measureFn: (TimeSeriesMoods moods,
                                                  _) => moods.value,
                                              data: sevenDaysData,
                                            )
                                          ]),
                                    ),
                                  ),


                                  ///                                                      LIST 7 DAYS
                                  (sevenDaysData.isEmpty)
                                      ? Text("Pas d'entrée")
                                      :
                                  Flexible(flex: 2,
                                    child: makeList(sevenDaysData),
                                  ),

                                ]),
                          ),
                        ],
                      ),




                    ]),
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TabBar(dragStartBehavior: DragStartBehavior.down,
                          isScrollable: true,
                          tabs: <Widget>[
                            //Container(height:screenSize.height/20,width: screenSize.width/8,child: Row(mainAxisAlignment:MainAxisAlignment.center,children: <Widget>[Icon(Icons.add_circle_outline,color: Colors.teal),],)),
                            Container(height: MediaQuery.of(context).size.height / 20,
                                width: MediaQuery.of(context).size.width-100,
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.show_chart, color: Colors.teal),
                                    Text('7j',
                                      style: TextStyle(color: Colors.teal),)
                                  ],))),

                          ]),
                    ],
                  ),
                  color: Colors.white,
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    showMenuAddMood(snapshot);
                  },
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation
                    .centerDocked,

          ),
            );
          }
        });
  }


  ///
  ///
  ///
  ///             METHODS           METHODS           METHODS
  ///
  ///
  ///


  Future<Null> checkFocChanges() async {
    Firestore.instance.runTransaction((Transaction tx) async {
      CollectionReference reference = Firestore.instance.collection('users')
          .document(uid).collection('moods')
          .reference();
      reference.snapshots().listen((documentSnapshot) {
        documentSnapshot.documentChanges.forEach((change) {
          // Do something with change

          for (int i = 0; i <
              documentSnapshot.documents[0].data.values.length - 1;) {
            listdates.add(DateTime.parse(
                documentSnapshot.documents[0].data.keys.toString().substring(
                    1, 11)));
            listmood.add(int.parse(
                documentSnapshot.documents[0].data.values.toString().substring(
                    1, documentSnapshot.documents[0].data.values
                    .toString()
                    .length - 1)));

            dataMoods.add(TimeSeriesMoods(
                listdates[i], listmood[i])
            );
          }
        });
      });
    });
  }


  Future <List<Map<dynamic, dynamic>>> getCollection() async {
    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list = new List();
    CollectionReference collectionRef = Firestore.instance.collection("users")
        .document(uid)
        .collection('moods');
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents; // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();

    return list;
  }


  Future<Null> getData() async {
    var col = getCollection();
    List<TimeSeriesMoods> myData = [];
    col.then((coll) {
      dataMoods.clear();
      coll.forEach((moo) {
        myData.add(TimeSeriesMoods(
            DateTime.parse(moo.keys.toString().substring(1, 11)),
            int.parse(moo.values.toString().substring(1, moo.values
                .toString()
                .length - 1))));
        print('data : $dataMoods');
      });
      setState(() {
        dataMoods.clear();
        dataMoods = myData;
        sevenDaysData = selectData([
          DateTime.now().subtract(Duration(days: 6)),
          DateTime.now().add(new Duration(days: 1))
        ]);
        thirtyDaysData = selectData([
          DateTime.now().subtract(Duration(days: 31)),
          DateTime.now().add(new Duration(days: 1))
        ]);
        print('data : $dataMoods');
      });
    });
  }



  showMenuAddMood(snapshot) async {
    showModalBottomSheet(backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(message, textScaleFactor: 1.2,
                          style: TextStyle(fontFamily: 'coco',
                              color: Colors.grey[400]),
                          textAlign: TextAlign.center,),
                      ),

                      /* Padding(
                    padding: const EdgeInsets.only(bottom:40.0),
                    child: Text(message,textScaleFactor:1.2,style: TextStyle(fontFamily: 'coco',color: Colors.grey[400]),textAlign: TextAlign.center,),
                  ),*/
                      ClayContainer(
                        width: 150,
                        height: 130,
                        borderRadius: 75,
                        depth: 40,
                        spread: 10,
//curveType: CurveType.convex,
                        color: Colors.grey[100],
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                moodFromSlide.toString(), textScaleFactor: 2.2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'dot', color: sliderColor),),
                            ],),
                        ),
                      ),

                      Slider(
                        inactiveColor: Colors.transparent,
                        activeColor: sliderColor.shade300,
                        min: -100.5,
                        max: 100.5,
                        value: moodFromSlide.toDouble(),
                        divisions: 40,
                        onChanged: (newMood) =>
                        {setState(() {
                          sliderColor = rangeColor(newMood.toInt()).color;
                          moodFromSlide = newMood.toInt();
                          animateContainerGoCircle();
                          message = messageFromMood(moodFromSlide);
                        },),

                        },
                      ),


                      Center(
                        child: AnimatedContainer(
                          height: addButtonHeight,
                          width: addButtonWidth,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linearToEaseOut,
                          child: ClipRRect(
                            borderRadius: addButtonRadius,
                            child: RaisedButton(padding: EdgeInsets.all(0),
                              child: addButtonChild,
                              color: addButtonColor,
                              onPressed: () =>
                              {setState(() {
                                if (todayMood == null) {
                                  todayMood =
                                      TimeSeriesMoods(today, moodFromSlide);
                                  Map<String, int>newEntry = {
                                    DateTime(DateTime
                                        .now()
                                        .year, DateTime
                                        .now()
                                        .month, DateTime
                                        .now()
                                        .day,).toString(): moodFromSlide
                                  };
                                  data_instance.collection('users').document(
                                      uid).collection(
                                      "moods")
                                      .document(today.toString())
                                      .setData(newEntry);
                                  setState(() {
                                    getData();
                                    checkMedals();
                                  });
                                  //ToDo : Find a way to notify when new medals arrive
                                  /*for(int i=0; i<dataMedals.length;i++){
                                    if(dataMedals[i].date==today){
                                      _showMedal(dataMedals[i].nbRecords,dataMedals[i].date);
                                    }
                                  }*/
                                  animateContainerGoRectangle();
                                  //Navigator.pop(context);
                                }
                                else {
                                  setState(() {
                                    dialogEntryExists("Humeur déjà enregistrée",
                                        "Attendez demain ou modifiez l'humeur d'aujourd'hui.",
                                        snapshot);
                                  });
                                }
                              })},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }


  showOptionsMenu(snapshot) async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height/2.7,
                  decoration: BoxDecoration(color: Colors.teal[400],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),

                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[


                      Positioned(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width / 20,
                          bottom: 20,
                          child: InkWell(onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => LadderPage()));
                          },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ClayContainer(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 8,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.6,
                                      color: Colors.teal[400],
                                      surfaceColor: Colors.teal[400],
                                      borderRadius: 30,
                                      spread: 5,
                                      depth: 8,
                                      child: Center(child: Text(
                                          'Echelle', textScaleFactor: 1.3,
                                          style: TextStyle(color: Colors.white,
                                              fontFamily: 'dot')))),
                                ),
                              ))),
                      Positioned(
                          right: MediaQuery
                              .of(context)
                              .size
                              .width / 20,
                          top: 20,
                          child: InkWell(onTap: () {
                            setState(() {
                              newMedal=false;
                            });
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MedalsPage()));
                          },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ClayContainer(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 8,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.6,
                                      color: Colors.teal[400],
                                      surfaceColor: Colors.teal[400],
                                      borderRadius: 30,
                                      spread: 5,
                                      depth: 8,
                                      child: Center(child:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Medailles', textScaleFactor: 1.3, style: TextStyle(color: Colors.white, fontFamily: 'dot')),
                                          (newMedal)?
                                           Padding(
                                             padding: const EdgeInsets.only(top:8.0),
                                             child: Icon(Icons.new_releases, color: Colors.white,)):Container(height: 0,),
                                        ],
                                      )
                                      )
                                  ),
                                ),
                              ))),

                      Positioned(
                          left: MediaQuery
                              .of(context)
                              .size
                              .width / 20,
                          top: 20,
                          child: InkWell(onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                          },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ClayContainer(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 8,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2.6,
                                      color: Colors.teal[400],
                                      surfaceColor: Colors.teal[400],
                                      borderRadius: 30,
                                      spread: 5,
                                      depth: 8,
                                      child: Center(child: Text(
                                          'PROFIL', textScaleFactor: 1.3,
                                          style: TextStyle(color: Colors.white,
                                              fontFamily: 'dot')))),
                                ),
                              ))),
                      /*Positioned(top: MediaQuery
                          .of(context)
                          .size
                          .height / 5.55, child:
                      InkWell(
                        child: ClayContainer(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 1.8,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 5,
                            color: Colors.teal[400],
                            borderRadius: 30,
                            spread: 5,
                            depth: 8,
                            //curveType: CurveType.convex,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('TROPHEES\n[PLACEHOLDER]',
                                  textScaleFactor: 1.2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'dot'),),
                                Visibility(visible: true,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(Icons.assistant_photo,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      ),*/

                      /*Positioned(
                          right: MediaQuery
                              .of(context)
                              .size
                              .width / 1.75,
                          top: MediaQuery
                              .of(context)
                              .size
                              .height / 2.40,
                          child: InkWell(onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                          },
                              child: ClayContainer(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2.6,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 8,
                                  color: Colors.teal[400],
                                  borderRadius: 30,
                                  spread: 5,
                                  depth: 8,
                                  curveType: CurveType.concave,
                                  child: Center(child: Text(
                                      'WORDS\n[PLACEHOLDER]', textScaleFactor: 1.3,textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white,
                                          fontFamily: 'dot')))))),*/

                      Positioned(
                          bottom: 20,
                          right: MediaQuery
                              .of(context)
                              .size
                              .width / 10,
                          child: InkWell(onTap: () {
                            if(reminderButtonVisible){
                              changeReminderPrefs(false);
                              setState(() {
                                reminderButtonVisible = false;
                              });
                              _dontShowDailyAtTime();
                              Navigator.pop(context);
                              _displaySnackBar(context, reminderButtonVisible);
                              }
                            else{
                              changeReminderPrefs(true);
                              setState(() {
                                reminderButtonVisible = true;
                              });
                            _showDailyAtTime();
                              Navigator.pop(context);
                              _displaySnackBar(context, reminderButtonVisible);
                            }
                          },
                              child: ClayContainer(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2.6,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 8,
                                  color: Colors.teal[400],
                                  borderRadius: 30,
                                  spread: 5,
                                  depth: 8,
                                  emboss: reminderButtonVisible,
                                  curveType: (reminderButtonVisible) ? CurveType
                                      .concave : CurveType.none,
                                  child: Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('RAPPELS', textScaleFactor: 1.3,
                                          style: TextStyle(color: Colors.white,
                                              fontFamily: 'dot')),
                                      Visibility(visible: reminderButtonVisible,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(Icons.notifications,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ))))),


                    ],
                  ),
                );
              });
        });
  }


  Future<void> _showDailyAtTime() async {
    // if(activateReminder){
    var time = Time(20, 00, 0);
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
        "Cliquez pour ouvrir ThymTrack",
        time,
        platformChannelSpecifics);
    // }
  }

  Future<void> _dontShowDailyAtTime() async {
    await main.flutterLocalNotificationsPlugin.cancelAll();
  }

  _displaySnackBar(BuildContext context, bool reminderButtonVisible) {
    final snackBar =
    SnackBar(content: (reminderButtonVisible)?Text('Rappels activés : 20:00'):Text('Rappels désactivés'),
        duration:Duration(seconds: 1),
        backgroundColor: Colors.teal,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  makeList(myData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ListView.builder
        (reverse: false,
          controller: ScrollController(initialScrollOffset: 100000.0),
          itemCount: myData.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClayContainer(
                borderRadius: 10,
                height: 40.0,
                width: 300,
                depth: 10,
                spread: 7,
                color: Colors.grey[100],
                surfaceColor: Colors.grey[50],

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.only(
                        left: 0.0, bottom: 5.0, top: 5.0),
                      child: Container(width: 130.0,
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(dayFormatter.format(myData[index].time)
                                .toString(), textScaleFactor: 1.1,
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                            //new Text(hourFormatter.format(myData[index].time).toString(),textScaleFactor: 1.1,style: TextStyle(color: Colors.black,  fontWeight: FontWeight.normal),textAlign: TextAlign.left),
                          ],
                        ),),),
                    new Text("     ", textAlign: TextAlign.left,),
                    //new Text(myData[index].value.toString(),textScaleFactor: 1.4,style: TextStyle(fontWeight: FontWeight.bold,color:rangeColor(myData[index].value).color[rangeColor(myData[index].value).shade], )),
                    ClayContainer(
                      height: 20,
                      width: 80,
                      borderRadius: 30,
                      //curveType: CurveType.convex,
                      child: Center(child: Opacity(
                          opacity: 1.0, child: new Text(myData[index].value
                          .toString(), textScaleFactor: 1.6, style: TextStyle(
                        fontFamily: 'dot',
                        color: rangeColor(myData[index].value).color[rangeColor(
                            myData[index].value).shade],)))),
                      color: Colors.grey[100],
                      surfaceColor: Colors.grey[150],
                    ),

                  ],
                ),
              ),
            );
          }
      ),
    );
  }


  Future<void> dialogEntryExists(String title, String content, snapshot) async {
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
            OutlineButton(
              child: Text('Modifier', style: TextStyle(color: Colors.teal)),
              color: Colors.teal,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              onPressed: () {
                setState(() {
                  Map<String, int>newEntry = {
                    DateTime(DateTime
                        .now()
                        .year, DateTime
                        .now()
                        .month, DateTime
                        .now()
                        .day,).toString(): moodFromSlide
                  };
                  data_instance.collection('users').document(uid).collection(
                      "moods").document(today.toString()).setData(newEntry);
                  animateContainerGoRectangle();
                  getData();
                  checkMedals();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //ToDo : Find a way to notify when new medals arrive
                  /*for(int i=0; i<dataMedals.length;i++){
                    if(dataMedals[i].date==today){
                      _showMedal(dataMedals[i].nbRecords,dataMedals[i].date);
                    }
                  }*/
                });
              },

            ),
          ],
        );
      },
    );
  }


  animateContainerGoCircle() {
    if (addButtonWidth != 50) {
      setState(() {
        addButtonChild =
            Center(child: Icon(Icons.add_circle_outline, color: Colors.white,));
        addButtonColor = Colors.teal;
        addButtonWidth = 50;
        addButtonHeight = 50;
        addButtonRadius = BorderRadius.circular(30.0);
      });
    }
  }


  animateContainerGoRectangle() {
    setState(() {
      addButtonChild = ListView(scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text('Humeur enregistrée', style: TextStyle(
                      color: (rangeColor(moodFromSlide).color == Colors.yellow)
                          ? Colors.black
                          : Colors.white)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.done_outline,
                    color: (rangeColor(moodFromSlide).color == Colors.teal)
                        ? Colors.white
                        : Colors.lightGreen,),
                ),
              ])
        ],
      );
      addButtonColor = rangeColor(moodFromSlide).color;
      addButtonWidth = 200;
      addButtonHeight = 50;
      addButtonRadius = BorderRadius.circular(10.0);
    });
  }


  moodChanged(value) {
    setState(() {
      moodFromSlide = value;
    });
  }

  void _showMedal(nbRecords,date){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(backgroundColor: Colors.grey[200],
            content:Column(
              children: <Widget>[
                Text("${dayFormatter.format(date)}"),
                Container(
                    height:300,
                    width: 300,
                    decoration: BoxDecoration(
                      shape:BoxShape.circle,
                      image: DecorationImage(image:AssetImage('images/medal2.png'),colorFilter: ColorFilter.mode(Colors.teal, BlendMode.dst)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                          offset: Offset(
                            2.0, // Move to right 10  horizontally
                            2.0, // Move to bottom 10 Vertically
                          ),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                          offset: Offset(
                            -2.0, // Move to right 10  horizontally
                            -2.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],

                    ),

                    child:Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Positioned(
                          top:75,
                          child:Text("${medalList.where((med)=>med.nbRecords==nbRecords).toList()[0].nbRecords}",textScaleFactor: 1.5,textAlign: TextAlign.center,style: TextStyle(color:Colors.white),),
                        ),
                        Positioned(
                          child:Text("${medalList.where((med)=>med.nbRecords==nbRecords).toList()[0].title}",textScaleFactor: 1,textAlign: TextAlign.center,style: TextStyle(color:Colors.white)),
                        ),
                        /*Positioned(bottom:5,child: Text("${dayFormatter.format(dataMedals[i].date)}"),),*/
                      ],
                    )
                ),
                Text("${medalList.where((med)=>med.nbRecords==nbRecords).toList()[0].content}",textScaleFactor: 1,textAlign: TextAlign.center,style: TextStyle(color:Colors.black)),
              ],
            ),
            actions: <Widget>[
              FlatButton(child:Text('Fermer'),onPressed: (){Navigator.pop(context);},)
            ],

          );
        });

  }

  Future<Null> getMedals() async {
    var col = getCollection();
    List<obtainedMedal> myData = [];
    col.then((coll) {
      dataMedals.clear();
      coll.forEach((med) {
        myData.add(obtainedMedal(
            DateTime.parse(med.keys.toString().substring(1, 11)),
            int.parse(med.values.toString().substring(1, med.values
                .toString()
                .length - 1))));
        print('data : $dataMedals');
      });
      setState(() {
        dataMedals.clear();
        dataMedals = myData;

        print('data : $dataMedals');
      });
    });
  }

 Future<bool> getReminderPrefs()async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   bool decision =prefs.getBool('reminder');
   if(decision==null){return false;}
   else{
     print(decision);
     return decision;}

 }

changeReminderPrefs(bool reminder) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('reminder', reminder);
    print(prefs.getBool('reminder'));
  }

}

bool newMedalToday(){
  print("LENGTH ${dataMoods.length}");
  for(int i = 0;i<medalList.length;i++){
    if(dataMoods.length==medalList[i].nbRecords)
      {return true;}
    else{return false;}
  }
}


/*
///Voids used when data was saved in JSON

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

  */




