import 'package:bipo/login_page.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'data.dart';
import 'dashBoard.dart';
import 'package:clay_containers/clay_containers.dart';
import 'mood_ranges.dart';
import 'dashBoard.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>stats=getStats(dataMoods);
    return Scaffold(
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
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Container(
            color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0,),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Container(width: MediaQuery.of(context).size.width,),
                    Image.asset('images/logo.png',height: 200,),
                    Positioned(height:60,width: 60,
                      left:30,
                      top:20,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          imageUrl,
                        ),
                        radius: 60,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Positioned(
                        top:30,
                        child: Text(name,style: TextStyle(color: Colors.grey[500]))),

        (dataMoods.length>0)?Positioned(
                        //width: MediaQuery.of(context).size.width,
                        top:150,
                        child: Text('Premier enregistrement le ${dayFormatter.format(dataMoods[0].time)}',
                            style: TextStyle(color: Colors.grey[500]))):Container(),
                    ClayContainer(
                      width:100,
                      height:40,
                      //curveType: CurveType.concave,
                      borderRadius: 30,
                      parentColor: Colors.grey[100],
                      color:Colors.grey[100],
                      depth: 7,
                      spread: 10,
                      surfaceColor: Colors.white,
                      child: InkWell(
                          onTap: (){
                            signOutGoogle();
                            dataMoods.clear();
                            sevenDaysData.clear();
                            thirtyDaysData.clear();
                            selectedData.clear();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                                  return LoginPage();
                                }), ModalRoute.withName('/'));
                          },
                          child:Center(child: Text('Deconnexion',style: TextStyle(color:Colors.teal),))
                      ),
                    )

                  ],
                ),
              ),


        (dataMoods.length<3)?Column(
          children: <Widget>[
            Text("Vous trouverez ici vos moyennes \net vos données extrêmes lorsque \nnous aurons plus d'enregistrements.", textAlign: TextAlign.center,)]):Container(),


              (dataMoods.length>=3)?Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ClayContainer(
                        width: MediaQuery.of(context).size.width/1.2,
                        color:Colors.grey[100],
                        borderRadius: 30,
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Center(child: Text('Rigueur',textScaleFactor: 1.5,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[400]))),
                                Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(children:<Widget>[
                                            Text('Jours manqués :',style: TextStyle(color: Colors.grey[400]),),
                                            Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Opacity(opacity:1.0,child: new Text(stats['missedRecords'].toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(averageMood(sevenDaysData).toInt()).color[rangeColor(averageMood(sevenDaysData).toInt()).shade], ))),
                                            )),
                                          ]),

                                          Row(children:<Widget>[
                                            Text('Enregistrements :',style: TextStyle(color: Colors.grey[400])),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Opacity(opacity:1.0,child: new Text(stats['accuracy'].toString()+' %',textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(extremMoods(sevenDaysData)[1].toInt()).color[rangeColor(extremMoods(sevenDaysData)[1].toInt()).shade], ))),
                                                     ]),
                                              ),
                                            )
                                          ]),

                                        ],
                                      ),
                                    ),
                                  ),)

                              ],
                            )),
                      ),

                    ],
                  ),


                ],
              ):Container(),



              (dataMoods.length>=3)?Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ClayContainer(
                        width: MediaQuery.of(context).size.width/1.2,
                        color:Colors.grey[100],
                        borderRadius: 30,
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Center(child: Text('Depuis une semaine',textScaleFactor: 1.5,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[400]))),
                                Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(children:<Widget>[
                                            Text('Moyenne :',style: TextStyle(color: Colors.grey[400]),),
                                            Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Opacity(opacity:1.0,child: new Text(averageMood(sevenDaysData).toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(averageMood(sevenDaysData).toInt()).color[rangeColor(averageMood(sevenDaysData).toInt()).shade], ))),
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.only(left:8.0),
                                              child: Text('Jours en stabilité :',style: TextStyle(color: Colors.grey[400]),),
                                            ),
                                            Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Opacity(opacity:1.0,child: new Text(stabDays(sevenDaysData).toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:(stabDays(sevenDaysData)<=3)?Colors.red:(stabDays(thirtyDaysData)<=5)?Colors.yellow[600]:Colors.teal))),
                                            )),
                                          ]),
                                          Row(children:<Widget>[
                                            Text('Extrêmes :',style: TextStyle(color: Colors.grey[400])),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                Icon(Icons.arrow_downward,color: Colors.grey[300],),
                                                Opacity(opacity:1.0,child: new Text(extremMoods(sevenDaysData)[0].toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(extremMoods(sevenDaysData)[0].toInt()).color[rangeColor(extremMoods(sevenDaysData)[0].toInt()).shade], ))),
                                                ],
                                              ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Opacity(opacity:1.0,child: new Text(extremMoods(sevenDaysData)[1].toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(extremMoods(sevenDaysData)[1].toInt()).color[rangeColor(extremMoods(sevenDaysData)[1].toInt()).shade], ))),
                                              Icon(Icons.arrow_upward, color: Colors.grey[300]),]),
                                              ),
                                            )
                                          ]),

                                        ],
                                      ),
                                    ),
                                  ),)

                              ],
                            )),
                      ),

                    ],
                  ),


                ],
              ):Container(),



              (dataMoods.length>=12)?Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ClayContainer(
                        width: MediaQuery.of(context).size.width/1.2,
                        color:Colors.grey[100],
                        borderRadius: 30,
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Center(child: Text('Depuis un mois',textScaleFactor: 1.5,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[400]))),
                                Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(children:<Widget>[
                                            Text('Moyenne :',style: TextStyle(color: Colors.grey[400]),),
                                            Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Opacity(opacity:1.0,child: new Text(averageMood(thirtyDaysData).toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(averageMood(thirtyDaysData).toInt()).color[rangeColor(averageMood(thirtyDaysData).toInt()).shade], ))),
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.only(left:8.0),
                                              child: Text('Jours en stabilité :',style: TextStyle(color: Colors.grey[400]),),
                                            ),
                                            Center(child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Opacity(opacity:1.0,child: new Text(stabDays(thirtyDaysData).toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:(stabDays(thirtyDaysData)<=10)?Colors.red:(stabDays(thirtyDaysData)<=17)?Colors.yellow[600]:Colors.teal))),
                                            )),
                                          ]),
                                          Row(children:<Widget>[
                                            Text('Extrêmes :',style: TextStyle(color: Colors.grey[400])),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.arrow_downward,color: Colors.grey[300],),
                                                    Opacity(opacity:1.0,child: new Text(extremMoods(thirtyDaysData)[0].toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(extremMoods(thirtyDaysData)[0].toInt()).color[rangeColor(extremMoods(thirtyDaysData)[0].toInt()).shade], ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Opacity(opacity:1.0,child: new Text(extremMoods(thirtyDaysData)[1].toInt().toString(),textScaleFactor: 1.6,style: TextStyle(fontFamily: 'dot',color:rangeColor(extremMoods(thirtyDaysData)[1].toInt()).color[rangeColor(extremMoods(thirtyDaysData)[1].toInt()).shade], ))),
                                                      Icon(Icons.arrow_upward, color: Colors.grey[300]),]),
                                              ),
                                            )
                                          ]),

                                        ],
                                      ),
                                    ),
                                  ),)

                              ],
                            )),
                      ),

                    ],
                  ),


                ],
              ):Container(),






            ],
          ),
        ),
      ),
    );
  }



}
