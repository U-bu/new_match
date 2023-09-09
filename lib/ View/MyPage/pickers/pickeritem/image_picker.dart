import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final List<String?> _images = List.filled(5, null);

  @override
  void initState() {
    super.initState();
    _loadProfileImages();
  }

  Future<void> _loadProfileImages() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot docSnapshot = await docRef.get();
    List<String>? profileImageUrls = List.from(
        (docSnapshot.data() as Map<String, dynamic>)['profileImageUrls'] ?? []);

    for (int i = 0; i < _images.length && i < profileImageUrls.length; i++) {
      final imageUrl = profileImageUrls[i];
      setState(() {
        _images[i] = imageUrl; // URLを直接代入します
      });
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('user_profile_images/${const Uuid().v4()}.png');
    final uploadTask = storageReference.putFile(imageFile);
    await uploadTask; // 修正された部分
    final downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }

  Future<void> uploadImageAtIndex(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // ImageCropperを使用して画像をクロップ
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio:
            const CropAspectRatio(ratioX: 1, ratioY: 1.3), // 1:1 のアスペクト比に固定
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        File fileToUpload = File(croppedFile.path); // ここでFileインスタンスを作成

        // クロップされた画像をFirebaseにアップロード
        String imageUrl = await _uploadImageToFirebase(fileToUpload);

        // 画像URLをリストに保存
        setState(() {
          _images[index] = imageUrl;
        });

        // Firestoreに画像URLを保存
        final uid = FirebaseAuth.instance.currentUser!.uid;
        DocumentReference docRef =
            FirebaseFirestore.instance.collection('users').doc(uid);
        DocumentSnapshot docSnapshot = await docRef.get();
        List<String>? profileImageUrls = List.from(
            (docSnapshot.data() as Map<String, dynamic>)['profileImageUrls'] ??
                []);

        if (profileImageUrls.length > index) {
          profileImageUrls[index] = imageUrl;
        } else {
          profileImageUrls.add(imageUrl);
        }
        await docRef.update({'profileImageUrls': profileImageUrls});
      }
    }
  }

  void _showEnlargedImage(String imageUrl, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          children: [
            Expanded(child: Image.network(imageUrl)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // モーダルを閉じます。
                    await uploadImageAtIndex(index); // 画像を変更するための関数を再度呼び出します。
                  },
                  child: const Text("変更"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // モーダルを閉じるだけです。
                  },
                  child: const Text("キャンセル"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('画像の追加'),
      ),
      body: GridView.builder(
        itemCount: _images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // ここでの値は例として3を使用しています。
        ),
        itemBuilder: (context, index) {
          final imageUrl = _images[index];

          return GestureDetector(
            onTap: () async {
              if (imageUrl == null) {
                await uploadImageAtIndex(index); // 既に提供された関数を使用
              } else {
                _showEnlargedImage(imageUrl, index); // 拡大表示する関数を呼び出し
              }
            },
            child: imageUrl == null
                ? const Icon(Icons.add) // または「追加」ボタンのデザイン
                : Image.network(imageUrl),
          );
        },
      ),
    );
  }
}

// Future<void> uploadImageAtIndex(int index) async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       // ImageCropperを使用して画像をクロップ
//       File? croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile.path,
//         aspectRatioPresets: [
//           CropAspectRatioPreset.square,
//           CropAspectRatioPreset.ratio3x2,
//           CropAspectRatioPreset.original,
//           CropAspectRatioPreset.ratio4x3,
//           CropAspectRatioPreset.ratio16x9
//         ],
//         uiSettings: [
//           AndroidUiSettings(
//               toolbarTitle: 'Cropper',
//               toolbarColor: Colors.deepOrange,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false),
//           IOSUiSettings(
//             title: 'Cropper',
//           ),
//         ],
//       ) as File?;