import 'package:bipo/dashboard.dart';
import 'package:flutter/material.dart';
import 'words.dart';
import 'package:clay_containers/clay_containers.dart';
import 'sign_in.dart';
import 'data.dart';

class WordsPage extends StatefulWidget {
  final DateTime myDate;

  WordsPage(this.myDate);

  @override
  _WordsPageState createState() => _WordsPageState(this.myDate);
}


class _WordsPageState extends State<WordsPage> with TickerProviderStateMixin {
  DateTime myDate;
  AnimationController animationController;
  bool isPlaying=false;
  Widget headerContent;
  String addButtonContent;

  _WordsPageState(this.myDate);

  List<bool> isSelected=[];
  List<Word> selectedWords=[];


  @override
  void initState() {
    for(int i=0;i<allWords.length;i++){
      isSelected.add(false);}
    getWords();
    animationController=AnimationController(vsync: this, duration: Duration(seconds: 1));
    headerContent=Container();
    addButtonContent="0";
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    animationController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    updateToday();
    selectedWordsToday={today:selectedWords};
    return Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          centerTitle: true,
          backgroundColor: Colors.teal,

          title: Column(
            children: <Widget>[
              new Text(
                "EMOTIONS", textAlign: TextAlign.center,
                textScaleFactor: 0.8,
                style: new TextStyle(
                  fontFamily: 'dot',
                  color: Colors.white,),),
              (myDate==today)?Container():Opacity(opacity:0.5,child: Text("Pour le ${dayFormatter.format(myDate)}", textScaleFactor: 0.8,)),
            ],
          ),

          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/logo.png'),
          ),

          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Tooltip(message: 'Retour',
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0,),
                      child: ClayContainer(
                        borderRadius: 75,
                        depth: 10,
                        spread: 7,
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
                              Icons.arrow_back,
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

        body: Center(
            child: Stack(
              children: <Widget>[
                Container(
                  //height: MediaQuery.of(context).size.height,
                  child:Column(
                    
                    children: <Widget>[

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[

                              Wrap(alignment: WrapAlignment.spaceEvenly,
                                children: wordsToInputChipList(allWords,isSelected)
                              ),
                            ],
                          ),
                        ),
                      ),
                      (selectedWords.length>0)?Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.teal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(child: SingleChildScrollView(child: headerContent,scrollDirection: Axis.horizontal,)),
                                Padding(
                                  padding: const EdgeInsets.only(right:15.0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.teal[300])
                                    ),
                                   color : Colors.teal,
                                    child: Text('Enregistrer',style: TextStyle(color: Colors.white),),
                                    onPressed:(){
                                      Map<String, String>newEntry = {};
                                      for(int i=0; i<selectedWords.length;i++){
                                        newEntry[selectedWords[i].word]=selectedWords[i].group;
                                      }
                                      data_instance.collection('users').document(
                                          uid).collection(
                                          "feels")
                                          .document(myDate.toString()).setData(newEntry);
                                      setState(() {
                                        getWords();
                                      });
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (context) {
                                            return DashBoard();
                                          }), ModalRoute.withName('/'));
                                    },
                                  ),
                                ),])
                      ):Container(),
                    ],
                  )
                ),
              ],
            )
        ),
    );
  }


  wordsToInputChipList (List<Word> list, List<bool> isSelected){
    List<Widget> widgetList=[];

    for(int i=0;i<list.length;i++){
      isSelected.add(false);
      widgetList.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child:(list[i].word=="Joie" || list[i].group!=list[i-1].group)?
        new Container(width:MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color:groupColor(list[i].group),width: 1.2))),
            child:Center(child: Text(list[i].group,textScaleFactor: 2.0,style: TextStyle(color: groupColor(list[i].group)),))):

        new InputChip(backgroundColor: groupColor(list[i].group),selectedColor: Colors.green,selected:isSelected[i],
            onSelected: (bool value) {
              (selectedWords.length<3 && isSelected[i]==false)?
              setState(() {
                isSelected[i] = value;
                selectedWords.add(list[i]);
                print(selectedWordsToday);
              }):(isSelected[i]==true)?

              setState(() {
                isSelected[i] = value;
                selectedWords.remove(list[i]);
                print(selectedWordsToday);
              }):selectedWords=selectedWords;
              print(selectedWords);
              setState(() {
                addButtonContent=selectedWords.length.toString();
                headerContent=Wrap(direction: Axis.vertical,
                  children: wordsToChipList(selectedWords)
                );
              });
              if(selectedWords.isNotEmpty){

              }
            }
        ,label:Text(list[i].word,style: TextStyle(color: Colors.black),textScaleFactor: 1.3,),),
        //backgroundColor: groupColor(list[i].group)
      ));
    }
return widgetList;
  }

  wordsToChipList (List<Word> list){
    List<Widget> widgetList=[];

    for(int i=0;i<list.length;i++){
      widgetList.add(Padding(
        padding: const EdgeInsets.all(5.0),
        child: new Chip(backgroundColor: groupColor(list[i].group),

          label:Text(list[i].word,style: TextStyle(color: Colors.black),textScaleFactor: 1,),),
        //backgroundColor: groupColor(list[i].group)
      ));
    }
    return widgetList;
  }

  Color groupColor(String group){
    return
      (group=="Joie")?Colors.pink[300]:
      (group=="Estime de soi")?Colors.pink[200]:
      (group=="Actif")?Colors.deepOrange[400]:
      (group=="Pleinitude")?Colors.teal[300]:
      (group=="Mauvaise estime de soi")?Colors.indigo[200]:
      (group=="Solitude")?Colors.grey:
      (group=="Stress")?Colors.red[300]:
      (group=="Dépression")?Colors.blue[300]:Colors.black;

  }

  Future<Null> getWords() async {
    var col = getFeelingsCollection();
    //Map <DateTime,List<Word>> myMap = {};

    col.then((coll) {
      datedFeelings=coll;
      //print('datafeelings $datedFeelings');
    });
  }
}
