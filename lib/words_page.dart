import 'package:bipo/dashboard.dart';
import 'package:flutter/material.dart';
import 'words.dart';
import 'package:clay_containers/clay_containers.dart';
import 'sign_in.dart';
import 'package:random_color/random_color.dart';
import 'data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordsPage extends StatefulWidget {
  DateTime myDate;

  WordsPage(this.myDate);

  @override
  _WordsPageState createState() => _WordsPageState(this.myDate);
}


class _WordsPageState extends State<WordsPage> {
  DateTime myDate;

  _WordsPageState(this.myDate);

  List<bool> isSelected=[];
  List<Word> selectedWords=[];


  @override
  void initState() {
    for(int i=0;i<allWords.length;i++){
      isSelected.add(false);}
    getWords();

    super.initState();
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
            child: Container(
              //height: MediaQuery.of(context).size.height,
              child:SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    Wrap(alignment: WrapAlignment.spaceEvenly,
                      children: wordsToInputChipList(allWords,isSelected)
                    ),
                  ],
                ),
              )
            )
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle_outline),
        backgroundColor: Colors.teal,
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
              if(selectedWords.isNotEmpty){

              }
            }
        ,label:Text(list[i].word,style: TextStyle(color: Colors.black),textScaleFactor: 1.3,),),
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
