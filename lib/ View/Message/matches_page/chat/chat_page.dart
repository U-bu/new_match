import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String roomId;
  final List<String> users;

  ChatRoom({required this.roomId, required this.users});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['roomId'],
      users: List<String>.from(json['users']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'users': users,
    };
  }
}

class Message {
  final String text;
  final String authorId;
  final int createdAt;

  Message(
      {required this.text, required this.authorId, required this.createdAt});
}

class ChatPage extends StatefulWidget {
  final ChatRoom chatRoom;
  final String? initialMessage;
  final String likedUserId;
  final String likedUserName;

  const ChatPage(
      {Key? key,
      required this.chatRoom,
      this.initialMessage,
      required this.likedUserId,
      required this.likedUserName})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    if (widget.initialMessage != null) {
      _sendMessage(widget.initialMessage!);
    }
  }

  void _loadMessages() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final messagesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('chatRooms')
        .doc(widget.chatRoom.roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();

    messagesRef.listen((snapshot) {
      _messages = snapshot.docs.map((doc) {
        return Message(
          text: doc['text'],
          authorId: doc['authorId'],
          createdAt: doc['createdAt'],
        );
      }).toList();

      setState(() {});
    });
  }

  Future<void> _sendMessage(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final roomRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chatRooms')
          .doc(widget.chatRoom.roomId);

      final roomDoc = await roomRef.get();

      if (!roomDoc.exists) {
        await roomRef.set(widget.chatRoom.toJson());
      }

      await roomRef.collection('messages').add({
        'text': text,
        'authorId': user.uid,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.likedUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isOwnMessage = message.authorId == uid;

                return Align(
                  alignment: isOwnMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isOwnMessage ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: isOwnMessage
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (!isOwnMessage)
                          Text(
                            message.authorId,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
