import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class 
ProfileModel extends ChangeNotifier{

String? name;
String? area;


  Future fetchUser()async{

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = snapshot.data();
  this.name = data?['name'];
  this.area = data?['area']; 



  notifyListeners();
  //ChangeNotifierとセット
  }
Future logout() async {
  await FirebaseAuth.instance.signOut();
}


}








