import 'package:bipo/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'data.dart';
import 'package:clay_containers/clay_containers.dart';
import 'mood_ranges.dart';
import 'medals.dart';

class MedalsPage extends StatefulWidget {
  @override
  _MedalsPageState createState() => _MedalsPageState();
}

class _MedalsPageState extends State<MedalsPage> {
@override
  void initState() {
    super.initState();
    checkMedals();
    getMedals();
    print(dataMedals);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          centerTitle: true,
          backgroundColor: Colors.teal,

          title: new Text(
            "MEDAILLES", textAlign: TextAlign.center,
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
        ),

        body: Center(
          child: Container(
            color: Colors.grey[100],
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,


            child: new GridView.builder(
                itemCount: dataMedals.length,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(
                    onTap: (){_showMedal(3);},
                    child: Container(
                        decoration: BoxDecoration(image: DecorationImage(image:AssetImage('images/medal.png'),colorFilter: ColorFilter.mode(Colors.teal, BlendMode.dst))),
                        width: 40,
                        height: 40,
                        child:Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Positioned(
                              child:ClayText("${medalList.where((med)=>med.nbRecords==dataMedals[i].nbRecords).toList()[0].nbRecords}",parentColor: Colors.yellow[200],size: 60,),
                            ),

                            Positioned(
                              bottom:5,
                              child: Text("${dayFormatter.format(dataMedals[i].date)}"),
                            ),

                          ],
                        )
                    ),
                  );
                })

                      //Text("${dataMedals[0].nbRecords}"),



            ),


          ),
        );

  }

void _showMedal(nbRecords){
  showDialog(context: context,
  builder: (BuildContext context){
    return AlertDialog(
      content:Container(height:200,width: 200,color: Colors.blue,),
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


}



//trailing:Container(width:100,child: Text("${medalList.where((med)=>med.nbRecords==dataMedals[i].nbRecords).toList()[0].content}")),
