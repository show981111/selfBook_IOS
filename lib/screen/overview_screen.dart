import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:http/http.dart' as http;
import 'package:selfbookflutter/widget/show_dialog.dart';


class OverView extends StatelessWidget{
  final UserInfo userInfo;
  OverView(this.userInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('원고 미리보기'),
      ),
      body :
          FutureBuilder(
          future: getOverView( userInfo.userTemplateCode),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false && !snapshot.hasError){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              return Container(
                child: Center(
                  child: Text('오류가 발생하였습니다! 다시 로그인해주세요!'),
                )
              );
            }else{
              var resultContent = snapshot.data;
              if(resultContent != null){
                return SingleChildScrollView(
                  child: Html(
                    data: resultContent,
                  ),
                );
//                return Html(
//                  data: resultContent,
//                );
//                return WebviewScaffold(
//                    url: new Uri.dataFromString('<html>'+resultContent+'</html>', mimeType: 'text/html').toString());
              }else{
                return Container(
                    child: Center(
                      child: Text('오류가 발생하였습니다!'),
                    )
                );
              }
            }
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           return showDialog<String>(
              context: context,
              barrierDismissible: true, // user dont have button!
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Text(
                        '원고를 생성하시겠습니까?'
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
                        Navigator.of(context).pop();
                        makeDocx(userInfo.userTemplateCode).then((value) {
                          if(value == 'fail'){
                            showMyDialog(context, '원고생성에 실패하였습니다!');
                          }else if(value == 'success'){
                            showMyDialog(context, '성공적으로 원고를 생성하였습니다!');
                          }else{
                            showMyDialog(context, '원고를 생성하기 위해서는 모든 질문에 답변을 해주세요! \nQ : $value');
                          }
                        }).catchError((e) {
                          print(e.toString());
                          showMyDialog(context, '오류가 발생하였습니다! 인터넷 연결을 확인 후 다시한번 시도해주세요!');
                        });
                      },
                    ),
                  ],
                );
              },
            );


        },
        child: Icon(Icons.note_add),
        backgroundColor: Colors.white70,
      ),
    );
  }

}

Future<String> getOverView(String templateCode) async {

  final String token = await jwtOrEmpty;

  var queryParameters = {
    'templateCode' : templateCode,
  };

  var uri = Uri.http(API.IP, "/overview" ,queryParameters);
  print(uri);

  var response = await http.get(uri, headers: {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json',
  });
  //print(response.statusCode);
  if (response.statusCode == 200 && response.body.isNotEmpty) {
    var result = response.body;
    //print(result);
    if (result != null) {
      return result;
    } else {
      return Future.error('parse fail');
    }
  } else if (response.statusCode == 401) {
    return Future.error('Auth fail');
  } else {
    return Future.error('connection fail');
  }
}

Future<String> makeDocx( String templateCode) async {
//  $userID = $_POST['userID'];
//  $templateCode = $_POST['templateCode'];
  final String token = await jwtOrEmpty;
  //print(token);
  Map data = {
    'templateCode' : templateCode,
  };

  var response = await http.put(API.PUT_MAKEDOCX, body: data, headers: {
    'Authorization': 'Bearer ' + token
  });
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = response.body;
    //print(result);
    if(result != null ){
      return result;
    }else{
      return Future.error('parse fail');
    }
  }else{
    return Future.error('connection fail');
  }
}