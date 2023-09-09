import 'package:flutter/material.dart';

import '../SwipePage/likeuser_card.dart';
import '../SwipePage/profile_card.dart';
import '../SwipePage/swipe_test.dart';
import '../SwipePage/swipe_test2.dart';

class SwipePage extends StatelessWidget {
  const SwipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 2, // タブの数
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const TabBar(
            labelStyle: TextStyle(fontSize: 25.0),
            labelColor: Colors.black,
            tabs: <Widget>[
              Tab(text: 'おすすめ'),
              Tab(text: '相手から'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Center(child: TestCard()),
            Center(
              child: TestCard2(),
            ),
          ],
        ),
      ),
    );
  }
}

// class ProfileCard extends StatefulWidget {
//   const ProfileCard({super.key});

//   @override
//   _ProfileCardState createState() => _ProfileCardState();
// }

// class _ProfileCardState extends State<ProfileCard> {
//   final uid = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .where(FieldPath.documentId, isNotEqualTo: uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final users = snapshot.data!.docs;

//         return ListView.builder(
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//             final imageUrl = user['profileImageUrls'][0]; // 仮定: imageUrlsはリスト
//             final name = user['name'];
//             final docId = user.id;

//             return Card(
//               child: ListTile(
//                 leading: Image.network(imageUrl),
//                 title: Text(name + docId),

//                 // 他のユーザー情報もここに追加できます
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class ProfileCard extends ConsumerWidget {
//   final swipecontroller = AppinioSwiperController();
//   final uid = FirebaseAuth.instance.currentUser!.uid;
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   String? likedUserId;

//   ProfileCard({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final swipedUsers = ref.watch(swipedUsersStreamProvider);

//     return Stack(
//       children: [
//         Align(
//           alignment: const Alignment(0, -0.5),
//           child: swipedUsers.when(
//             data: (swipedUsersList) {
//               return StreamBuilder<QuerySnapshot>(
//                 stream: users
//                     .where(FieldPath.documentId, isNotEqualTo: uid)
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return const Text('名前なし');
//                   }
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   }

//                   List<Widget> pages = snapshot.data!.docs
//                       .where((doc) => !swipedUsersList.contains(doc.id))
//                       .map((DocumentSnapshot document) {
//                     Map<String, dynamic> data =
//                         document.data() as Map<String, dynamic>;
//                     return Stack(
//                       children: [
//                         Center(child: Pcard(data: data)),
//                       ],
//                     );
//                   }).toList();

//                   if (pages.isNotEmpty) {
//                     return SizedBox(
//                       width: MediaQuery.of(context).size.width * 1,
//                       height: MediaQuery.of(context).size.height * 0.65,
//                       child: AppinioSwiper(
//                         onSwipe: (index, direction) {
//                           if (direction == AppinioSwiperDirection.right) {
//                             likedUserId = snapshot.data!.docs[index].id;
//                             SwipeMethod.likeUser(uid, likedUserId!);
//                           }
//                         },
//                         controller: swipecontroller,
//                         cardsCount: pages.length,
//                         cardsBuilder: (BuildContext context, int index) {
//                           return Container(
//                             alignment: Alignment.center,
//                             color: Colors.transparent,
//                             child: pages[index],
//                           );
//                         },
//                       ),
//                     );
//                   } else {
//                     return const Center(
//                       child: Text('No users available.'),
//                     );
//                   }
//                 },
//               );
//             },
//             loading: () => const CircularProgressIndicator(),
//             error: (_, __) => const Text('An error occurred'),
//           ),
//         ),
//         //... (他の部分は変わっていません)

//         Positioned(
//           right: 90,
//           bottom: 35,
//           child: SizedBox(
//             width: 70,
//             child: FloatingActionButton(
//               elevation: 10.0,
//               backgroundColor: Colors.white,
//               onPressed: () {
//                 swipecontroller.swipeRight();
//                 if (likedUserId != null) {
//                   SwipeMethod.likeUser(uid, likedUserId!);
//                 }
//               },
//               child: const Icon(
//                 Icons.favorite_border,
//                 size: 40,
//                 color: Color.fromARGB(255, 244, 149, 181),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           left: 90,
//           bottom: 35,
//           child: SizedBox(
//             width: 70,
//             child: FloatingActionButton(
//               backgroundColor: Colors.white,
//               elevation: 10.0,
//               onPressed: () {
//                 swipecontroller.swipeLeft();
//                 SwipeMethod.dislikeUser('likerId', 'likedUserId');
//               },
//               child: const Icon(
//                 Icons.close,
//                 size: 40,
//                 color: Color.fromARGB(255, 96, 105, 139),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ignore: must_be_immutable
class Pcard extends StatelessWidget {
  const Pcard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50.0),
      color: const Color.fromARGB(255, 255, 172, 167),
      elevation: 10.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          // Image.network を使う場合は、ここで DecorationImage は使用せず、
          // Stack の中で Image.network を使用します。
        ),
        child: Stack(
          children: [
            // Image.network を使用して画像を表示します。
            if (data['profileImageUrls'] is List &&
                data['profileImageUrls'].isNotEmpty)
              Image.network(
                data['profileImageUrls'][0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            else
              Image.network(
                'デフォルトの画像URL',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: Text(
                  data['name'] ?? '名前無し',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
