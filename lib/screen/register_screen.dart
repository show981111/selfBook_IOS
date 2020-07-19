import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/home_screen.dart';
import 'package:selfbookflutter/screen/login_screen.dart';
import 'dart:convert';

import 'package:selfbookflutter/widget/show_dialog.dart';

class RegisterScreen extends StatefulWidget {
  _RegisterScreen createState() => _RegisterScreen();

}

class _RegisterScreen extends State<RegisterScreen>{
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController pwCheckController = new TextEditingController();

  List<UserInfo> userInfoList = new List<UserInfo>();
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    pwCheckController.dispose();
  }
  @override
  void initState() {
    super.initState();
    regex = new RegExp(pattern);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
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
              padding: EdgeInsets.fromLTRB(8, 30, 8, 8),
              child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '이름',
                      hintText: '홍길동',
                      suffixIcon: Icon(Icons.account_box)
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '이메일',
                      hintText: 'selfBook@gmail.com',
                      suffixIcon: Icon(Icons.email)
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
                  suffixIcon: Icon(Icons.vpn_key)
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                obscureText : true,
                controller: pwCheckController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호 확인',
                  suffixIcon: Icon(Icons.vpn_key)
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
                      child: Text('회원가입', style: TextStyle(fontSize: 15),),
                      color: Color.fromRGBO(96, 128, 104, 100),
                      textColor: Colors.white,
                      onPressed: () {
                        if(emailController.text != null && emailController.text.isNotEmpty &&
                            nameController.text != null && nameController.text.isNotEmpty &&
                            passwordController.text != null && passwordController.text.isNotEmpty &&
                            pwCheckController.text != null && pwCheckController.text.isNotEmpty)
                          {
                            if(passwordController.text == pwCheckController.text){
                              if(regex.hasMatch(emailController.text)){
                                print('go');
                                register(context,emailController.text,nameController.text,passwordController.text)
                                    .catchError((e) {
                                      if(e == 'upload fail'){
                                        showMyDialog(context, '오류가 발생하였습니다! 다시한번 시도해주세요!');
                                      }else{
                                        showMyDialog(context, '오류가 발생하였습니다! 인터넷연결을 확인해주세요!');
                                      }
                                }).then((value){
                                  if(value == 'success'){
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Text(
                                            '성공적으로 등록되었습니다!'
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('확인'),
                                          onPressed: () {
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
                                                (BuildContext context) => LoginScreen()), (
                                                Route<dynamic> route) => false);
                                          },
                                        ),
                                      ],
                                    );
                                  }else{
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Text(
                                            '오류가 발생하였습니다! 다시한번 시도해주세요!'
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('확인'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                });
                              }else{
                                showMyDialog(context, '이메일 형식이 올바르지 않습니다!');
                              }
                            }else{
                              showMyDialog(context, '비밀번호 확인이 일치하지 않습니다!');
                            }
                          }else{
                          showMyDialog(context, '모든 정보를 다 채워주세요!');
                        }
                      }
                    ),
                  )

              ),
            ),
          ],
        ),
      ),
    );
  }

}

Future<String> register(BuildContext context ,String userID, String userName, String userPassword) async{

  Map data = {
    'userID' : userID,
    'userPassword' : userPassword,
    'userName' : userName,
  };
  var response = await http.post(API.POST_REGISTER, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body;
    print(result);
    if(result != null ){
      return result;
    }else{
      return Future.error('upload fail');
    }
  }else{
    return Future.error('connection fail');
  }
}