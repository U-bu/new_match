// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// /// チャットルーム画面。
// class ChatRoomPage extends StatefulWidget {
//   ChatRoomPage({Key? key, required this.likedUserId}) : super(key: key);

//   final String likedUserId;

//   @override
//   _ChatRoomPageState createState() => _ChatRoomPageState();
// }

// class _ChatRoomPageState extends State<ChatRoomPage> {
//   final _messageController = TextEditingController();
//   late final String _currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       _currentUserId = user.uid;
//     }
//   }

//   void _sendMessage() async {
//     String text = _messageController.text;
//     if (text.trim().isNotEmpty) {
//       _messageController.clear();
//       DocumentReference messagesRef = FirebaseFirestore.instance
//           .collection('chats')
//           .doc(widget.likedUserId)
//           .collection('messages')
//           .doc();

//       FirebaseFirestore.instance.runTransaction((transaction) async {
//         transaction.set(messagesRef, {
//           'senderId': _currentUserId,
//           'text': text,
//           'timestamp': DateTime.now(),
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chat Room"),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('chats')
//                     .doc(widget.likedUserId)
//                     .collection('messages')
//                     .orderBy('timestamp', descending: true)
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   final messages = snapshot.data!.docs;
//                   List<Widget> messageWidgets = [];
//                   for (var message in messages) {
//                     final messageText = message.data() ?? 'text';
//                     final messageSender = message.data() ?? 'senderId';
//                     final messageWidget = MessageWidget(
//                       messageId: message.id,
//                       message: messageText as String,
//                       isOwnMessage: messageSender == _currentUserId,
//                     );
//                     messageWidgets.add(messageWidget);
//                   }
//                   return ListView(
//                     reverse: true,
//                     children: messageWidgets,
//                   );
//                 }),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: "Enter your message...",
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void createChatRoom(String userId1, String userId2) async {
//   String chatRoomId = userId1 + "-" + userId2;

//   var chatRoom = {
//     'users': [userId1, userId2],
//     'chatRoomId': chatRoomId,
//   };

//   await FirebaseFirestore.instance
//       .collection('chatRooms')
//       .doc(chatRoomId)
//       .set(chatRoom);
// }

// void sendMessage(String chatRoomId, String messageId, String messageContent,
//     String userId) async {
//   var message = {
//     'messageId': messageId,
//     'content': messageContent,
//     'sentBy': userId,
//     'timestamp': FieldValue.serverTimestamp(),
//   };

//   await FirebaseFirestore.instance
//       .collection('chatRooms')
//       .doc(chatRoomId)
//       .collection('messages')
//       .doc(messageId)
//       .set(message);
// }

// Stream<QuerySnapshot> getChatRoomMessages(String chatRoomId) {
//   return FirebaseFirestore.instance
//       .collection('chatRooms')
//       .doc(chatRoomId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true)
//       .snapshots();
// }

// class MessageWidget extends StatelessWidget {
//   final String messageId;
//   final String message;
//   final bool isOwnMessage;

//   MessageWidget({
//     required this.messageId,
//     required this.message,
//     required this.isOwnMessage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment:
//           isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(10.0),
//           margin: EdgeInsets.all(10.0),
//           decoration: BoxDecoration(
//             color: isOwnMessage ? Colors.blue : Colors.green,
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Text(
//             message,
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
