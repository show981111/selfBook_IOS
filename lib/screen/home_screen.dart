import 'package:flutter/material.dart';
import 'package:selfbookflutter/widget/carousel_slider.dart';

class HomeScreen extends StatefulWidget{
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            CarouselImage(),
          ],
        ),
//        CircleSlider(movies: movies,),
//        BoxSlider(movies: movies),
      ],

    );
  }
}
