// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class ChatRoom {
//   final String roomId;
//   final List<String> users;

//   ChatRoom({required this.roomId, required this.users});

//   factory ChatRoom.fromJson(Map<String, dynamic> json) {
//     return ChatRoom(
//       roomId: json['roomId'],
//       users: List<String>.from(json['users']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'roomId': roomId,
//       'users': users,
//     };
//   }
// }

// class Message {
//   final String id;
//   final String chatId;
//   final String senderId;
//   final String text;
//   final Timestamp timestamp;

//   Message({
//     required this.id,
//     required this.chatId,
//     required this.senderId,
//     required this.text,
//     required this.timestamp,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['id'] ?? '',
//       chatId: json['chatId'] ?? '',
//       senderId: json['senderId'] ?? '',
//       text: json['text'] ?? '',
//       timestamp:
//           json['timestamp'] is Timestamp ? json['timestamp'] : Timestamp.now(),
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'chatId': chatId,
//       'senderId': senderId,
//       'text': text,
//       'timestamp': timestamp,
//     };
//   }
// }


// Future<ChatRoom?> getChatRoom(String otherUserId) async {
//   final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   // チャットルームIDを作成します
//   final chatId = [otherUserId, currentUserId]..sort();
//   final chatIdString = chatId.join('-');

//   final chatDocRef =
//       FirebaseFirestore.instance.collection('rooms').doc(chatIdString);
//   final docSnapshot = await chatDocRef.get();

//   // チャットルームが既に存在しない場合は新しいチャットルームを作成します
//   if (!docSnapshot.exists) {
//     await chatDocRef.set(ChatRoom(roomId: chatIdString, users: [currentUserId, otherUserId]).toJson());
//     return ChatRoom(roomId: chatIdString, users: [currentUserId, otherUserId]);
//   } else {
//     return ChatRoom.fromJson(docSnapshot.data()!);
//   }
// }


// Future<void> sendMessage(String chatId, String senderId, String text) async {
//   final messageRef = FirebaseFirestore.instance
//       .collection('chats')
//       .doc(chatId)
//       .collection('messages')
//       .doc();

//   final message = Message(
//     id: messageRef.id,
//     chatId: chatId,
//     senderId: senderId,
//     text: text,
//     timestamp: Timestamp.now(),
//   );

//   await messageRef.set(message.toJson());
// }


// // class ChatPage2 extends StatelessWidget {
// //   final Chat chat;

// //   const ChatPage2({Key? key, required this.chat}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final TextEditingController messageController = TextEditingController();

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Chat with ${chat.userIds.join(', ')}'),
// //       ),
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
// //                 stream: FirebaseFirestore.instance
// //                     .collection('chats')
// //                     .doc(chat.id)
// //                     .collection('messages')
// //                     .orderBy('timestamp', descending: true)
// //                     .snapshots(),
// //                 builder: (context, snapshot) {
// //                   if (!snapshot.hasData) {
// //                     return const Center(child: CircularProgressIndicator());
// //                   }

// //                   final messages = snapshot.data!.docs
// //                       .map((doc) => Message.fromJson(doc.data()))
// //                       .toList();

// //                   return ListView.builder(
// //                     itemCount: messages.length,
// //                     reverse: true,
// //                     itemBuilder: (context, index) {
// //                       final message = messages[index];
// //                       final isMe = message.senderId ==
// //                           FirebaseAuth.instance.currentUser!.uid;

// //                       return Container(
// //                         alignment:
// //                             isMe ? Alignment.centerRight : Alignment.centerLeft,
// //                         margin: const EdgeInsets.symmetric(
// //                             vertical: 10, horizontal: 20),
// //                         child: Text(message.text),
// //                       );
// //                     },
// //                   );
// //                 },
// //               ),
// //             ),
// //             Container(
// //               margin: const EdgeInsets.symmetric(horizontal: 8),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       controller: messageController,
// //                       decoration: const InputDecoration(
// //                           hintText: 'Type your message here...'),
// //                     ),
// //                   ),
// //                   IconButton(
// //                     icon: const Icon(Icons.send),
// //                     onPressed: () async {
// //                       final text = messageController.text;
// //                       final senderId = FirebaseAuth.instance.currentUser!.uid;
// //                       if (text.isNotEmpty) {
// //                         await sendMessage(chat.id, senderId, text);
// //                         messageController.clear();
// //                       }
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
