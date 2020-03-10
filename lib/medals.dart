import 'package:cloud_firestore/cloud_firestore.dart';
import 'data.dart';
import 'sign_in.dart';

class Medal {
  int nbRecords;
  String title;
  String content;
  String imgUrl;
  String link;
  String linkText;

  Medal(this.nbRecords, this.title, this.content, this.imgUrl,this.link, this.linkText);
}

class ObtainedMedal {
  DateTime date;
  int nbRecords;

  ObtainedMedal(this.date, this.nbRecords);
}


List<Medal> medalList=[
  //v1.0
  Medal(1,'Première\nentrée',"Bravo, vous venez de réaliser votre premier enregistrement. Continuez et vous débloquerez bientôt d'autres trophées.",'img.jp',"",""),
  Medal(3,'Moyennes\net\nextremes',"Félicitations ! Grâce à vos 3 enregistrements vous avez maintenant accès aux moyennes et aux valeurs extrêmes dans la page profil.",'img.jp',"",""),
  Medal(7,'Voir plus loin',"Avec ce septième enregistrement vous venez de débloquer deux nouveaux graphs sur l'acceuil. Allez y jeter un oeil !",'img.jp',"",""),
  Medal(10,'Le sommeil',"Lorsqu'on cherche à améliorer son humeur moyenne, le sommeil est primordial. Dormez-vous suffisament ? L'application Calm peut vous aider à trouver le sommeil plus rapidement. Essayez-la !",'img.jp',"https://play.google.com/store/apps/details?id=com.calm.android&hl=fr","Télécharger Calm"),
  Medal(15,'15 jours !',"Wow ! Votre graph doit avoir de l'allure avec tous ces enregistrements!",'img.jp',"",""),
  Medal(21,'Une habitude',"Les neurosciences affirment que lorsqu'on réalise une action pendant 21 jours, notre corps et notre esprit l'assimilent comme habitude. Cette action devient un automatisme. L'équipe de ThymTrack vous remercie d'avoir fait à notre travail une place dans votre quotidien.",'img.jp',"",""),
  Medal(24,'Méditation',"Avez vous déja essayé la relaxation ou la méditation ? Tout commence avec le contrôle de la respiration. Prenez le temps d'inspirer et d'expirer profondément tout en vous efforçant de ne penser à rien. Faire le vide et chasser pour une dizaine de minutes les pensées parasites qui affluent dans votre conscience. Juste ressentir votre propre présence au moment et à l'endroit oú vous êtes.",'img.jp',"https://play.google.com/store/apps/details?id=com.petitbambou&hl=fr","Méditer avec Petit BamBou"),
  Medal(30,'30 enregistrements !',"L'équivalent d'un mois. Jour après jour... Vous pouvez être fiers !",'img.jp',"",""),
  Medal(32,"Faire de l'exercice","Bouger est bon pour la santé physique et mentale. Pratiquer une activité physique serait particulièrement efficace pour redonner de l'énergie et améliorer l'humeur des personnes bipolaires. C'est ce que suggèrent les travaux d'une équipe de chercheurs de l'école de santé publique John Hopkins Bloomberg aux Etats-Unis, parus dans la revue JAMA Psychiatry.",'img.jp',"https://play.google.com/store/search?q=exercice&c=apps&hl=fr","GO !"),
//v1.1
  Medal(36,"L'entourage","Lorsqu'on est victime de troubles thymiques, il est parfois difficile de communiquer avec notre entourage. Certaines remarques concernant le trouble peuvent rapidement faire dégénérer la conversation. Voici quelques conseils à fournir à vos proches afin de progresser ensemble vers un plus grand confort emotionnel.",'img.jp',"https://www.lebipolaire.com/10-choses-pas-dire-bipolaire/?fbclid=IwAR0w0O1DoSI0aQTJGbu35pdAdnq_C4OVnaDgHngc0sl63S9KflJ-3Tgl2i4","Lire l'article"),
  Medal(40,"Descendre du train","Prendre le train de l’hypomanie peut être si agréable que vous ne voulez pas en sortir, mais il est impératif que vous le fassiez afin de gérer efficacement votre bipolarité.\nVoici 7 conseils pour descendre du train.",'img.jp',"https://www.lebipolaire.com/7-facons-darreter-le-train-de-lhypomanie/?fbclid=IwAR2DqTqBF-DNv2euWneN_98NEG41QS4PWIOrWNJy8v6GvDTL8ivLwVsfRHo","Lire l'article"),
  Medal(45,"Anti-stress","Le quotidien peut parfois se montrer stressant. Si le besoin se fait sentir, prenez une pause et lisez ces 5 conseils pour ralentir et trouver l'équilibre.",'img.jp',"https://www.lebipolaire.com/stresse-5-facons-de-ralentir-et-de-trouver-lequilibre/?fbclid=IwAR20c-fKR2P6hYJyswMfBd0b_mRZhwieztsG7KbMTbWyqmiG3HHke-egkFo","Lire l'article"),
  Medal(50,"Prévenir","La dépression se caractérise par une perte de motivation, un manque d'énergie et un repli social. Si l'épisode est détécté à temps, il peut disparaitre plus rapidement. C'est pourquoi il est important de connaitre les signes de la phase dépressive. Voici un article qui vous permettra de prévenir la dépression avant qu'elle ne s'installe.",'img.jp',"https://www.lebipolaire.com/7-signes-phase-depressive/?fbclid=IwAR27Jg7Rdm5ygEMf81ElLFpQiysuckiD_pOfwJqrmmD-G4d4rCDPlwrZFnY","Lire l'article"),
  Medal(55,"MOINS FORT !","L'hypersensibilité au bruit est un symptôme commun à de nombreux patients atteints de troubles thymiques. Voici quelques conseils pour mieux vivre votre hypersensibilité au bruit.",'img.jp',"https://www.lebipolaire.com/3-astuces-contre-lhypersensibilite-au-bruit/?fbclid=IwAR3hsHvdBLcdtLMoEACukXRNPmBURo7dEF8uplaZbA8oYTY0l7fLVZBvaAg","GO !"),


];

void checkMedals(){
  updateToday();
  final dataInstance = Firestore.instance;
  Map<String, dynamic> map;
  for (int i=0;i<medalList.length;i++) {
    if (dataMoods.length==medalList[i].nbRecords && dataMedals.where((med)=>med.nbRecords==dataMoods.length).toList().isEmpty){
      map={today.toString():dataMoods.length};
      dataInstance.collection('users').document(uid).collection(
          "medals").document(today.toString()).setData(map);
    }
  }
}

List<ObtainedMedal> dataMedals =[];


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


