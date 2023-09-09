import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Model/other_profile_provider.dart';
import '../../Message/matches_page/chat/chat_page.dart';

class OtherProfileCard extends ConsumerWidget {
  const OtherProfileCard({
    Key? key,
    required this.uid,
    required this.index,
    required this.likedUserId,
  }) : super(key: key);
  final String uid;
  final int index;
  final String likedUserId;

  String getChatRoomId(String a, String b) {
    if (a.hashCode <= b.hashCode) {
      return a + b;
    } else {
      return b + a;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController messageController = TextEditingController();

    final likes = ref.watch(likesProvider(uid));

    return likes.when(
      data: (likes) {
        if (likes.length > index) {
          final likedUser = ref.watch(likedUserProvider(likes[index]));

          return Scaffold(
            appBar: AppBar(
              title: Text(likedUser.when(
                data: (likedUser) => likedUser['name'] ?? 'No Name',
                loading: () => 'Loading...',
                error: (_, __) => 'Error',
              )),
            ),
            body: likedUser.when(
              data: (likedUser) => Scaffold(
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                              color: Colors.grey,
                              height: 1300,
                              child: Stack(children: [
                                Container(
                                  height: 540,
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      const Color.fromARGB(255, 205, 233, 255),
                                  child: CachedNetworkImage(
                                    imageUrl: likedUser['profileImageUrls']
                                            [0] ??
                                        'デフォルトの画像URL',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                                Positioned(
                                  top: 530,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0),
                                          topLeft: Radius.circular(15.0)),
                                    ),
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            likedUser['name'] ?? 'No Name',
                                            style:
                                                const TextStyle(fontSize: 23),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            likedUser['self'] ?? 'No Self',
                                            style:
                                                const TextStyle(fontSize: 23),
                                          ),
                                        ),
                                        Text(
                                          likedUser['area'] ?? 'No Area',
                                          style: const TextStyle(fontSize: 23),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]))
                        ],
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.95),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: 'メッセージを入力',
                            suffixIcon: IconButton(
                              onPressed: () {
                                print('uid: $uid');
                                print('likedUser: $likedUserId');
                                String message = messageController.text;
                                String chatRoomId =
                                    getChatRoomId(uid, likedUserId);

                                // チャットルームをusersコレクションのサブコレクション 'chatRooms' に保存
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .collection('chatRooms')
                                    .doc(chatRoomId)
                                    .set({
                                  'roomId': chatRoomId,
                                  'users': [uid, likedUserId],
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      likedUserName: likedUser['name'],
                                      chatRoom: ChatRoom(
                                        roomId: chatRoomId,
                                        users: [uid, likedUserId],
                                      ),
                                      likedUserId: likedUserId,
                                      initialMessage: message,
                                    ),
                                  ),
                                  (Route<dynamic> route) => route.isFirst,
                                );

                                messageController.clear();
                              },
                              icon: const Icon(Icons.send),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('エラーが発生しました'),
            ),
          );
        } else {
          return const Text('インデックスが範囲外です');
        }
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('エラーが発生しました'),
    );
  }
}





//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userProfile = ref.watch(userdataProvider);
//     return userProfile.when(
//       data: (userProfile) => ListView.builder(
//           //後ほど設定 controller: controller,
//           itemCount: 1,
//           itemBuilder: (context, index) {
//             return Container(
//               color: Colors.grey,
//               height: 1000,
//               child: Stack(children: [
//                 Container(
//                   height: 340,
//                   width: 600,
//                   color: const Color.fromARGB(255, 205, 233, 255),
//                   child: const Center(child: Text('画像')),
//                 ),
//                 Positioned(
//                   top: 330,
//                   child: Container(
//                       decoration: const BoxDecoration(
//                         color: Color.fromARGB(255, 255, 169, 163),
//                         borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(15.0),
//                             topLeft: Radius.circular(15.0)),
//                       ),
//                       height: 600,
//                       width: 430,
//                       child: Column(
//                         children: [
//                           Text('${userProfile.name}'),
//                           Text('${userProfile.self}'),
//                           Text('${userProfile.area}'),
//                           Text('${userProfile.blood}'),
//                         ],
//                       )),
//                 ),
//               ]),
//             );
//           }),
//       error: (Object error, StackTrace stackTrace) => Text('Error: $error'),
//       loading: () => CircularProgressIndicator(),
//     );
//   }
// }
