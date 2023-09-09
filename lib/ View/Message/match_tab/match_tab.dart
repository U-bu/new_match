import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../matches_page/match_list.dart';

class MatchTab extends StatelessWidget {
  MatchTab({Key? key}) : super(key: key);
  final String? uid = FirebaseAuth.instance.currentUser?.uid; // Null check

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 2, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'やりとり',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 15.0),
            labelColor: Colors.black,
            tabs: <Widget>[
              Tab(text: 'マッチング'),
              Tab(
                text: 'メッセージ',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Center(
              child: MatchList(), // ここでuidを渡します
            ),
            Center(child: MessageNowList()),
          ],
        ),
      ),
    );
  }
}
