import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class TestCard extends StatefulWidget {
  const TestCard({super.key});

  @override
  _TestCardState createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  late Stream<QuerySnapshot> _usersStream;
  late Future<List<String>> likedUserIds;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, int> userImageIndices = {};

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: uid) // ログインユーザーを除外
        .snapshots();
    likedUserIds = getLikedUserIds();
  }

  Future<List<String>> getLikedUserIds() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('likes')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: likedUserIds,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        final likedIds = snapshot.data!;
        return StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = streamSnapshot.data!.docs.where((userDoc) {
              return !likedIds.contains(userDoc.id);
            }).toList();

            for (var user in users) {
              userImageIndices.putIfAbsent(user.id, () => 0);
            }

            return Stack(
              children: [
                CardSwiper(
                  numberOfCardsDisplayed: 1,
                  backCardOffset: const Offset(0, 40),
                  padding: const EdgeInsets.all(24.0),
                  cardsCount: users.length,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) =>
                          Stack(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: const [
                              // BoxShadow(
                              //   color: Colors.grey, //色
                              //   spreadRadius: 5,
                              //   blurRadius: 5,
                              //   offset: Offset(0, 0.1),
                              // ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                  child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CachedNetworkImage(
                                  imageUrl: users[index]['profileImageUrls']
                                      [userImageIndices[users[index].id]!],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 20.0, // インジケータの幅
                                      height: 20.0, // インジケータの高さ
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              )),
                              Align(
                                  alignment: const Alignment(0, 0.55),
                                  child: Text(
                                    users[index]['name'] ?? '名前無し',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                              Align(
                                  alignment: const Alignment(0, 0.7),
                                  child: Text(
                                    users[index]['self'] ?? '名前無し',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                              Align(
                                alignment: const Alignment(0, 0.9),
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'プロフィールを見る',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          users[index]['profileImageUrls'].length,
                          (dotIndex) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  dotIndex == userImageIndices[users[index].id]
                                      ? Colors.white
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (userImageIndices[users[index].id]! > 0) {
                                    userImageIndices[users[index].id] =
                                        userImageIndices[users[index].id]! - 1;
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (userImageIndices[users[index].id]! <
                                      users[index]['profileImageUrls'].length -
                                          1) {
                                    userImageIndices[users[index].id] =
                                        userImageIndices[users[index].id]! + 1;
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 90,
                  bottom: 35,
                  child: SizedBox(
                    width: 70,
                    child: FloatingActionButton(
                      elevation: 10.0,
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(
                        Icons.favorite_border,
                        size: 40,
                        color: Color.fromARGB(255, 244, 149, 181),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 90,
                  bottom: 35,
                  child: SizedBox(
                    width: 70,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      elevation: 10.0,
                      onPressed: () {},
                      child: const Icon(
                        Icons.close,
                        size: 40,
                        color: Color.fromARGB(255, 96, 105, 139),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
