class TimeSeriesWords {
  TimeSeriesWords(this.time, this.words);

  final DateTime time;
  final String words;

  factory TimeSeriesWords.fromJson(dynamic json) {
    return TimeSeriesWords(json['time'] as DateTime, json['words'] as String);
  }

  @override
  String toString() {
    return '{ ${this.time}, ${this.words} }';
  }
}




/*




StreamBuilder<QuerySnapshot>(
stream: fire_users.document(uid).collection('moods').snapshots(),
builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot) {

if (dataMoods.isEmpty) {
dataMoods.add(TimeSeriesMoods(today,0));
return Container(
width: MediaQuery.of(context).size.width,
height: MediaQuery.of(context).size.height,
decoration: BoxDecoration(image: DecorationImage(image:AssetImage('images/background.png'),fit: BoxFit.fill)),
child:Column(
mainAxisAlignment: MainAxisAlignment.end,
children: <Widget>[
Image.asset('images/logo.png',height: 100,),

Text('Connexion en cours...',style:(TextStyle(color: Colors.grey[100])),textScaleFactor: 2.0,),
SizedBox(height: 300,),
CircularProgressIndicator(backgroundColor: Colors.white,),
SizedBox(height: 100,)
],
)
);
} else {


*/
/*            var collectionReference= Firestore.instance.collection('users').document(uid).collection('moods');
            var query = collectionReference;
            query.getDocuments().then((querySnapshot)=> {
           querySnapshot.documents.forEach((document)=>{
             data.add(TimeSeriesMoods(DateTime.parse(document.data.keys.toString().substring(1,11)),int.parse(document.data.values.toString().substring(1,3))))
           })


                // check and do something with the data here.
            });*//*




message="Comment vous sentez-vous aujourd'hui?";

var selectedData = selectData(initialRange);
var screenSize=MediaQuery.of(context).size;



return DefaultTabController(length: nbTabs,
child: new Scaffold(
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
Tooltip(message: 'Réglages',
child: FlatButton(
onPressed: () {
Scaffold.of(context).openDrawer();
*/
/*Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                    return SettingPage();
                                  }), ModalRoute.withName('/'));*//*

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
Icons.dehaze,
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



drawer: Drawer(),

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
colorFn:  (TimeSeriesMoods moods, _) {
return (rangeColor(moods.value.toInt()).color==Colors.red)? charts.MaterialPalette.red.shadeDefault.darker:
(rangeColor(moods.value).color==Colors.yellow)? charts.MaterialPalette.yellow.shadeDefault.darker:
(rangeColor(moods.value).color==Colors.teal)? charts.MaterialPalette.teal.shadeDefault.darker:charts.MaterialPalette.pink.shadeDefault;},
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
colorFn:  (TimeSeriesMoods moods, _) {
return (rangeColor(moods.value.toInt()).color==Colors.red)? charts.MaterialPalette.red.shadeDefault.darker:
(rangeColor(moods.value).color==Colors.yellow)? charts.MaterialPalette.yellow.shadeDefault.darker:
(rangeColor(moods.value).color==Colors.teal)? charts.MaterialPalette.teal.shadeDefault.darker:charts.MaterialPalette.pink.shadeDefault;},
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
id: 'Moods',
colorFn:  (TimeSeriesMoods moods, _) {
return (rangeColor(moods.value.toInt()).color==Colors.red)? charts.MaterialPalette.red.shadeDefault.darker:
(rangeColor(moods.value).color==Colors.yellow)? charts.MaterialPalette.yellow.shadeDefault.darker:
(rangeColor(moods.value).color==Colors.teal)? charts.MaterialPalette.teal.shadeDefault.darker:charts.MaterialPalette.pink.shadeDefault;},
domainFn: (TimeSeriesMoods moods,
_) => moods.time,
measureFn: (TimeSeriesMoods moods,
_) => moods.value,
data: thirtyDaysData,
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
lastDate: new DateTime(2050),
//locale: myLocale,
/// TODO set date picker w/ french date disp
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
showMenuAddMood(snapshot);
},
),
floatingActionButtonLocation: FloatingActionButtonLocation
    .centerDocked,
),
);
}
});*/
