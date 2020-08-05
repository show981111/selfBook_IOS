import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfbookflutter/Api/Api.dart';

import 'package:selfbookflutter/widget/show_dialog.dart';
import 'package:toast/toast.dart';

import 'login_screen.dart';

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
                  enabled: _isValidUser == 0 ? true : false,
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
                            if(response =='success'){
                              showMyDialog(context, '인증번호를 보냈습니다! 메일이 보이지 않는다면 스팸메일함을 확인해주세요! \n인증번호의 유효기간은 3분입니다!');
                              setState(() {
                                _isValidUser = 1;
                              });
                            }else if(response == 'none'){
                              showMyDialog(context, '등록되지 않은 유저입니다!');
                            }else{
                              showMyDialog(context, '오류가 발생하였습니다! 다시한번 시도해주세요!!');
                            }
                          }).catchError((e) {
                            print(e);
                            showMyDialog(context, '오류가 발생하였습니다! 다시한번 시도해주세요!');
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
                  enabled: _isVerified == 0 ? true : false,
                  controller: verificationController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '인증번호 확인',
                      suffixIcon: IconButton(icon: Icon(Icons.send),
                        onPressed: () {
                          checkVerificationCode(context, idController.text, verificationController.text).then((value) {
                            print(value);
                            if(value == 'success'){
                              showMyDialog(context, '성공적으로 인증하였습니다!');
                              setState(() {
                                _isVerified = 1;
                              });
                            }else if(value == 'late'){
                              showMyDialog(context, '인증 유효기간을 초과하였습니다!(3분)');
                            }else{
                              showMyDialog(context, '인증번호가 일치하지 않습니다!');
                            }
                          }).catchError((e){showMyDialog(context, '오류가 발생하였습니다! 다시 시도해주세요!');;});


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
                          print(passwordCheckController.text);
                          print(passwordController.text);
                          if(passwordCheckController.text == passwordController.text){
                            resetPW(context, idController.text, passwordController.text).then((value) {
                              if(value == 'success'){
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
                                    (BuildContext context) => LoginScreen()), (
                                    Route<dynamic> route) => false);
                                Toast.show('성공적으로 비밀번호를 변경하였습니다!', context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                              }else{
                                showMyDialog(context, '오류가 발생하였습니다!');
                              }
                            }).catchError((e) {
                              showMyDialog(context, '오류가 발생하였습니다!');
                            });
                          }else{
                            showMyDialog(context, '비밀번호 확인이 일치하지 않습니다!');
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
  print(response.body);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body.toString();
    return result;
  }else{
    return Future.error('loading fail');
  }
}

Future<String> resetPW(BuildContext context ,String userID, String userPassword) async{

  Map data = {
    'userID' : userID,
    'userPassword' : userPassword
  };
  var response = await http.put(API.POST_RESETPW, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body.toString();
    return result;
  }else{
    print('error');
    return Future.error('loading fail');
  }
}

Future<String> checkVerificationCode(BuildContext context ,String userID, String code) async{

  Map data = {
    'userID' : userID,
    'verificationCode' : code
  };
  var response = await http.post(API.CHECKVERIFICATIONCODE, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body.toString();
    return result;
  }else{
    print('error');
    return Future.error('loading fail');
  }
}

