import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Medal {
  int nbRecords;
  String title;
  String content;
  String imgUrl;

  Medal(this.nbRecords, this.title, this.content, this.imgUrl);
}

class obtainedMedal {
  DateTime date;
  int nbRecords;

  obtainedMedal(this.date, this.nbRecords);
}


List<Medal> medalList=[
  Medal(1,'Premier enregistrement',"Bravo, vous venez de reéaliser votre premier enregistrement.\n Continuez et vous debloquerez bientôt d'autres médailles",'img.jp'),
  Medal(3,'Moyennes et extremes',"Félicitations ! Grâce à vos 3 enregistrementsvous avez\nmaintenant accès aux moyennes et aux valeurs extrêmes \n dans votre profil",'img.jp'),
  Medal(7,'7 jours !',"Avec ce septième enregistrement\nvous venez d'ouvrir deux nouveaux graphs sur l'acceuil.\n Allez y jeter un oeil !",'img.jp'),
  Medal(15,'15 jours !',"Wow ! Votre graph doit avoir de l'allure\navec tous ces enregistrements",'img.jp'),
  Medal(21,'21 jours !',"Les neurosciences affirment que lorsqu'on réalise une action pendant 21 jours, notre corps et notre esprit l'assimilent comme habitude. Cette action devient un automatisme. L'équipe de ThymTrack vous remercie d'avoir fait à notre travail une place dans votre quotidien",'img.jp'),
  Medal(30,'30 enregistrements !',"L'équivalent d'un mois.\nJour après jour...\nVous pouvez être fiers !",'img.jp'),
];

void checkMedals(){
  final data_instance = Firestore.instance;
  Map<String, dynamic> map;
  for (int i=0;i<medalList.length;i++) {
    if (dataMoods.length==medalList[i].nbRecords){
      //TODO : creer un collection Firebase pour enregistrer les médailles obtenues
      map={today.toString():dataMoods.length};
      data_instance.collection('users').document(uid).collection(
          "medals").document(today.toString()).setData(map);

    }
  }
}

List<obtainedMedal> dataMedals =[];


Future <List<Map<dynamic, dynamic>>> getCollection() async {
  List<DocumentSnapshot> templist;
  List<Map<dynamic, dynamic>> list = new List();
  CollectionReference collectionRef = Firestore.instance.collection("users")
      .document(uid)
      .collection('medals');
  QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

  templist = collectionSnapshot.documents; // <--- ERROR

  list = templist.map((DocumentSnapshot docSnapshot) {
    return docSnapshot.data;
  }).toList();

  return list;
}


