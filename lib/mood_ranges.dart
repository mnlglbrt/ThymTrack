import 'package:flutter/material.dart';

class myColor{
  Color color;
  int shade;

  myColor(this.color,this.shade);
}

 rangeColor(int mood){
  return(mood<-49)?myColor(Colors.red,700):
            (mood<-9)?myColor(Colors.amber,600):
              (mood<50)?myColor(Colors.teal,400):
                (mood<70)?myColor(Colors.amber,600):
                  (mood<=100)?myColor(Colors.red,700):myColor(Colors.grey,900);
}