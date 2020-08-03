import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
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
    jwtOrEmpty.then((value) {
      final parts = value.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      final String res = _decodeBase64(parts[1]);

      print("RES "+res);
    });
    print('home userinfo' + widget.userInfoList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( body :ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            CarouselImage(userInfo: widget.userInfoList != null &&  widget.userInfoList.length > 0 ?
                widget.userInfoList[0] : null),
          ],
        ),
//        CircleSlider(movies: movies,),
        BoxSlider(userInfoList: widget.userInfoList,),
      ],

    )
    );
  }
}


String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

bool checkValidity(String token){
  
}
