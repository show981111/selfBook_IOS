import 'package:flutter/material.dart';
import 'package:selfbookflutter/screen/home_screen.dart';
import 'package:selfbookflutter/screen/login_screen.dart';
import 'package:selfbookflutter/widget/bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin{
  TabController controller;

  @override
  void initState() {
    controller =  new TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title : "NetflixClone",
      theme : ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white
      ),
      home : DefaultTabController(
        length: 3,
        child: Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}
