import 'package:flutter/material.dart';

class MyColor{
  Color color;
  int shade;

  MyColor(this.color,this.shade);
}

 rangeColor(int mood){
  return(mood<-49)?MyColor(Colors.red,700):
            (mood<-9)?MyColor(Colors.yellow,700):
              (mood<50)?MyColor(Colors.teal,700):
                (mood<70)?MyColor(Colors.yellow,700):
                  (mood<=100)?MyColor(Colors.red,700):MyColor(Colors.grey,900);
}