import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


final chatRoomStreamProvider = StreamProvider.family.autoDispose<List<types.Message>, String>((ref, chatRoomId) {
  final stream = FirebaseFirestore.instance.collection('chats').doc(chatRoomId).collection('messages').orderBy('createdAt', descending: true).snapshots().map((querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final user = data['author'] as Map<String, dynamic>;

      return types.TextMessage(
        author: types.User.fromJson(user),
        createdAt: data['createdAt'],
        id: data['messageId'] as String,
        text: data['text'] as String,
      );
    }).toList();
  });

  return stream;
});




