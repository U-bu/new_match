import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class MyPageModel extends ChangeNotifier{

bool isLoading = false;
String? name;
String? self;
String? area;
String? pickertext1;
String? pickertext2;



  


void StartLoading(){
isLoading = true;

notifyListeners();
}

  void EndLoading(){
    isLoading = false;
    notifyListeners();
  }

  Future fetchUser()async{
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = snapshot.data();
  this.name = data?['name'];
  this.self = data?['self'];
  this.area = data?['area']; 
  this.pickertext1 = data?['blood'];
  this.pickertext2 = data?['height'];


  notifyListeners();
  //ChangeNotifierとセット
  }

Future logout() async {
  await FirebaseAuth.instance.signOut();
}

}







