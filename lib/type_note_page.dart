import 'package:bipo/dashboard.dart';
import 'package:flutter/material.dart';
import 'notes.dart';
import 'package:clay_containers/clay_containers.dart';
import 'sign_in.dart';
import 'data.dart';


class TypeNotePage extends StatefulWidget {
  final DateTime myDate;
  TypeNotePage(this.myDate);

  @override
  _TypeNotePageState createState() => _TypeNotePageState(this.myDate);
}


class _TypeNotePageState extends State<TypeNotePage> with TickerProviderStateMixin {
  _TypeNotePageState(this.myDate);
  DateTime myDate;

  TextAlign textAlign=TextAlign.center;




  @override
  void initState() {
    getNotes();
    super.initState();
  }
  


  @override
  Widget build(BuildContext context) {
    String previousNote=(dataNotes.where((element) => element.date==myDate).isEmpty)?""
        :dataNotes.firstWhere((element) => element.date==myDate).note.substring(1,dataNotes.firstWhere((element) => element.date==myDate).note.length-1);
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        centerTitle: true,
        backgroundColor: Colors.teal,

        title: Column(
          children: <Widget>[
            new Text(
              "Ajouter un note", textAlign: TextAlign.center,
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
              Container(color: Colors.grey[100],
                //height: MediaQuery.of(context).size.height,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: ClayContainer(
                        borderRadius: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: TextFormField(
                              autofocus: true,
                                initialValue: previousNote,
                                textCapitalization: TextCapitalization.sentences,
                                textInputAction: TextInputAction.send,
                                style: TextStyle(color:Colors.grey[800]),
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Quels évènements ont \nmarqué cette journée ?'






                                ),
                                textAlign: textAlign,
                                onChanged: (textInput){
                                (textInput!="")?setState(() {
                                  textAlign=TextAlign.start;
                                }):
                                setState(() {
                                  textAlign=TextAlign.center;
                                });
                                },
                                onFieldSubmitted: (textInput) =>
                                {setState(() {
                                  updateToday();
                                  Map<String, String>newEntry = {
                                    today.toString(): textInput
                                  };
                                  dataInstance.collection('users').document(
                                      uid).collection(
                                      "notes")
                                      .document(today.toString())
                                      .setData(newEntry);
                                  getNotes();
                                Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                return DashBoard();
                                }), ModalRoute.withName('/'));
                                })}
                            ),
                          ),
                        ),
                      ),
                    ),


                    ],
                  )
              ),
            ],
          )
      ),
    );
  }



  Future<List<Note>> getNotes() async {
    var col = getNotesCollection();
    List<Note> myData = [];
    col.then((coll) {
      dataNotes.clear();
      coll.forEach((note) {
        myData.add(Note(
            DateTime.parse(note.keys.toString().substring(1, 11)),
            note.values.toString()));

      });
      setState(() {
        dataNotes.clear();
        dataNotes = myData;
      });
    });
    return myData;
  }
}
