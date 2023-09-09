import 'package:flutter/material.dart';
import 'package:new_match/%20View/SwipePage/swipe_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import ' View/GridPage/grid_page.dart';
import ' View/Message/match_tab/match_tab.dart';
import ' View/MyPage/my_page/my_page.dart';

void main() async {
  // 初期化処理を追加
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
  // DevicePreview(
  //   builder: (context) => ProviderScope(child: MyApp()),
  //   enabled: !kReleaseMode, // Releaseモードでは無効化
  // ),
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> tabOptions = <Widget>[
    const SwipePage(),
    const TestCardGrid(),
    const Text('あああ'),
    MatchTab(),
    const MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tabOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '探す',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '未定',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'やりとり',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'マイページ',
          ),
        ],
        currentIndex: _selectedIndex,
        elevation: 0.0, //現在のアクティブインデックスを表示
        backgroundColor: Colors.white, //ボトムバーの背景色
        selectedItemColor: Colors.black, //Icon選択時にIcon色を指定
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped, //Iconタップ時のイベント
      ),
    );
  }
}
