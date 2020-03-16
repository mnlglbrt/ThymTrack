import 'package:bipo/dashboard.dart';
import 'package:bipo/type_note_page.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPlaying=false;
  Widget footerContent;
  String addButtonContent;
  List<Word> selectedWords;
  _WordsPageState(this.myDate);
  List<bool> isSelected=[];
  List<Word>myWords=[];
TextEditingController controller;
  bool textFieldVisible=false;




  @override
  void initState() {
    getWords();
    myWords=datedFeelings[myDate];
    selectedWords=(datedFeelings.containsKey(myDate))?datedFeelings[myDate]:[];
    List<int> listOfIndex=[];

    if(myWords!=null){
    for(int i=0;i<allWords.length;i++){
      bool present=false;
      for(int j=0;j<myWords.length;j++){
        if (!present){
        if(allWords[i].word==myWords[j].word){present=true;}
      }}
      isSelected.add(present);
    }
    }else{
      for(int i=0;i<allWords.length;i++){
        isSelected.add(false);
      }
    }
    print("HERE $isSelected");


    addButtonContent="0";

    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    updateToday();

    selectedWordsToday={myDate:selectedWords};

    footerContent=(selectedWords.isEmpty)?Container():Wrap(direction: Axis.vertical, children: wordsToChipList(selectedWords));
    return Scaffold(
      key: _scaffoldKey,
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
                              (textFieldVisible)?Container():Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(icon:new Icon(Icons.person_add, color:Colors.teal),onPressed: (){setState(() {
                                    textFieldVisible=!textFieldVisible;
                                  });},),
                                  Text("Enrichir",style: TextStyle(color:Colors.teal),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      (textFieldVisible)?Stack(
                        children: <Widget>[
                          TextField(cursorColor: Colors.teal,
                            cursorWidth: 10.0,
                            cursorRadius: Radius.circular(60),
                            controller: controller,
                            decoration: InputDecoration(hintText: "Demander l'ajout d'une émotion"),
                            onSubmitted: (input){
                            Map<String, String>newWord = {};
                            newWord[today.toString()+name+uid+input]=input;
                            dataInstance.collection('askedWords')
                                .document(today.toString()+name+uid+input).setData(newWord);
                            _showSnackBar(context);
                            setState(() {
                              textFieldVisible=!textFieldVisible;
                            });
                          },),
                          Positioned(right:0,child: FlatButton(child: Icon(Icons.clear),onPressed:(){ setState(() {
                            textFieldVisible=!textFieldVisible;
                          });}))
                        ],
                      ):Container(),
                      (!textFieldVisible)?Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.teal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(child: SingleChildScrollView(child: Wrap(direction: Axis.vertical, children: wordsToChipList(selectedWords)),scrollDirection: Axis.horizontal,)),
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
                                      dataInstance.collection('users').document(
                                          uid).collection(
                                          "feels")
                                          .document(myDate.toString()).setData(newEntry);
                                      setState(() {
                                        getWords();
                                      });
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => TypeNotePage(myDate)));
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

//print("ISSELECTED: $isSelected");
    for(int i=0;i<list.length;i++){
      widgetList.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child:(list[i].word=="Joie" || list[i].group!=list[i-1].group)?
        new Container(width:MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color:groupColor(list[i].group),width: 1.2))),
            child:Center(child: Text(list[i].group,textScaleFactor: 2.0,style: TextStyle(color: groupColor(list[i].group)),))):

        new InputChip(
            label:Text(list[i].word,style: TextStyle(color: Colors.black),textScaleFactor: 1.3,),
          backgroundColor: groupColor(list[i].group),
          selectedColor: Colors.white,
          selected:isSelected[i],
            onPressed: () {
              setState(() {
            if(selectedWords.length<3){
              if(isSelected[i]==false){
                print('A');
                isSelected[i]=true;
                selectedWords.add(allWords[i]);
                print(selectedWords.length);

              }else if(isSelected[i]==true){
                print('B');
                  isSelected[i]=false;
                  selectedWords.removeWhere((word) => word.word==allWords[i].word);
                  print(selectedWords.length);

            }
            }

            else if(selectedWords.length<4){

              if(isSelected[i]==true){
                print('C');
                print(selectedWords.length);
                print(selectedWords);
                  isSelected[i]=false;
                  setState(() {
                    selectedWords.removeWhere((word) => word.word==allWords[i].word);
                  });
                  print(selectedWords.length);
                print(selectedWords);

              }else if(isSelected[i]==false){
                print('D');
                  print("deja 3 mots");

              }


            }
});
/*
            /// - de 3 mots selectionnes et clique sur non-selec
              if(selectedWords.length<3 && isSelected[i]==false){
                print(1);
                setState(() {
                  isSelected[i] = true;
                  selectedWords.add(allWords[i]);
                  footerContent=(selectedWords.isEmpty)?Container():Wrap(direction: Axis.vertical, children: wordsToChipList(selectedWords));
                });}else if(selectedWords.length<3 && isSelected[i]==true){ /// - de 3 mots selectionnes clique sur selec
                print(3);
                setState(() {
                  isSelected[i] = false;
                  selectedWords.removeWhere((thisWord) => thisWord.word==allWords[i].word);
                  selectedWords=selectedWords;
                  footerContent=(selectedWords.isEmpty)?Container():Wrap(direction: Axis.vertical, children: wordsToChipList(selectedWords));
                });}
              else if(selectedWords.length==3 && isSelected[i]==true){/// 3 mots selectionnes et clique sur selec
                print(2);
                setState(() {
                  isSelected[i] = false;
                  selectedWords.remove(allWords[i]);
                  print(selectedWords.length);
                  footerContent=(selectedWords.isEmpty)?Container():Wrap(direction: Axis.vertical, children: wordsToChipList(selectedWords));
                });}

              setState(() {
                addButtonContent=selectedWords.length.toString();
                footerContent=(selectedWords.isEmpty)?Container():Wrap(direction: Axis.vertical, children: wordsToChipList(selectedWords));
              });
              print("SelectedWords : $selectedWords");*/
            }
        ),
        //backgroundColor: groupColor(list[i].group)
      ));
    }
return widgetList;
  }

  _showSnackBar(BuildContext context) {
    final snackBar =
    SnackBar(content: Text('Merci. Votre émotion sera ajoutée prochainement.'),
      duration:Duration(seconds: 3),
      backgroundColor: Colors.teal,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
      (group=="État physique")?Colors.lime:
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
