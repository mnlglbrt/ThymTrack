import 'package:bipo/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'data.dart';
import 'package:clay_containers/clay_containers.dart';
import 'mood_ranges.dart';

class LadderPage extends StatefulWidget {
  @override
  _LadderPageState createState() => _LadderPageState();
}

class _LadderPageState extends State<LadderPage> {

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>stats=getStats(dataMoods);
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        centerTitle: true,
        backgroundColor: Colors.teal,

        title: new Text(
          "Echelle Thymique", textAlign: TextAlign.center,
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
        child: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(reverse: true,
    controller: ScrollController(),
    itemCount: moodLadder.length,
    itemBuilder: (BuildContext context, int i) {
      return Container(
        decoration: BoxDecoration(
            color:moodLadder[i].color,
            //border: Border(top: (i==10 || i==8 || i==6 || i==3 || i==1)?BorderSide(width: 2.0,color: moodLadder[i].color):BorderSide(width: 0.0)),
            borderRadius:(i==10 || i==8 || i==6 || i==3 || i==1)? BorderRadius.only(topRight: Radius.circular(40.0),topLeft: Radius.circular(0.0),):(i==9 || i==7 || i==4 || i==2 || i==0)?BorderRadius.only(bottomLeft: Radius.circular(40.0),bottomRight: Radius.circular(0.0),):BorderRadius.only()),
        child: Padding(
          padding: const EdgeInsets.only(left:10.0,right:10.0,top:20.0,bottom:20.0),
          child: Column(
            children: <Widget>[


              (i==1 || i==10 || i==3 || i==5 || i==8)?Text(moodLadder[i].name,textScaleFactor: 2.0,style: TextStyle(fontFamily: 'dot',color:Colors.grey[900])):Container(),
              (moodLadder[i].start < 0&& i!=5) ?Text(moodLadder[i].end.toString(), style:TextStyle(backgroundColor:moodLadder[i].color,fontFamily: 'dot',color:Colors.grey[900]),textScaleFactor: 2.0) : Container(),
              (moodLadder[i].start < 0) ?Icon(Icons.arrow_upward,color: Colors.black.withOpacity(0.2), size:30) : Container(),
              (moodLadder[i].start < 0) ?Text(moodLadder[i].detail,textAlign:TextAlign.center,textScaleFactor: 1.3,style: TextStyle(fontFamily: 'productSans',color:Colors.grey[700])):Container(),
              (moodLadder[i].end==100)?Text('100',style: TextStyle(backgroundColor:moodLadder[i].color,fontFamily: 'dot',color:Colors.grey[900]),textScaleFactor: 2.0,):Container(),
              (moodLadder[i].start==-100)?Text('-100',style: TextStyle(backgroundColor:moodLadder[i].color,fontFamily: 'dot',color:Colors.grey[900]),textScaleFactor: 2.0):Container(),
              (moodLadder[i].start > 0) ?Text(moodLadder[i].detail,textAlign:TextAlign.center,textScaleFactor: 1.3,style: TextStyle(fontFamily: 'productSans',color:Colors.grey[700])):Container(),
              (moodLadder[i].start > 0 && i!=5) ?Icon(Icons.arrow_downward,color: Colors.black.withOpacity(0.2),size:30) : Container(),
              (moodLadder[i].start > 0 && i!=5) ?Text(moodLadder[i].start.toString(), style:TextStyle(backgroundColor:moodLadder[i].color,fontFamily: 'dot',color:Colors.grey[900]),textScaleFactor: 2.0) : Container(),


            ],
          ),
        ),
      );
    }),

              ),
            ));

  }



}


