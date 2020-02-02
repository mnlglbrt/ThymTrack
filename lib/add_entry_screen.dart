/*

import 'package:flutter/material.dart';





add(){

return Column(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: <Widget>[

Padding(
padding: const EdgeInsets.only(bottom:40.0),
child: Text(message,textScaleFactor:1.2,style: TextStyle(fontFamily: 'coco',color: Colors.grey[400]),textAlign: TextAlign.center,),
),
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
})},
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
if(todayMood.isEmpty){///Ajout de l'humeur entrée à data ; copie de data vers json

data.add(TimeSeriesMoods(DateTime.now(), moodFromSlide));
dataToFile(data);
selectedData=selectData(initialRange);
animateContainerGoGrey();}
else{
dialogEntryExist("Humeur déjà enregistrée", "Attendez demain ou modifiez l'humeur d'aujourd'hui.");}

})},
),
),
),
),
],
);}
*/
