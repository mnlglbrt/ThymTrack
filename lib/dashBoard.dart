
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'data.dart';
import 'dart:convert';
import 'mood_ranges.dart';
import 'timeSeriesMoods.dart';
import'package:path_provider/path_provider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'dart:async';
import 'package:clay_containers/clay_containers.dart';
import 'login_page.dart';
import 'sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'first_connection_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashBoard extends StatefulWidget {
  DashBoard({Key key}) : super(key: key);


  @override
  _DashBoardState createState() => _DashBoardState();

}

class _DashBoardState extends State<DashBoard> {
  var today=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,);

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    data.clear();
    getData();

  }

  ///
  ///OTHER VARIABLES
  var dayFormatter = new DateFormat('dd/MM/y');
  var hourFormatter= new DateFormat('H:mm');
  int moodFromSlide = 0;
  TextStyle white=TextStyle(color: Colors.white);
  TextStyle black=TextStyle(color: Colors.black);
  ///


  List<int> moodList=[];
  var buttonRadius=BorderRadius.circular(30.0);
  var sliderColor=Colors.teal;
  var buttonColor = Colors.red;
  var buttonTextColor=Colors.grey[900];
  var buttonHeight = 0.0;
  var buttonWidth = 0.0;
  dynamic buttonChild=Text('');
  bool buttonVisible=true;
  List<DateTime>initialRange=[DateTime.now().subtract(new Duration(days: 6)),DateTime.now()];
  PageController pageController= PageController();
  int nbTabs=3;
  BuildContext bsContext;
  String message="";
  TimeSeriesMoods todayMood;
  var listdates=[];
  var listmoods=[];
  var doc;





  Widget build(BuildContext context) {


    return StreamBuilder<QuerySnapshot>(
    stream: fire_users.document(uid).collection('moods').snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {

    if (data.isEmpty) {
        data.add(TimeSeriesMoods(today,0));
      return Center(
        child: Container(
        child:CircularProgressIndicator(backgroundColor: Colors.white,)
      ),
    );
    } else {


/*            var collectionReference= Firestore.instance.collection('users').document(uid).collection('moods');
            var query = collectionReference;
            query.getDocuments().then((querySnapshot)=> {
           querySnapshot.documents.forEach((document)=>{
             data.add(TimeSeriesMoods(DateTime.parse(document.data.keys.toString().substring(1,11)),int.parse(document.data.values.toString().substring(1,3))))
           })


                // check and do something with the data here.
            });*/



            message="Comment vous sentez-vous aujourd'hui?";
            var sevenDaysData=selectData([DateTime.now().subtract(Duration(days:6)),DateTime.now().add(new Duration(days: 1))]);
            var thirtyDaysData=selectData([DateTime.now().subtract(Duration(days:29)),DateTime.now().add(new Duration(days: 1))]);
            var selectedData = selectData(initialRange);
            var screenSize=MediaQuery.of(context).size;



            return DefaultTabController(length: nbTabs,
              child: new Scaffold(
                appBar: AppBar(
                  elevation: 10.0,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: new Text(
                          "Bipol'Air", textAlign: TextAlign.center,
                          textScaleFactor: 2.0,
                          style: new TextStyle(
                            fontFamily: 'simplePrint',
                            fontStyle: FontStyle.italic,
                            color: Colors.white,),),
                      ),
                    ),
                  ),
                  leading: Image.asset('images/logo.png'),
                  actions: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Tooltip(message: 'Deconnexion',
                          child: FlatButton(
                            onPressed: () {
                              signOutGoogle();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                    return LoginPage();
                                  }), ModalRoute.withName('/'));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0,),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    imageUrl,
                                  ),
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
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


                body: TabBarView(
                    children: <Widget>[


                      ///                                                      CHART 7 :   GRAPH POUR 7 DERNIERS JOURS
                      Column(
                        children: <Widget>[
                          Flexible(flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  Card(elevation: 0.0,
                                    color: Colors.grey[100],
                                    child: Container(
                                      height: 400.0,
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
                                              colorFn: (_, __) =>
                                              charts.MaterialPalette.teal
                                                  .shadeDefault.lighter,
                                              domainFn: (TimeSeriesMoods moods,
                                                  _) => moods.time,
                                              measureFn: (TimeSeriesMoods moods,
                                                  _) => moods.value,
                                              data: sevenDaysData,
                                            )
                                          ]),
                                    ),
                                  ),


                                  ///                                                      LIST 7 :   LIST POUR 7 DERNIERS JOURS
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


                      ///                                                      CHART 30 :   GRAPH POUR 30 DERNIERS JOURS
                      Column(
                        children: <Widget>[
                          Flexible(flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  Card(elevation: 0.0,
                                      color: Colors.grey[100],
                                      child: Container(
                                        height: 400.0,
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
                                                colorFn: (_, __) =>
                                                charts.MaterialPalette.teal
                                                    .shadeDefault,
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


                                  ///                                                      LIST 30 :   LIST POUR 30 DERNIERS JOURS
                                  (selectedData.isEmpty) ? Text("Pas d'entrée") :
                                  Flexible(flex: 2,
                                    child: makeList(thirtyDaysData),
                                  ),

                                ]),
                          ),
                        ],
                      ),


                      ///                                                     GRAPH perso POUR SELECTED RANGE
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  Card(elevation: 0.0,
                                      child: Container(
                                        height: 400.0,
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
                                                id: 'custom',
                                                colorFn: (_, __) =>
                                                charts.MaterialPalette.teal
                                                    .shadeDefault.darker,
                                                areaColorFn: (_, __) =>
                                                charts.MaterialPalette.blue
                                                    .shadeDefault.lighter,
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


                                  ///DATE RANGE SELECTOR

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClayContainer(
                                      color: Colors.grey[100],
                                      parentColor: Colors.white,
                                      width: 300,
                                      height: 50,
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
                                                lastDate: new DateTime(2050)
                                            );
                                            if (picked != null &&
                                                picked.length == 2) {
                                              setState(() {
                                                getData();
                                                initialRange = picked;
                                                selectedData.clear();
                                                selectedData = selectData(picked);
                                              });
                                            }
                                          },


                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              children: <Widget>[
                                                new Text('${new DateFormat(
                                                    "dd-MM-yyyy").format(
                                                    initialRange[0])}'),
                                                new Icon(Icons.calendar_today),
                                                new Text('${new DateFormat(
                                                    "dd-MM-yyyy").format(
                                                    initialRange[1])}'),
                                              ]
                                          )
                                      ),
                                    ),
                                  ),


                                  ///                                                      LIST PERSO
                                  (selectedData.isEmpty) ? Text("Pas d'entrée") :
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
                    showMenu(snapshot);
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
  ///
  ///             FONCTIONS           FONCTIONS           FONCTIONS
  ///
  ///
  ///

  Future<Null> checkFocChanges() async {
    Firestore.instance.runTransaction((Transaction tx) async {
      CollectionReference reference = Firestore.instance.collection('users').document(uid).collection('moods').reference();
      reference.snapshots().listen((documentSnapshot) {
        documentSnapshot.documentChanges.forEach((change) {
          // Do something with change

          for(int i=0; i<documentSnapshot.documents[0].data.values.length-1;) {
            listdates.add(DateTime.parse(
                documentSnapshot.documents[0].data.keys.toString().substring(
                    1, 11)));
            listmoods.add(int.parse(
                documentSnapshot.documents[0].data.values.toString().substring(
                    1, documentSnapshot.documents[0].data.values
                    .toString()
                    .length - 1)));

            data.add(TimeSeriesMoods(
                listdates[i], listmoods[i])
            );
          }
        });
        });
      });
    }

  Future <List<Map<dynamic, dynamic>>> getCollection() async{
    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list = new List();
    CollectionReference collectionRef = Firestore.instance.collection("users").document(uid).collection('moods');
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents; // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data;
    }).toList();

    return list;
  }


  Future<Null> getData()async{
    var col=getCollection();
    col.then((coll){
      setState(() {
        data.clear();
        coll.forEach((moo){
          data.add(TimeSeriesMoods(DateTime.parse(moo.keys.toString().substring(1,11)),int.parse(moo.values.toString().substring(1,moo.values.toString().length-1))));
          print('data : $data');
        });
      });

    });
  }

  showMenu(snapshot) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
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
                          Text(moodFromSlide.toString(),textScaleFactor: 2.2,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'dot',color: sliderColor),),],),
                    ),
                  ),

                  Slider(
                    inactiveColor: Colors.transparent,
                    activeColor:sliderColor.shade300,
                    min: -100.5,
                    max: 100.5,
                    value: moodFromSlide.toDouble(),
                    divisions: 40,
                    onChanged: (newMood) =>
                    {setState(() {
                      sliderColor=rangeColor(newMood.toInt()).color;
                      moodFromSlide = newMood.toInt();
                      animateContainerGoGreen();
                      message=messageFromMood(moodFromSlide);


                    },),

                    },
                  ),


                  Center(
                    child: AnimatedContainer(
                      height: buttonHeight,
                      width: buttonWidth,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.linearToEaseOut,
                      child: ClipRRect(
                        borderRadius: buttonRadius,
                        child: RaisedButton(padding: EdgeInsets.all(0),child: buttonChild,color: buttonColor, onPressed: () =>
                        {setState(() {
                          if (todayMood==null) {
                            todayMood=TimeSeriesMoods(today,moodFromSlide);
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
                            setState(() {
                              getData();
                            });
                            animateContainerGoGrey();
                            Navigator.pop(context);
                          }
                          else{setState(() {
                            dialogEntryExist("Humeur déjà enregistrée", "Attendez demain ou modifiez l'humeur d'aujourd'hui.",snapshot);
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



  makeList(myData){
    return Padding(
      padding: const EdgeInsets.only(bottom:20.0),
      child: ListView.builder
        (reverse:false,
          controller: ScrollController(initialScrollOffset: 100000.0),
          itemCount: myData.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: ClayContainer(
                borderRadius: 10,
                height: 40.0,
                width : 300,
                depth: 10,
                spread: 7,
                color: Colors.grey[100],
                surfaceColor: Colors.grey[50],

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.only(left:0.0, bottom:5.0,top:5.0),
                      child: Container(width: 130.0,
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(dayFormatter.format(myData[index].time).toString(),textScaleFactor: 1.1,style: TextStyle(color: Colors.black,  fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                            //new Text(hourFormatter.format(myData[index].time).toString(),textScaleFactor: 1.1,style: TextStyle(color: Colors.black,  fontWeight: FontWeight.normal),textAlign: TextAlign.left),
                          ],
                        ),),),
                    new Text("     ",textAlign: TextAlign.left,),
                    //new Text(myData[index].value.toString(),textScaleFactor: 1.4,style: TextStyle(fontWeight: FontWeight.bold,color:rangeColor(myData[index].value).color[rangeColor(myData[index].value).shade], )),
                   ClayContainer(
                       height: 20,
                       width:80,
                       borderRadius: 30,
                       //curveType: CurveType.convex,
                       child:Center(child: Opacity(opacity:1.0,child: new Text(myData[index].value.toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(myData[index].value).color[rangeColor(myData[index].value).shade], )))),
                     color: Colors.grey[100],
                     surfaceColor: Colors.grey[150],
                       ),

                  ],
                ),
              ),
            );}
      ),
    );
  }


  Future<void> dialogEntryExist(String title, String content,snapshot) async {
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
              child: Text('Modifier',style: TextStyle(color: Colors.teal)),
              color: Colors.teal,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
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
                    animateContainerGoGrey();
                    getData();
                    Navigator.pop(context);
                    Navigator.pop(context);

                });

              },

            ),
          ],
        );
      },
    );
  }





  animateContainerGoGreen() {
    if(buttonWidth != 50){
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
      buttonColor=rangeColor(moodFromSlide).color;
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

  String messageFromMood(mood){
    return (mood<-49)?"Prenez contact avec quelqu'un\n\nqui pourra vous écouter.":
    (mood<-9)?"Positivez !\n\nFocalisez-vous sur ce qui va.":
    (mood<15)?"Ravi de vous voir en forme !\n\nPassez une bonne journée.":
    (mood<50)?"Quelle mine incroyable !\n\nJe suis sûr que votre\njournée sera excellente.":
    (mood<70)?"Quel anthousiasme !\n\nPensez a vous ménager.":
    (mood<=100)?"Vous êtes au summum du UP!\n\nAttention à ne pas dépasser les limites.":'';


    }

  DateTime stringToDateTime(String string){
    return DateTime.parse(string);
  }

  int stringToInt(String string){
    return int.parse(string);
  }


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

  Future<void> fisrtConnectionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bienvenue sur Bipol'Air"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Notre application vous permet de suivre votre humeur au quotidien.\n '
                    'Touchez le bouton + pour entrer votre humeur sur une echelle entre -100 et +100.'
                    'Allez-y, cest à vous !'),
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

          ],
        );
      },
    );
  }


/*  void createFile(Map<String,dynamic> content,Directory dir, String fileName){
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
    animate: true,
    animationDuration:Duration(milliseconds: 500),
    dateTimeFactory: const charts.LocalDateTimeFactory(),
    domainAxis: charts.DateTimeAxisSpec(
      tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
        day: charts.TimeFormatterSpec(
          format: 'dd.MM.yy',
          transitionFormat: 'dd.MM.yy',
        ),hour: charts.TimeFormatterSpec(
        format: 'dd.MM.yy',
        transitionFormat: 'dd.MM.yy',
      ),
        minute: charts.TimeFormatterSpec(
          format: 'dd.MM.yy',
          transitionFormat: 'dd.MM.yy',
        ),
      ),
    ),
  );

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesMoods, DateTime>> _createSampleData() {
    return <charts.Series<TimeSeriesMoods, DateTime>>[
      charts.Series<TimeSeriesMoods, DateTime>(
        id: 'Moods',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (TimeSeriesMoods moods, _) => moods.time,
        measureFn: (TimeSeriesMoods moods, _) => moods.value,
        data: selectedData,
      )
    ];
  }


}
