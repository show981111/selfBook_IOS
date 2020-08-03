import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/home_screen.dart';
import 'package:toast/toast.dart';

import 'my_draft_box_silder.dart';


Future<void> showPurchaseDialog(BuildContext context, String message,String userID, String templateCode) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user dont have button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text(
              message
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('확인'),
            onPressed: () {
              purchaseItem(context ,userID, templateCode).then((value){
                if(value == 'success'){
                  Toast.show('성공적으로 구매하였습니다!', context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                  refetchUserInfo(context ,userID);
                  return;
                }else if(value == 'already'){
                  Toast.show('이미 구매한 항목입니다!', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }
                else{
                  Toast.show('오류가 발생했습니다! 다시한번 시도해주세요!', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }
              }).catchError((e) {
                print('error ' + e);
                if(e == 'upload fail'){
                  Toast.show('오류가 발생했습니다! 다시한번 시도해주세요!', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }else if(e == "Auth fail"){
                  Toast.show('인증이 만료되었습니다! 다시한번 로그인해주세요!', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }else{
                  Toast.show('오류가 발생했습니다! 인터넷연결을 확인해주세요!', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<String> purchaseItem(BuildContext context ,String userID, String templateCode) async{
//  $userID = $_POST['userID'];
//  $templateCode = $_POST['templateCode'];
  String token = await jwtOrEmpty;
  print(token);
  Map data = {
    'userID' : userID,
    'templateCode' : templateCode,
  };
  print(userID + templateCode);
  var response = await http.post(API.POST_SETUSERPURCHASE, body: data,headers: {
    'Authorization': 'Bearer ' + token
  });
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body;
    if(result != null ){
      return result;
    }else{
      return Future.error('upload fail');
    }
  }else if(response.statusCode == 401){
    return Future.error('Auth fail');
  }else{
    return Future.error('connection fail');
  }
}

//Future<List<UserInfo>> refetchUserInfo(BuildContext context ,String userID) async{
//  String token = await jwtOrEmpty;
//  List<UserInfo> res = new List<UserInfo>();
//
//  var queryParameters = {
//    'userID': userID,
//  };
//
//  var uri = Uri.http(API.IP, "/purchases" ,queryParameters);
//  print(uri);
//
//  var response = await http.get(uri, headers: {
//    'Authorization': 'Bearer ' + token,
//    'Content-Type': 'application/json',
//  });
//
//  print("response " + response.body);
//  if(response.statusCode == 200 && response.body.isNotEmpty){
//
//    var result = json.decode(response.body);
//    print('encoded res' + result.toString());
//
//    for(int i = 0; i < result.length; i++){
//      UserInfo userInfoItem = UserInfo.fromJson(result[i]);
//      res.add(userInfoItem);
//    }
//
//    Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder:
//            (BuildContext context) => BoxSlider(userInfoList: res,))
//        ,(Route<dynamic> route) => false);
//    return res;
//
//  }else if(response.statusCode == 401){
//    return Future.error('Access Denied');
//  }else{
//    return Future.error('loading fail');
//  }
//}



Future<List<UserInfo>> refetchUserInfo(BuildContext context ,String userID) async{

  List<UserInfo> res = new List<UserInfo>();
  String token = await jwtOrEmpty;
  Map data = {
    'userID' : userID
  };

  var queryParameters = {
    'userID': userID,
  };

  var uri = Uri.http(API.IP, "/purchases" ,queryParameters);
  print(uri);

  var response = await http.get(uri, headers: {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json',
  });
  //var response = await http.post(API.GET_USERINFO, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    print(response.body);

    var result = json.decode(response.body);
    if(result.length > 0) {
      for(int i = 0; i < result.length; i++){
        UserInfo userInfoItem = UserInfo.fromJson(result[i]);
        res.add(userInfoItem);
      }
      print(res);


      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder:
          (BuildContext context) => HomeScreen(userInfoList: res,))
          ,(Route<dynamic> route) => false);
      return res;
    }else{
      return Future.error('loginFail');
    }
  }else if(response.statusCode == 401){
    return Future.error('Auth fail');
  }else{
    return Future.error('loading fail');
  }
}
