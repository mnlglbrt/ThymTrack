import 'package:flutter/material.dart';

class MyColor{
  Color color;
  int shade;

  MyColor(this.color,this.shade);
}

 rangeColor(int mood){
  return(mood<-49)?MyColor(Colors.red,200):
            (mood<-9)?MyColor(Colors.yellow,600):
              (mood<50)?MyColor(Colors.teal,400):
                (mood<70)?MyColor(Colors.yellow,600):
                  (mood<=100)?MyColor(Colors.red,200):MyColor(Colors.grey,900);
}