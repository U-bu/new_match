import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NameEditModel extends ChangeNotifier {
  NameEditModel(this.name);
  bool isLoading = false;
  String? name;
  final namecontroller = TextEditingController();

  Future nameget() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    name = data?['name'];
    namecontroller.text = name!;
    notifyListeners();
  }

  Future nameupdate(String name) async {
    this.name = name;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
    });
  }

  Future fetchName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    name = snapshot.data()?['name'] ?? '';
    namecontroller.text = name!;

    notifyListeners();
    //ChangeNotifierとセット
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

class SelfEditModel extends ChangeNotifier {
  bool isLoading = false;
  String? self;
  final selfcontroller = TextEditingController();

  SelfEditModel(this.self);

  void StartLoading() {
    isLoading = true;
    notifyListeners();
  }

  void EndLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future selfget() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    self = data?['self'];
    selfcontroller.text = self!;
    notifyListeners();
  }

  Future selfupdate(String self) async {
    this.self = self;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'self': self,
    });
  }

  Future fetchSelf() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    self = data?['self'];
    selfcontroller.text = self!;

    notifyListeners();
  }
}

class AreaEditModel extends ChangeNotifier {
  bool isLoading = false;
  String? area;

  AreaEditModel(this.area);

  void StartLoading() {
    isLoading = true;
    notifyListeners();
  }

  void EndLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future areaupdate(String area) async {
    this.area = area;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'area': area,
    });
  }

  Future fetchArea() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    area = data?['area'];

    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void setBlood(String bloodItem) {}
}

class BloodEditModel extends ChangeNotifier {
  bool isLoading = false;
  String? blood;

  BloodEditModel(this.blood);

  void StartLoading() {
    isLoading = true;
    notifyListeners();
  }

  void EndLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future bloodupdate(String blood) async {
    this.blood = blood;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'blood': blood,
    });
  }

  Future fetchBlood() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    blood = data?['blood'];

    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void setBlood(String bloodItem) {}
}

class HeightEditModel extends ChangeNotifier {
  bool isLoading = false;
  String? height;

  HeightEditModel(this.height);

  void StartLoading() {
    isLoading = true;
    notifyListeners();
  }

  void EndLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future heightupdate(String height) async {
    this.height = height;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'height': height,
    });
  }

  Future fetchHeight() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    height = data?['height'];

    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void setHeight(String heightItem) {}
}

class AgeEditModel extends ChangeNotifier {
  bool isLoading = false;
  String? age;

  AgeEditModel(this.age);

  void StartLoading() {
    isLoading = true;
    notifyListeners();
  }

  void EndLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future ageupdate(String height) async {
    age = age;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'age': age,
    });
  }

  Future fetchAge() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    age = data?['age'];

    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void setHeight(String heightItem) {}
}
