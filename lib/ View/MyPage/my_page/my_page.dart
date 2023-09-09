import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Model/user_profile_prvider.dart';
import '../editpages/my_edit_page.dart';
import '../pickers/picker.dart';
import '../pickers/pickeritem/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userdataProvider);
    return userProfile.when(
      data: (userProfile) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                'マイページ',
                style: TextStyle(color: Colors.black),
              ),
              Align(
                alignment: const Alignment(1.1, 0),
                child: IconButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.black),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  color: Colors.black,
                  onPressed: () async {
                    print('ログアウト');
                    await FirebaseAuth.instance.signOut(); // ログアウト機能を追加
                    // ログイン画面など、ログアウト後の遷移先へ移動するコードもここに追加できます
                  },
                  icon: const Icon(Icons.logout),
                ),
              ),
            ],
          ),
          actions: [
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data;
                  if (user == null) {
                    // ユーザーがログアウトしている場合
                    return IconButton(
                      icon: const Icon(
                        Icons.login,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // ログインページへ遷移
                      },
                    );
                  } else {
                    // ユーザーがログインしている場合
                    return IconButton(
                      icon: const Icon(
                        Icons.star,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                    );
                  }
                }
                // まだ認証状態が確認できない（ローディング中）場合
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: 1200,
                child: Column(
                  children: [
                    Container(
                        color: Colors.grey,
                        child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          userProfile.profileImageUrls !=
                                                      null &&
                                                  userProfile.profileImageUrls!
                                                      .isNotEmpty
                                              ? CachedNetworkImageProvider(
                                                  userProfile
                                                      .profileImageUrls!.first)
                                              : null,
                                      backgroundColor: Colors.grey[300],
                                      radius: 85,
                                    ),
                                  ),
                                  Align(
                                    alignment: const Alignment(0.4, 0),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: const Size(50, 50),
                                        shape: const CircleBorder(), //形状
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ImageUploadPage()),
                                        );
                                      },
                                      // onPressed: () async {
                                      //   final pickedFile = await ImagePicker()
                                      //       .getImage(
                                      //           source: ImageSource.gallery);
                                      //   if (pickedFile != null) {
                                      //     final File imageFile =
                                      //         File(pickedFile.path);
                                      //     final imageUrl =
                                      //         await _uploadImageToFirebase(
                                      //             imageFile);
                                      //     await _saveImageUrlToFirestore(
                                      //         imageUrl);
                                      //   }

                                      // },
                                      child: const Icon(
                                        Icons.edit,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            userProfile.name ?? 'Unknown',
                            style: const TextStyle(
                                fontSize: 19, color: Colors.black),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Transform.rotate(
                              angle: 3.14,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => NameEditPage(''),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                  )),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 150,
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '自己紹介',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 30,
                                left: 30,
                              ),
                              child: Align(
                                  alignment: const Alignment(0, 0),
                                  child: Text(userProfile.self ?? 'Unknown')),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Transform.rotate(
                                  angle: 3.14,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SelfEditPage(''),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 20,
                                      )),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Picker(
                      '',
                      '',
                      '',
                      '',
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      error: (Object error, StackTrace stackTrace) => const Text('エラー'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
