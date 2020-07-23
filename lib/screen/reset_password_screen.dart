import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/home_screen.dart';
import 'package:selfbookflutter/screen/register_screen.dart';
import 'dart:convert';

import 'package:selfbookflutter/widget/show_dialog.dart';

class ResetScreen extends StatefulWidget {
  _ResetScreenState createState() => _ResetScreenState();

}

class _ResetScreenState extends State<ResetScreen>{
  TextEditingController idController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordCheckController = new TextEditingController();
  TextEditingController verificationController = new TextEditingController();

  int _isValidUser = 0;
  int _isVerified = 0;

  String _verificationCode;

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    verificationController.dispose();
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
        title: Text('비밀번호 재설정'),
      ),
      body: Container(
        child : Column(//_isLoading ? Center(child: CircularProgressIndicator()) :
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.fromLTRB(8, 5, 8, 8),
              child: TextField(
                  controller: idController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '아이디(이메일)',
                      hintText: 'selfBook@gmail.com',
                      suffixIcon: IconButton(icon: Icon(Icons.send),
                        onPressed: () {
                          //send email Auth Code
                          sendAuth(context, idController.text).then((value) {
                            String response = value;
                            print(response + " vas");
                            if(response != null && response.length > 7 && response.substring(0,7) =='success'){
                              showMyDialog(context, '인증번호를 보냈습니다! 메일이 보이지 않는다면 스팸메일함을 확인해주세요!');
                              setState(() {
                                _isValidUser = 1;
                                _verificationCode = response.substring(7);
                              });
                            }else if(response == 'none'){
                              showMyDialog(context, '등록되지 않은 유저입니다!');
                            }else{
                              print(response + "vasdsa");
                              showMyDialog(context, '오류가 발생하였습니다! 다시한번 시도해주세요!!');
                            }
                          }).catchError((e) {
                            showMyDialog(context, '오류가 발생하였습니다! 다시한번 시도해주세요!!!!!');
                          });

                        },
                      )
                  )
              ),
            ),
            Visibility(
              visible: _isValidUser == 1 ? true : false,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: verificationController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '인증번호 확인',
                      suffixIcon: IconButton(icon: Icon(Icons.send),
                        onPressed: () {
                          String message = '';
                          if(verificationController.text == _verificationCode){
                            message = '인증이 완료되었습니다!';
                            setState(() {
                              _isVerified = 1;
                            });
                          }else{
                            message = '인증번호가 일치하지 않습니다.';
                          }
                          showMyDialog(context, message);

                        },
                      )
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isVerified == 1 ? true : false,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  obscureText : true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '새로운 비밀번호',

                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isVerified == 1 ? true : false,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  obscureText : true,
                  controller: passwordCheckController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '비밀번호 확인',

                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isVerified == 1 ? true : false,
              child: Padding(
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
                          if(passwordCheckController.text == passwordController.text){

                          }

                        },
                      ),
                    )

                ),
              ),

            )
          ],
        ),
      ),
    );
  }

}

Future<String> sendAuth(BuildContext context ,String userID) async{

  Map data = {
    'userID' : userID
  };
  var response = await http.post(API.SEND_AUTH, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body.toString();
    return result;
  }else{
    print('error');
    return Future.error('loading fail');
  }
}

Future<String> resetPW(BuildContext context ,String userID, String password) async{

  Map data = {
    'userID' : userID
  };
  var response = await http.post(API.SEND_AUTH, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body.toString();
    return result;
  }else{
    print('error');
    return Future.error('loading fail');
  }
}
