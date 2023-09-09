import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Model/user_profile_prvider.dart';

final List<String> ageItem = [
  '-',
  ...List<String>.generate(81, (i) => '${i + 20}歳'), // 20歳から100歳まで
];

final List<String> bloodItem = [
  '-',
  'A型',
  'B型',
  'O型',
  'AB型',
  '不明',
];
final List<String> areaItem = [
  '北海道',
  '青森県',
  '岩手県',
  '宮城県',
  '秋田県',
  '山形県',
  '福島県',
  '茨城県',
  '栃木県',
  '群馬県',
  '埼玉県',
  '千葉県',
  '東京都',
  '神奈川県',
  '新潟県',
  '富山県',
  '石川県',
  '福井県',
  '山梨県',
  '長野県',
  '岐阜県',
  '静岡県',
  '愛知県',
  '三重県',
  '滋賀県',
  '京都府',
  '大阪府',
  '兵庫県',
  '奈良県',
  '和歌山県',
  '鳥取県',
  '島根県',
  '岡山県',
  '広島県',
  '山口県',
  '徳島県',
  '香川県',
  '愛媛県',
  '高知県',
  '福岡県',
  '佐賀県',
  '長崎県',
  '熊本県',
  '大分県',
  '宮崎県',
  '鹿児島県',
  '沖縄県',
];

final List<String> heightItem = [
  '-',
  ...List<String>.generate(81, (i) => '${i + 130}cm'),
];

class BloodPicker extends ConsumerWidget {
  const BloodPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userdataProvider);
    return userProfile.when(
      data: (userProfile) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                '血液型',
              ),
            ),
            Text(
              userProfile.blood ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      error: (Object error, StackTrace stackTrace) => const Text('エラー'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class HeightPicker extends ConsumerWidget {
  const HeightPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userdataProvider);
    return userProfile.when(
      data: (userProfile) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                '身長',
              ),
            ),
            Text(
              userProfile.height ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      error: (Object error, StackTrace stackTrace) => const Text('エラー'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class AreaPicker extends ConsumerWidget {
  const AreaPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userdataProvider);
    return userProfile.when(
      data: (userProfile) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                '居住地',
              ),
            ),
            Text(
              userProfile.area ?? '地域が登録されていません',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      error: (Object error, StackTrace stackTrace) => const Text('エラー'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class Picker extends StatelessWidget {
  final String item;
  final String fieldName;

  const Picker(this.item, this.fieldName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
        stream: users.doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('');
          }

          var userDocument = snapshot.data;
          return Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(item),
                    ),
                    Text(
                      '${userDocument![fieldName] ?? '情報が登録されていません'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class AgePicker extends ConsumerWidget {
  const AgePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userdataProvider);
    return userProfile.when(
      data: (userProfile) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                '年齢',
              ),
            ),
            Text(
              userProfile.age ?? '年齢が登録されていません',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      error: (Object error, StackTrace stackTrace) => const Text('エラー'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
