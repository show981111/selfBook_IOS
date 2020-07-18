import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/home_screen.dart';
import 'dart:convert';

import 'package:selfbookflutter/widget/show_dialog.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen>{
  TextEditingController idController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  List<UserInfo> userInfoList = new List<UserInfo>();
  bool _isLoading = false;

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
                  controller: idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '아이디',
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
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
                        setState(() {
                          _isLoading = true;
                        });
                        login(context, idController.text, passwordController.text)
                            .catchError((e) {
                          print("Got error: ${e}");     // Finally, callback fires.
                          if(e == 'loginFail'){
                            showMyDialog(context, '아이디와 비밀번호를 다시 확인해주세요!');
                          }else{
                            showMyDialog(context, '인터넷 연결을 확인해주세요!');
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
                        setState(() {
                          _isLoading = true;
                        });
//                        login(context, idController.text, passwordController.text, _token)
//                            .catchError((e) {
//                          print("Got error: ${e}");     // Finally, callback fires.
//                          if(e == 'loginFail'){
//                            showMyDialog(context, '아이디와 비밀번호를 다시 확인해주세요!');
//                          }else{
//                            showMyDialog(context, '인터넷 연결을 확인해주세요!');
//                          }
//                        });
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
                      child: Text('비밀번호 재설정', style: TextStyle(fontSize: 15),),
                      color: Color.fromRGBO(96, 128, 104, 100),
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
//                        login(context, idController.text, passwordController.text, _token)
//                            .catchError((e) {
//                          print("Got error: ${e}");     // Finally, callback fires.
//                          if(e == 'loginFail'){
//                            showMyDialog(context, '아이디와 비밀번호를 다시 확인해주세요!');
//                          }else{
//                            showMyDialog(context, '인터넷 연결을 확인해주세요!');
//                          }
//                        });
                        //print(e);
                      },
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

Future<List<UserInfo>> login(BuildContext context ,String userID, String password) async{

  List<UserInfo> res = new List<UserInfo>();

  Map data = {
    'userID' : userID,
    'userPassword' : password
  };
  var response = await http.post(API.GET_USERINFO, body: data);
  print(userID + password);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    print(response.body);

    var result = json.decode(response.body);
    print('encoded res' + result.toString());
    if(result.length > 0) {
      for(int i = 0; i < result.length; i++){
        UserInfo userInfoItem = UserInfo.fromJson(result[i]);
        res.add(userInfoItem);
      }
      //res.addAll(result);
//      controller.animateTo(1);
      print('Login change page' + res.toString());
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
          (BuildContext context) => HomeScreen(userInfoList: res,)), (
          Route<dynamic> route) => false);
      return res;
    }else{
      return Future.error('loginFail');
    }
  }else{
    return Future.error('loading fail');
  }
}



//Future<Post> fetchPost() async {
//  final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');
//
//  if (response.statusCode == 200) {
//    // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
//    return Post.fromJson(json.decode(response.body));
//  } else {
//    // 만약 응답이 OK가 아니면, 에러를 던집니다.
//    throw Exception('Failed to load post');
//  }
//}
//
