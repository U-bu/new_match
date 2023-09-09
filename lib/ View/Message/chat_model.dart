// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'chat_room.dart';


// //いいねをした時の関数
// void sendLike(String userId, String likedUserId) async {
//   var like = {
//     'userId': userId,
//     'likedUserId': likedUserId,
//     'timestamp': FieldValue.serverTimestamp(),
//   };

//   await FirebaseFirestore.instance
//     .collection('likes')
//     .add(like);
// }

// //お互いにいいねを送ったかどうかを確認する関数
// Future<bool> isMatch(String userId, String likedUserId) async {
//   var likes = await FirebaseFirestore.instance
//     .collection('likes')
//     .where('userId', isEqualTo: userId)
//     .where('likedUserId', isEqualTo: likedUserId)
//     .get();

//   var likesReverse = await FirebaseFirestore.instance
//     .collection('likes')
//     .where('userId', isEqualTo: likedUserId)
//     .where('likedUserId', isEqualTo: userId)
//     .get();

//   return likes.docs.isNotEmpty && likesReverse.docs.isNotEmpty;
// }

// //マッチングした場合にチャットルームを作成する関数
// void handleLike(String userId, String likedUserId) async {
//   sendLike(userId, likedUserId);
  
//   if (await isMatch(userId, likedUserId)) {
//     createChatRoom(userId, likedUserId);
//   }
// }

