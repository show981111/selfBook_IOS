import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/login_screen.dart';
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
    print("init called");
    jwtOrEmpty.then((value) {
      final parts = value.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }
      print(value);
      final String res = _decodeBase64(parts[1]);
      final payloadMap = json.decode(res);
      //print("USER " + payloadMap['userID']);
//      String userID = res[]
      getUserInfo(context , payloadMap['data']['userID'].toString()).then((value){
        if(value != null && value.isNotEmpty){

            widget.userInfoList = value;

        }
      });
      print(res);
//      print("RES "+payloadMap['data']['userID'].toString());
    });
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



  @override
  void didUpdateWidget(HomeScreen oldWidget) {//update child widget
    // TODO: implement didUpdateWidget
    print("called");
    print(oldWidget.userInfoList.toString());
    setState(() {
      widget.userInfoList = oldWidget.userInfoList;
    });
    super.didUpdateWidget(oldWidget);
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

Future<bool> checkValidity(String token) async{

  var response = await http.post(API.CHECKTOKEN, headers: {
    'Authorization': 'Bearer ' + token
  });
  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    return true;
  }else {
    return false;
  }
}
