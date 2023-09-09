// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:image_picker/image_picker.dart';

// final imageProvider = StateNotifierProvider<ImagePickerNotifier,File?>((ref) {
//   return ImagePickerNotifier();
// });

// class ImagePickerNotifier extends StateNotifier<File?> {
//   ImagePickerNotifier() : super(null);

//   final picker = ImagePicker();

//   Future<void> pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       state = File(pickedFile.path);
//     }
//   }

//   Future<void> uploadImage() async {
//     if (state == null) return;

//     final storage = firebase_storage.FirebaseStorage.instance;
//     final ref = storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');

//     await ref.putFile(state!);
//     final downloadURL = await ref.getDownloadURL();

//     // 画像のアップロードが完了したら、取得したURLを使って任意の処理を行う
//     print('Download URL: $downloadURL');
//   }
// }

// class ImagePickerWidget extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final imageState = ref.watch(imageProvider);
//     final imageFile = imageState;

//     return Scaffold(
//       appBar: AppBar(
//         title:Text('画像アップロード'),
//       ),
//       body: Column(
//         children: [
//           if (imageFile != null)
//             Image.file(
//               imageFile,
//               height: 200,
//               width: 200,
//             ),
//           ElevatedButton(
//             onPressed: () => ref.read(imageProvider.notifier).pickImage(),
//             child: Text('画像を選択'),
//           ),
//           ElevatedButton(
//             onPressed: () => ref.read(imageProvider.notifier).uploadImage(),
//             child: Text('画像をアップロード'),
//           ),
//         ],
//       ),
//     );
//   }
// }



// /// ユーザIDの取得
// final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

// void uploadPic() async {
//   try {
//     /// 画像を選択
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     File file = File(image!.path);

//     /// Firebase Cloud Storageにアップロード
//     String uploadName = 'image.png';
//     final storageRef =
//         FirebaseStorage.instance.ref().child('users/$userID/$uploadName');
//     final task = await storageRef.putFile(file);
//   } catch (e) {
//     print(e);
//   }

//   /// アップロードの一時停止

// bool paused = await task.pause();
// print('paused, $paused');

// /// アップロードの再開
// bool resumed = await task.resume();
// print('resumed, $resumed');

// /// アップロードのキャンセル
// bool canceled = await task.cancel();
// print('canceled, $canceled');
// }
