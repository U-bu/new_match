import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class UserProfileState {
  const UserProfileState({
    this.name,
    this.self,
    this.area,
    this.blood,
    this.height,
    this.age,
    this.profileImageUrls,
  });

  final String? name;
  final String? self;
  final String? area;
  final String? blood;
  final String? height;
  final String? age;
  final List<String>? profileImageUrls;

  factory UserProfileState.fromMap(Map<String, dynamic> data) {
    return UserProfileState(
      name: data['name'] ?? 'Unknown',
      self: data['self'] ?? 'Unknown',
      blood: data['blood'] ?? 'Unknown',
      area: data['area'] ?? 'Unknown',
      height: data['height'] ?? 'Unknown',
      age: data['age'] ?? 'Unknown',
      profileImageUrls: (data['profileImageUrls'] as List?)?.cast<String>(),
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  UserProfileNotifier() : super(const UserProfileState());

  Future<void> fetchUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      state = UserProfileState.fromMap(doc.data() as Map<String, dynamic>);
    }
  }
}

final userdataProvider = StreamProvider<UserProfileState>((ref) async* {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await for (final snapshot
      in FirebaseFirestore.instance.collection('users').doc(uid).snapshots()) {
    final data = snapshot.data();
    if (data != null) {
      yield UserProfileState.fromMap(data);
    } else {
      yield const UserProfileState();
    }
  }
});
