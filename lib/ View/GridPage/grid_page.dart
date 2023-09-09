import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestCardGrid extends StatefulWidget {
  const TestCardGrid({super.key});

  @override
  _TestCardGridState createState() => _TestCardGridState();
}

class _TestCardGridState extends State<TestCardGrid> {
  late Stream<QuerySnapshot> _usersStream;
  late Future<List<String>> likedUserIds;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, int> userImageIndices = {};

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: uid)
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

            return SafeArea(
              child: Scaffold(
                // AppBarをSliverAppBarに変更
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
                        ],
                        backgroundColor: Colors.white,
                        title: const Text(
                          'tapple',
                          style: TextStyle(color: Colors.black),
                        ),
                        expandedHeight: 200.0, // 高さを調整
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight,
                                    colors: [
                                      const Color(0xffe4a972).withOpacity(0.6),
                                      const Color(0xff9941d8).withOpacity(0.6),
                                    ],
                                    stops: const [
                                      0.0,
                                      1.0,
                                    ],
                                  ),
                                ),
                              ), // 上部にスペースを追加
                              Expanded(
                                child: PageView(
                                  children: [
                                    Image.asset(
                                      'images/a_dot_ham.jpeg',
                                      fit: BoxFit.cover,
                                    ),
                                    Image.asset(
                                      'images/a_dot_ham.jpeg',
                                      fit: BoxFit.cover,
                                    ),
                                    // 他の画像を追加
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 48,
                            // color: Colors.grey,
                            child: Align(
                              alignment: Alignment(-0.8, 0.8),
                              child: Text(
                                '人気の相手',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          PopularUser(
                              users: users, userImageIndex: userImageIndices),
                          const SizedBox(
                            height: 48,
                            // color: Colors.grey,
                            child: Align(
                              alignment: Alignment(-0.8, 0.8),
                              child: Text(
                                '趣味が合うユーザー',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          HobbyUser(
                              users: users, userImageIndex: userImageIndices),
                          const SizedBox(
                            height: 48,
                            // color: Colors.grey,
                            child: Align(
                              alignment: Alignment(-0.8, 0.8),
                              child: Text(
                                '最近始めたユーザー',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          BiginerUser(
                              users: users, userImageIndex: userImageIndices),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PopularUser extends StatelessWidget {
  const PopularUser({
    super.key,
    required this.users,
    required this.userImageIndex,
  });

  final List<QueryDocumentSnapshot<Object?>> users;
  final Map<String, int> userImageIndex;
  final TextStyle style = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: SizedBox(
        height: 250,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 4.55 / 3,
          ),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            // ここに各カードの内容を書く
            // 例: return YourCardWidget(user: users[index]);
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Material(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: CachedNetworkImage(
                          imageUrl: users[index]['profileImageUrls']
                              [userImageIndex[users[index].id]!],
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
                      Positioned(
                        left: 10,
                        top: 160,
                        child: SizedBox(
                          height: 100,
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(users[index]['age'] ?? '名前無し',
                                      style: style),
                                  Text('・', style: style),
                                  Text(users[index]['name'] ?? '名前無し',
                                      style: style),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[500],
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: const [
                                    BoxShadow(
                                        // color: Colors.grey, //色
                                        ),
                                  ],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: Text(
                                    '趣味タグ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[500],
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: const [
                                    BoxShadow(
                                        // color: Colors.grey, //色
                                        ),
                                  ],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: Text(
                                    '趣味タグ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Align(
                      //     alignment: const Alignment(0, 0.7),
                      //     child:
                      //         Text(users[index]['self'] ?? '名前無し', style: style)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HobbyUser extends StatelessWidget {
  const HobbyUser({
    super.key,
    required this.users,
    required this.userImageIndex,
  });

  final List<QueryDocumentSnapshot<Object?>> users;
  final Map<String, int> userImageIndex;
  final TextStyle style = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 0.1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: SizedBox(
        height: 280,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 5.1 / 3,
          ),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            // ここに各カードの内容を書く
            // 例: return YourCardWidget(user: users[index]);
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Material(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 222,
                        width: 200,
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                imageUrl: users[index]['profileImageUrls']
                                    [userImageIndex[users[index].id]!],
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
                                alignment: const Alignment(0.5, 0.9),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(users[index]['age'] ?? '名前無し',
                                        style: style),
                                    Text('・', style: style),
                                    Text(users[index]['name'] ?? '名前無し',
                                        style: style),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 1),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0)),
                            boxShadow: [
                              BoxShadow(
                                  // color: Colors.grey, //色
                                  ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                              backgroundColor:
                                  const Color.fromARGB(255, 248, 96, 111),
                              elevation: 0,
                              onPressed: () {},
                              label: Text(
                                'いいかも',
                                style: style,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BiginerUser extends StatelessWidget {
  const BiginerUser({
    super.key,
    required this.users,
    required this.userImageIndex,
  });

  final List<QueryDocumentSnapshot<Object?>> users;
  final Map<String, int> userImageIndex;
  final TextStyle style = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 0.1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: SizedBox(
        height: 280,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 5.1 / 3,
          ),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            // ここに各カードの内容を書く
            // 例: return YourCardWidget(user: users[index]);
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Material(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
                elevation: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 222,
                        width: 200,
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                imageUrl: users[index]['profileImageUrls']
                                    [userImageIndex[users[index].id]!],
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
                                alignment: const Alignment(0.5, 0.9),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(users[index]['age'] ?? '名前無し',
                                        style: style),
                                    Text('・', style: style),
                                    Text(users[index]['name'] ?? '名前無し',
                                        style: style),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 1),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0)),
                            boxShadow: [
                              BoxShadow(
                                  // color: Colors.grey, //色
                                  ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.extended(
                              backgroundColor:
                                  const Color.fromARGB(255, 248, 96, 111),
                              elevation: 0,
                              onPressed: () {},
                              label: Text(
                                'いいかも',
                                style: style,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class GridviewPage extends StatefulWidget {
//   String? fhotoList;
//   String? name;

//   GridviewPage({super.key, this.fhotoList, this.name});
//   //画面に描画するデータリスト作成

//   @override
//   _GridviewPageState createState() => _GridviewPageState();
// }

// class _GridviewPageState extends State<GridviewPage> {
//   final List<String> texts = [
//     'box1',
//     'box2',
//     'box3',
//     'box4',
//     'box5',
//     'box6',
//     'box7',
//     'box8',
//     'box9',
//     'box10',
//     'box11',
//     'box12',
//     'box13',
//     'box14',
//     'box15',
//     'box16',
//     'box17',
//     'box18',
//     'box19',
//     'box20',
//     'box21',
//     'box22',
//     'box23',
//     'box24',
//   ];

//   late Stream<QuerySnapshot> _usersStream;
//   String? name;
//   final uid = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     return StreamBuilder<QuerySnapshot>(
//         stream: users
//             .where('default', isEqualTo: true)
//             .where(FieldPath.documentId, isNotEqualTo: uid)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return const Text('名前なし');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text("Loading");
//           }
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('GridviewPage'),
//             ),
//             body: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   DocumentSnapshot document = snapshot.data!.docs[index];
//                   Map<String, dynamic> data =
//                       document.data() as Map<String, dynamic>;

//                   return GridTile(
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Material(
//                         borderRadius: BorderRadius.circular(18),
//                         elevation: 8,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(18),
//                             color: const Color.fromARGB(255, 255, 169, 163),
//                           ),
//                           child: Column(children: <Widget>[
//                             data['image'] != null
//                                 ? Image.network(data['image'])
//                                 : Container(),
//                             Text(
//                               data['name'] ?? '名前無し',
//                             ),
//                             Text(data['area'] ?? '地域無し'),
//                           ]),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//           );
//         });
//   }
// }
