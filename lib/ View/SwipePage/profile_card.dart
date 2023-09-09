import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../SwipePage/swipe_method.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final CardSwiperController controller = CardSwiperController();
  late Stream<QuerySnapshot> _usersStream2;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  int currentImageIndex = 0;
  late Future<List<String>> likedUserIds;

  @override
  void initState() {
    super.initState();
    _usersStream2 = FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: uid) // ログインユーザーを除外
        .snapshots();
    print(uid);
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: likedUserIds, // 追加
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          final likedIds = snapshot.data!;

          return StreamBuilder<QuerySnapshot>(
              stream: _usersStream2,
              builder: (context, streamSnapshot) {
                if (!streamSnapshot.hasData) {
                  return const Center(
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final users = streamSnapshot.data!.docs.where((userDoc) {
                  return !likedIds.contains(userDoc.id);
                }).toList();

                return Scaffold(
                  body: SafeArea(
                    child: Stack(
                      children: [
                        CardSwiper(
                          controller: controller,
                          cardsCount: users.length,
                          onSwipe: (previousIndex, currentIndex, direction) {
                            if (direction == CardSwiperDirection.right) {
                              SwipeMethod.likeUser(
                                  uid, users[previousIndex].id);
                              SwipeMethod.likedByUser(
                                  users[previousIndex].id, uid);
                            } else {
                              SwipeMethod.dislikeUser(
                                  uid, users[previousIndex].id);
                              SwipeMethod.dislikedByUser(
                                  users[previousIndex].id, uid);
                            }
                            return true;
                          },
                          numberOfCardsDisplayed: 1,
                          backCardOffset: const Offset(0, 40),
                          padding: const EdgeInsets.all(24.0),
                          cardBuilder: (
                            context,
                            index,
                            horizontalThresholdPercentage,
                            verticalThresholdPercentage,
                          ) =>
                              Material(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.white,
                            elevation: 10.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Stack(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: Positioned.fill(
                                            child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          child: CachedNetworkImage(
                                            imageUrl: users[index]
                                                ['profileImageUrls'][0],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: SizedBox(
                                                width: 20.0, // インジケータの幅
                                                height: 20.0, // インジケータの高さ
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        )),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                // setState(() {
                                                //   currentImageIndex =
                                                //       (currentImageIndex + 1) %
                                                //           (users[index][
                                                //                   'profileImageUrls']
                                                //               .length as int);
                                                // });
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
                                                // setState(() {
                                                //   currentImageIndex =
                                                //       (currentImageIndex - 1) %
                                                //           (users[index][
                                                //                   'profileImageUrls']
                                                //               .length as int);
                                                // });
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
                                  Align(
                                    alignment: const Alignment(0, 0.55),
                                    child: Text(
                                      users[index]['name'] ?? '名前無し',
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Align(
                                    alignment: const Alignment(0, 0.7),
                                    child: Text(
                                      users[index]['self'] ?? '名前無し',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
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
                              ),
                            ),
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
                        // ... [他のコード]
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
