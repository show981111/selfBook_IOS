import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/home_screen.dart';
import 'package:selfbookflutter/screen/register_screen.dart';
import 'package:selfbookflutter/screen/reset_password_screen.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:selfbookflutter/widget/show_dialog.dart';

final storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{
  TextEditingController idController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  List<UserInfo> userInfoList = new List<UserInfo>();

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('로그인'),
      ),
        resizeToAvoidBottomInset: false,
        body: Container(
        child : Center ( child : SingleChildScrollView(
          child : Column(//_isLoading ? Center(child: CircularProgressIndicator()) :
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//            Container(
//              height: 150.0,
//              width: 150.0,
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: AssetImage(
//                      'images/solviolin_logo.png'),
//                  fit: BoxFit.fill,
//                ),
//                shape: BoxShape.circle,
//              ),
//            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '아이디(이메일)',
                    hintText: 'selfBook@gmail.com'
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                obscureText : true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                  height: 45,
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: Text('로그인', style: TextStyle(fontSize: 15),),
                      color: Color.fromRGBO(96, 128, 104, 100),
                      textColor: Colors.white,
                      onPressed: () {
                        login(context, idController.text, passwordController.text)
                            .catchError((e) {
                          print("Got error: ${e}");     // Finally, callback fires.
                          if(e == 'loginFail'){
                            showMyDialog(context, '아이디와 비밀번호를 다시 확인해주세요!');
                          }else{
                            showMyDialog(context, '인터넷 연결을 확인해주세요!');
                          }
                        }).then((value) {
                          if(value != null && value.isNotEmpty)
                          {
                            storage.write(key: "jwt", value: value);

                            getUserInfo(context , idController.text).then((value){
                              if(value != null && value.isNotEmpty){
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
                                    (BuildContext context) => HomeScreen(userInfoList: value,)), (
                                    Route<dynamic> route) => false);
                              }
                            }).catchError((e){
                              print("error : " + e.toString() );
                              if(e == 'Access Denied'){
                                showMyDialog(context, '다시 로그인 해주세요!');
                              }else{
                                print("error here");
                                showMyDialog(context, '오류가 발생하였습니다!');
                              }
                            });
                          }
                        });
                        //print(e);
                      },
                    ),
                  )

              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                  height: 45,
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: Text('회원가입', style: TextStyle(fontSize: 15),),
                      color: Color.fromRGBO(96, 128, 104, 100),
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return RegisterScreen();
                            }
                        ));
                      },
                    ),
                  )

              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                  height: 45,
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: Text('비밀번호 재설정', style: TextStyle(fontSize: 15),),
                      color: Color.fromRGBO(96, 128, 104, 100),
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                              return ResetScreen();
                            }
                        ));
                      },
                    ),
                  )

              ),
            ),

          ],
        ),
      ),
      )
        )
    );
  }

}

Future<String> login(BuildContext context ,String userID, String password) async{

  Map data = {
    'userID' : userID,
    'userPassword' : password
  };
  var response = await http.post(API.POST_LOGIN, body: data);
  print(response.statusCode);
  print(response.body);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    return response.body;
  }else if(response.statusCode == 401){
    return Future.error('loginFail');
  }else {
    return Future.error('loading is fail');
  }
}

Future<List<UserInfo>> getUserInfo(BuildContext context ,String userID) async{
  String token = await jwtOrEmpty;
  List<UserInfo> res = new List<UserInfo>();

  var queryParameters = {
    'userID': userID,
  };

  var uri = Uri.http(API.IP, "/purchases" ,queryParameters);
  print(uri);

  var response = await http.get(uri, headers: {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json',
  });
  print(response.statusCode.toString() + ' ' + response.body.toString());

  if(response.statusCode == 200 && response.body.isNotEmpty){

    var result = json.decode(response.body);

    for(int i = 0; i < result.length; i++){
      UserInfo userInfoItem = UserInfo.fromJson(result[i]);
      res.add(userInfoItem);
    }
    return res;

  }else if(response.statusCode == 401){
    return Future.error('Access Denied');
  }else{
    return Future.error('loading fail');
  }
}

