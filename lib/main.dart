import 'package:flutter/material.dart';
import 'package:selfbookflutter/screen/home_screen.dart';
import 'package:selfbookflutter/widget/bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  TabController controller;
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
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children : <Widget>[
              Container(child: Center(child : Text('preview')),),
              HomeScreen(),
              Container(child: Center(child : Text('login')),),
            ],
          ),
          bottomNavigationBar: Bottom(),
        ),
      ),
    );
  }
}
