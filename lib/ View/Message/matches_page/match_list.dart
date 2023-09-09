import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Model/other_profile_provider.dart';
import '../../MyPage/profile/other_profile_card.dart';
import 'chat/chat_page.dart';

class MatchList extends ConsumerWidget {
  const MatchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final likes = ref.watch(likesProvider(uid ?? ''));
    final existingChatRoomsAsyncValue = ref.watch(chatRoomsProvider(uid ?? ''));

    return likes.when(
      data: (likes) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: likes.length,
        itemBuilder: (context, index) {
          final likedUser = ref.watch(likedUserProvider(likes[index]));

          // existingChatRoomsAsyncValueがデータを持っている場合のみチェック
          if (existingChatRoomsAsyncValue
              is AsyncData<List<QueryDocumentSnapshot>>) {
            final existingChatRooms = existingChatRoomsAsyncValue.value;
            if (existingChatRooms.any((room) =>
                ((room.data() as Map<String, dynamic>)['users'] ?? [])
                    .contains(likes[index]))) {
              return Container();
            }
          }

          // 既存の部分
          return likedUser.when(
            data: (likedUser) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OtherProfileCard(
                      uid: uid ?? '',
                      index: index,
                      likedUserId: likes[index],
                    ),
                  ),
                );
              },
              child: GridTile(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(children: [
                    // ここを変更
                    CachedNetworkImage(
                      imageUrl:
                          likedUser['profileImageUrls'][0] ?? 'デフォルトの画像URL',
                      imageBuilder: (context, imageProvider) => Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
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
                    // 以下は変更なし
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                          color: Colors.white,
                        ),
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Stack(children: [
                          Align(
                            alignment: const Alignment(0, -0.2),
                            child: Text(
                              likedUser['name'] ?? 'No Name',
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0, 0.3),
                            child: Text(
                              likedUser['area'] ?? 'No Area',
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            // ... (残りのコードは変更なし)

            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('エラーが発生しました'),
          );
        },
      ),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('エラーが発生しました'),
    );
  }
}

class MessageNowList extends ConsumerWidget {
  const MessageNowList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final chatRoomsAsyncValue = ref.watch(chatRoomsProvider2(uid));

    return chatRoomsAsyncValue.when(
      data: (chatRooms) {
        if (chatRooms.isEmpty) {
          return const Center(
            child: Text('No messages yet.'),
          );
        }

        return ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (BuildContext context, int index) {
            final chatRoom = chatRooms[index];
            final opponentUserId =
                chatRoom.users.firstWhere((userId) => userId != uid);

            final likedUserDataAsyncValue =
                ref.watch(likedUserProvider(opponentUserId));

            return likedUserDataAsyncValue.when(
              data: (likedUser) {
                final name = likedUser['name'];
                return ListTile(
                  title: Text(name ?? 'No Name'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          likedUserName: likedUser['name'],
                          likedUserId: opponentUserId,
                          chatRoom: chatRoom,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('エラーが発生しました'),
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Center(child: Text('An error occurred')),
    );
  }
}
