// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final authStateProvider =
//     StateNotifierProvider<AuthState, UserCredential?>((ref) => AuthState());

// class AuthState extends StateNotifier<UserCredential?> {
//   AuthState() : super(null);

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> signIn(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       state = userCredential; // Update the state
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.message);
//     }
//   }

//   Future<void> signUp(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);

//       // When a new user is created, also create a new document in the 'users' collection with the new user's ID.
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'name': null,
//         'area': null,
//         'blood': null,
//         'self': null,
//         'height': null
//       });
//       await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .collection('likes')
//           .doc()
//           .set({
//         'defalt': true,
//       });

//       state = userCredential; // Update the state
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.message);
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       state = null; // Update the state
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.message);
//     }
//   }
// }
