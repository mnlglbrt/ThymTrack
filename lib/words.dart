
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in.dart';
class Word{
  String word;
  String group;

  Word(this.word, this.group);

}


Map<dynamic,dynamic> datedFeelings={

};


List<Word>allWords=[
  //JOIE
  new Word("Joie", "Joie"),
  new Word("inspiré", "Joie"),
  new Word("joyeux", "Joie"),
  new Word("libre", "Joie"),
  new Word("rassuré", "Joie"),
  new Word("optimiste", "Joie"),
  new Word("paisible", "Joie"),
  new Word("hilare", "Joie"),
  new Word("insouciant", "Joie"),
  new Word("fou de joie", "Joie"),
  new Word("gai", "Joie"),
  new Word("amusé", "Joie"),
  new Word("comblé", "Joie"),
  new Word("vivifié", "Joie"),
  new Word("euphorique", "Joie"),

  //ESTIME DE SOI +
  new Word("Estime de soi", "Estime de soi"),
  new Word("fier", "Estime de soi"),
  new Word("content de soi", "Estime de soi"),
  new Word("pétillant", "Estime de soi"),
  new Word("gonflé à bloc", "Estime de soi"),
  new Word("galvanisé", "Estime de soi"),
  new Word("expansif", "Estime de soi"),
  new Word("exubérant", "Estime de soi"),

  //ACTIF
  new Word("Actif", "Actif"),
  new Word("impatient", "Actif"),
  new Word("enjoué", "Actif"),
  new Word("épanoui", "Actif"),
  new Word("étonné", "Actif"),
  new Word("excité", "Actif"),
  new Word("surexcité", "Actif"),
  new Word("aventureux", "Actif"),
  new Word("fasciné", "Actif"),
  new Word("en effervescence", "Actif"),
  new Word("instable", "Actif"),

  //PLEINITUDE
  new Word("Pleinitude", "Pleinitude"),
  new Word("à l’aise", "Pleinitude"),
  new Word("Heureux", "Pleinitude"),
  new Word("ravi", "Pleinitude"),
  new Word("réconforté", "Pleinitude"),
  new Word("reconnaissant", "Pleinitude"),
  new Word("tranquille", "Pleinitude"),
  new Word("sécurisé", "Pleinitude"),
  new Word("en paix", "Pleinitude"),
  new Word("serein", "Pleinitude"),
  new Word("centré", "Pleinitude"),
  new Word("calme", "Pleinitude"),
  new Word("détendu", "Pleinitude"),


  //MAUVAISE ESTIME DE SOI
  new Word("Mauvaise estime de soi", "Mauvaise estime de soi"),
  new Word("honteux", "Mauvaise estime de soi"),
  new Word("insulté", "Mauvaise estime de soi"),
  new Word("diminué", "Mauvaise estime de soi"),
  new Word("dominé", "Mauvaise estime de soi"),
  new Word("envahi", "Mauvaise estime de soi"),
  new Word("étouffé", "Mauvaise estime de soi"),
  new Word("harcelé", "Mauvaise estime de soi"),
  new Word("humilié", "Mauvaise estime de soi"),
  new Word("incompétent", "Mauvaise estime de soi"),
  new Word("abusé", "Mauvaise estime de soi"),
  new Word("jugé", "Mauvaise estime de soi"),
  new Word("laissé pour compte", "Mauvaise estime de soi"),
  new Word("manipulé", "Mauvaise estime de soi"),
  new Word("minable", "Mauvaise estime de soi"),
  new Word("méprisé", "Mauvaise estime de soi"),
  new Word("nul", "Mauvaise estime de soi"),
  new Word("rabaissé", "Mauvaise estime de soi"),
  new Word("sans valeur", "Mauvaise estime de soi"),
  new Word("bête", "Mauvaise estime de soi"),
  new Word("coupable", "Mauvaise estime de soi"),
  new Word("dévalorisé", "Mauvaise estime de soi"),
  new Word("accusé", "Mauvaise estime de soi"),
  new Word("attaqué", "Mauvaise estime de soi"),
  new Word("sali", "Mauvaise estime de soi"),

  //SOLITUDE
  new Word("Solitude", "Solitude"),
  new Word("isolé", "Solitude"),
  new Word("invisible", "Solitude"),
  new Word("délaissé", "Solitude"),
  new Word("rejeté", "Solitude"),
  new Word("abandonné", "Solitude"),
  new Word("incompris", "Solitude"),
  new Word("négligé", "Solitude"),
  new Word("pas accepté", "Solitude"),
  new Word("pas aimé", "Solitude"),
  new Word("pas entendu", "Solitude"),
  new Word("ignoré", "Solitude"),
  new Word("seul", "Solitude"),
  new Word("renfermé", "Solitude"),
  new Word("réticent", "Solitude"),
  new Word("sceptique", "Solitude"),

  // STRESS
  new Word("Stress", "Stress"),
  new Word("stressé", "Stress"),
  new Word("dépassé", "Stress"),
  new Word("fragile", "Stress"),
  new Word("impuissant", "Stress"),
  new Word("contrarié", "Stress"),
  new Word("bloqué", "Stress"),
  new Word("sous pression", "Stress"),
  new Word("saturé", "Stress"),
  new Word("effrayé", "Stress"),
  new Word("embarrassé", "Stress"),
  new Word("vulnérable", "Stress"),
  new Word("désespéré", "Stress"),

  //DÉPRESSION
  new Word("Dépression", "Dépression"),
  new Word("déprimé", "Dépression"),
  new Word("triste", "Dépression"),
  new Word("ennuyé", "Dépression"),
  new Word("désarmé", "Dépression"),
  new Word("désolé", "Dépression"),
  new Word("abattu", "Dépression"),
  new Word("accablé", "Dépression"),
  new Word("déconcerté", "Dépression"),
  new Word("déçu", "Dépression"),
  new Word("démoralisé", "Dépression"),
  new Word("malheureux", "Dépression"),
  new Word("insatisfait", "Dépression"),
  new Word("indifférent", "Dépression"),
  new Word("morose", "Dépression"),
  new Word("las", "Dépression"),
  new Word("léthargique", "Dépression"),
  new Word("mélancolique", "Dépression"),


];




Future <Map<dynamic, dynamic>> getFeelingsCollection() async {
  Map<dynamic, dynamic> myMap={};

  CollectionReference collectionRef = Firestore.instance.collection("users").document(uid).collection('feels');
  QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();


collectionSnapshot.documents.forEach((element) {
  List<Word> wordsList=[];
  element.data.forEach((key, value) {wordsList.add(Word(key,value));});
  print(element.documentID);
  print ('DATE :'+DateTime.parse(element.documentID.toString().substring(0,10)).toString());
  //print ('WORDS :'+wordsList.toString());
  myMap.putIfAbsent(DateTime.parse(element.documentID.toString().substring(0,10)), () => wordsList);
});
  print(myMap);
  return myMap;
}