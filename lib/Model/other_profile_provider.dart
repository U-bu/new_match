import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ View/Message/matches_page/chat/chat_page.dart';

final likesProvider =
    StreamProvider.autoDispose.family<List<String>, String>((ref, uid) async* {
  uid = FirebaseAuth.instance.currentUser!.uid;
  await for (final snapshot in FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('likes')
      .snapshots()) {
    var likes = snapshot.docs.map((doc) => doc.id).toList();

    // Initialize an empty list to store the matched likes
    var matchedLikes = <String>[];

    // filter likes for only those users who also like the current user and 'isMessaging' is false
    for (var likedUserId in likes) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('likes')
          .doc(likedUserId)
          .get();
      final isMessaging = snapshot.data()?['isMessaging'] ?? false;

      final theyLikeMe = await FirebaseFirestore.instance
          .collection('users')
          .doc(likedUserId)
          .collection('likes')
          .doc(uid)
          .get();

      // Only add the likedUserId to the list if they also like the current user and isMessaging is false
      if (snapshot.exists && theyLikeMe.exists && !isMessaging) {
        matchedLikes.add(likedUserId);
      }
    }

    yield matchedLikes;
  }
});

final isMessagingProvider = FutureProvider.autoDispose<List<String>>(
  (ref) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;

    final usersQuery = await firestore
        .collection('users')
        .doc(uid)
        .collection('messages')
        .get();

    final messagingUsers = <String>[];

    for (var messageDoc in usersQuery.docs) {
      final opponentUserId = messageDoc.id; // ここは仮定です。正確なID取得方法はデータ構造によります。
      messagingUsers.add(opponentUserId);
    }

    return messagingUsers;
  },
);
final swipedUsersStreamProvider = StreamProvider<List<String>>((ref) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('likes')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => doc.id).toList();
  });
});
final likedUsersStreamProvider = StreamProvider<List<String>>((ref) {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('likedBy')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
});

final likedUserProvider = StreamProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, likedUserId) async* {
  await for (final snapshot in FirebaseFirestore.instance
      .collection('users')
      .doc(likedUserId)
      .snapshots()) {
    final data = snapshot.data();
    if (data != null) {
      yield data;
    } else {
      throw StateError('No user data found for user $likedUserId');
    }
  }
});

final chatRoomsProvider =
    FutureProvider.family<List<QueryDocumentSnapshot>, String>(
        (ref, uid) async {
  // FirestoreからユーザーIDを持つチャットルームを取得
  final chatRoomsSnapshot = await FirebaseFirestore.instance
      .collection('chatRooms')
      .where('users', arrayContains: uid)
      .get();

  return chatRoomsSnapshot.docs;
});
final chatRoomsProvider2 =
    FutureProvider.family<List<ChatRoom>, String>((ref, uid) async {
  final chatRoomsSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('chatRooms')
      .get();

  return chatRoomsSnapshot.docs.map((doc) {
    return ChatRoom.fromJson(doc.data());
  }).toList();
});
