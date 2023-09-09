import 'package:cloud_firestore/cloud_firestore.dart';

class SwipeMethod {
  static void likeUser(String likerId, String likedUserId) {
    print("likeUser function started");

    // LikerのコレクションにLikedUserIdを追加
    FirebaseFirestore.instance
        .collection('users')
        .doc(likerId)
        .collection('likes')
        .doc(likedUserId)
        .set({}).then((_) => print("Likeしたよ"));

    checkForMatch(likerId, likedUserId);
    print("likeUser function finished");
  }

  static void likedByUser(String likedUserId, String likerId) {
    // LikedUserのコレクションにLikerIdを追加
    FirebaseFirestore.instance
        .collection('users')
        .doc(likedUserId)
        .collection('likedBy')
        .doc(likerId)
        .set({});
  }

  static void dislikeUser(String dislikerId, String dislikedUserId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(dislikerId)
        .collection('dislikes')
        .doc(dislikedUserId)
        .set({});
  }

  static void dislikedByUser(String likedUserId, String likerId) {
    // LikedUserのコレクションにLikerIdを追加
    FirebaseFirestore.instance
        .collection('users')
        .doc(likedUserId)
        .collection('dislikedBy')
        .doc(likerId)
        .set({});
  }

  static void checkForMatch(String likerId, String likedUserId) async {
    final likesCollection = FirebaseFirestore.instance.collection('likes');

    final likerLikes = await likesCollection
        .where('likerId', isEqualTo: likerId)
        .where('likedUserId', isEqualTo: likedUserId)
        .get();

    final likedUserLikes = await likesCollection
        .where('likerId', isEqualTo: likedUserId)
        .where('likedUserId', isEqualTo: likerId)
        .get();

    if (likerLikes.docs.isNotEmpty && likedUserLikes.docs.isNotEmpty) {
      // マッチングが見つかったので、マッチングをFirebaseに記録する
      FirebaseFirestore.instance
          .collection('users')
          .doc(likerId)
          .collection('match')
          .add({
        'likerId': likerId,
        'likedUserId': likedUserId,
      });
    }
  }
}
