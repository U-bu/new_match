// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'new_picker.dart';


// final itemScopeProvider = ChangeNotifierProvider<Items>((ref) {
//   return Items();
// });
// class Items extends ChangeNotifier {
//  String? name ;
//   String? area;
//    String? job;
//  String? school;
//    String? blood;
//     String? height;
//      String? hobby;
//       String? smoke;
// // ];

//   final List<Widget>sheet = [
// AreaSheet(),
// JobSheet(),
// BloodSheet(),


//   ];
// final List<String>pickerItem = [
//   '職場',
//  '居住地',
//   '血液型',
//   '身長',
//   '趣味' 

// ];



// final List<String>PickerItemValue = [
// 'work',
// 'area',
// 'school',
// 'blood',
// 'height',
// 'hobby',

// ];

//  final List<String> bloodItem = [
//     '-',
//     'A型',
//     'B型',
//     'O型',
//     'AB型',
//     '不明',
//   ];
//    final List<String> schoolItem = [
//     '-',
//     '高高卒',
//     '大学卒',
//     '大学院卒'
//     'インターナショナル'
//   ];


// final List<String>jobItem = [
//    '北海道',
//   '青森県',
//   '岩手県',
//   '宮城県',
//   '秋田県',
//   '山形県',
//   '福島県',
//   '茨城県',
//   '栃木県',
//   '群馬県',
//   '埼玉県',
//   '千葉県',
//   '東京都',
//   '神奈川県',
//   '新潟県',
//   '富山県',
//   '石川県',
//   '福井県',
//   '山梨県',
//   '長野県',
//   '岐阜県',
//   '静岡県',
//   '愛知県',
//   '三重県',
//   '滋賀県',
//   '京都府',
//   '大阪府',
//   '兵庫県',
//   '奈良県',
//   '和歌山県',
//   '鳥取県',
//   '島根県',
//   '岡山県',
//   '広島県',
//   '山口県',
//   '徳島県',
//   '香川県',
//   '愛媛県',
//   '高知県',
//   '福岡県',
//   '佐賀県',
//   '長崎県',
//   '熊本県',
//   '大分県',
//   '宮崎県',
//   '鹿児島県',
//   '沖縄県',
// ];
// final List<String> areaItem = [
//   '北海道',
//   '青森県',
//   '岩手県',
//   '宮城県',
//   '秋田県',
//   '山形県',
//   '福島県',
//   '茨城県',
//   '栃木県',
//   '群馬県',
//   '埼玉県',
//   '千葉県',
//   '東京都',
//   '神奈川県',
//   '新潟県',
//   '富山県',
//   '石川県',
//   '福井県',
//   '山梨県',
//   '長野県',
//   '岐阜県',
//   '静岡県',
//   '愛知県',
//   '三重県',
//   '滋賀県',
//   '京都府',
//   '大阪府',
//   '兵庫県',
//   '奈良県',
//   '和歌山県',
//   '鳥取県',
//   '島根県',
//   '岡山県',
//   '広島県',
//   '山口県',
//   '徳島県',
//   '香川県',
//   '愛媛県',
//   '高知県',
//   '福岡県',
//   '佐賀県',
//   '長崎県',
//   '熊本県',
//   '大分県',
//   '宮崎県',
//   '鹿児島県',
//   '沖縄県',
// ];


// final List<String>smokeItem = [
//   '吸う',
//   '吸わない',
//   '時々吸う',
//   '吸うかも',
//   '吸わないかも',
//   '不明'
// ];
// final List<String> heightItem = [
//   '-',
//   ...List<String>.generate(81, (i) => '${i + 130}cm'),
// ];


 

//  void set_areadrum(int index) {
//    area = areaItem[index];
//     notifyListeners();
//   }
//   void set_jobdrum(int index) {
//    job = jobItem[index];
//     notifyListeners();
//   }

//  void set_blooddrum(int index) {
//    blood = bloodItem[index];
//     notifyListeners();
//   }

//  void set_heightdrum(int index) {
//    height = heightItem[index];
//     notifyListeners();
//   }

//  void set_smokerum(int index) {
//    smoke = smokeItem[index];
//     notifyListeners();
//   }



// Future jobUpdate(String item) async {
//     // this.blood = blood;

//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
    
//       'job':job
//     });
//   } Future areaUpdate(String item) async {
//     // this.blood = blood;

//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
    
//       'area':area
//     });
//   }

//    Future bloodUpdate(String item) async {
//     // this.blood = blood;

//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
    
//       'blood':blood
//     });
//   }
//    Future schoolUpdate(String item) async {
//     // this.blood = blood;

//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
    
//       'school':school
//     });
//   }
//      Future heightUpdate(String item) async {
//     // this.blood = blood;

//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
    
//       'height':height
//     });
//   }
//      Future hobbyUpdate(String item) async {
//     // this.blood = blood;

//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
    
//       'hobby':hobby
//     });
//   }
//      Future smokeUpdate(String item) async {
//     // this.blood = blood;

//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
    
//       'smoke':smoke
//     });
//   }

//   String fetchUser() {
//     Stream<QuerySnapshot> stream = FirebaseFirestore.instance
//     .collection('users')
//     .snapshots();
//   StreamBuilder<QuerySnapshot>(
//   stream: stream,
//   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return CircularProgressIndicator();
//     }
//     if (snapshot.hasError) {
//       return Text('Error: ${snapshot.error}');
//     }
//     if (!snapshot.hasData) {
//       return Text('No data available');
//     }
    
//     // 変更された値のみを取得して処理する
//     List<DocumentSnapshot> documents = snapshot.data!.docs;
//     // documentsリストを使ってデータを処理する
    
//     return Text('aaa');
//   },
// );

//   return 'データ';
// }


// Future<String?> fetchData() async {
//   final snapshot = await FirebaseFirestore.instance.collection('users').doc().get();

//   if (snapshot.exists) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     final area = data['area'] as String?;
//     final blood = data['blood'] as String?;
//    final height = data['height'] as String?;


//     return area;
//   } else {
//     return null;
//   }
// }

// }



