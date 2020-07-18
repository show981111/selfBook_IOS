import 'package:flutter/material.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/widget/carousel_slider.dart';
import 'package:selfbookflutter/widget/my_draft_box_silder.dart';

class HomeScreen extends StatefulWidget{
  List<UserInfo> userInfoList = new List<UserInfo>();
  HomeScreen({this.userInfoList});

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  @override
  void initState() {
    super.initState();
    print('home userinfo' + widget.userInfoList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( body :ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            CarouselImage(),
          ],
        ),
//        CircleSlider(movies: movies,),
        BoxSlider(userInfoList: widget.userInfoList,),
      ],

    )
    );
  }
}
