import 'package:flutter/material.dart';
import 'package:zoovie/screens/main_page.dart';
import 'package:zoovie/widgets/bottom_bar.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TabController? controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoovie',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.black,
          secondary: Color(0xff00FF99),
        ),
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(), // 스크롤로 페이지 이동 방지
            children: [
              MainPage(),
              Container(color: Colors.green),
              Container(color: Colors.blue),
              Container(color: Colors.yellow),
            ],
          ),
          bottomNavigationBar: const BottomBar(),
        ),
      ),
    );
  }
}
