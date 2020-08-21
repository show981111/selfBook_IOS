import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/overview_screen.dart';
import 'package:selfbookflutter/widget/show_dialog.dart';

class SubmitDraft extends StatefulWidget{
  final UserInfo userInfo;
  SubmitDraft(this.userInfo);
  _SubmitDraft createState() => _SubmitDraft();
}

class _SubmitDraft extends State<SubmitDraft>{
  Dio dio = Dio();
  bool _isLoading ;
  String _downloadPercent;
  String _token;

  @override
  void initState() {
    _isLoading = false;
    _downloadPercent = '0';
    jwtOrEmpty.then((value){
      _token = value;
    });
    dio.interceptors.add(LogInterceptor());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
//              Expanded(
//                flex: 2,
//                child:
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: Text('원고 미리보기', style: TextStyle(fontSize: 15),),
                      color: Color.fromRGBO(96, 128, 104, 100),
                      textColor: Colors.white,
                      onPressed: () {
                        return Navigator.of(context).push(MaterialPageRoute<Null>(
                          //fullscreenDialog: true,
                            builder: (BuildContext context) {
                              return OverView(widget.userInfo);
                            }
                        ));
                        //Navigator.of(context).push(MaterialPageRoute())
                      },
                    ),
                  ),
               // ),
              ),
//              Expanded(
//                flex: 1,
//                child: Container(),
//              ),
//              Expanded(
//                flex: 2,
//                child:
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 15, 8, 0),
                  child: Container(
                    width: double.infinity,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: Text('원고 다운로드', style: TextStyle(fontSize: 15),),
                      color: Color.fromRGBO(96, 128, 104, 100),
                      textColor: Colors.white,
                      onPressed: () async {
                        _requestPermissions().then((value) async {
                          if(value == true){
                            Directory documents = await getApplicationDocumentsDirectory();
                            print(documents);
                            String docName = widget.userInfo.userName + '_' +widget.userInfo.userTemplateCode;
                            download2(dio,API.GET_DOWNLOADDOCX, documents.path+'/$docName.docx',
                                widget.userInfo.userTemplateCode, context, _token);

                          }
                        });
                        //Navigator.of(context).push(MaterialPageRoute())
                      },
                    ),
                  ),
               // ),
              ),
//              Expanded(
//                flex: 8,
//                child: Container(),
//              )
            ],
          ),
        ),
        Center(
            child: Visibility(
              visible: _isLoading == true ? true : false,
              child : AlertDialog(
                title: Text('다운로드 중...'),
                content: SingleChildScrollView(
                  child: Text(_downloadPercent + '% 완료' ),
                ),
                actions: _downloadPercent == '100' ? <Widget>[
                  FlatButton(
                    child: Text('확인'),
                    onPressed: () {
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                ] : null ,
              ),
            )
        )
      ],
    );
  }

  Future download2(Dio dio, String url, String savePath, String templateCode, BuildContext context, String token) async {
    try {
      //print("token dio " +token);
      int statusCode;

      var queryParameters = {
        'templateCode' : templateCode
      };

      Response response = await dio.get(
        url,
        queryParameters: queryParameters,
        onReceiveProgress:(received, total) {
          if (total != -1) {
            if(statusCode == 200) {
              setState(() {
                _isLoading = true;
                _downloadPercent = (received / total * 100).toStringAsFixed(0);
              });
              print((received / total * 100).toStringAsFixed(0) + "%");
            }
          }
        },
        //Received data with List<int>
        //data : FormData.fromMap(info),
        options: Options(
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json',
            },
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              statusCode = status;
              return status < 500;
            }),
      );


      print(response.headers);
      //if(response.data.toString())
      if(statusCode == 200) {
        File file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        //print(response.data);
        await raf.close().then((value){

        });
      }else if(statusCode == 401){
        setState(() {
          _isLoading = false;
        });
        showMyDialog(context, '오류가 발생했습니다! 다시 로그인해주세요!');
      }else{
        setState(() {
          _isLoading = false;
        });
        showMyDialog(context, '원고를 먼저 생성해주세요!\n방법 : 원고 미리보기 -> 오른쪽 아래 버튼 클릭');
      }
    } catch (e) {
      print('error');
      print(e);
    }
  }

}

Future<bool> _requestPermissions() async {
  var permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  print("permission~");
  if (permission != PermissionStatus.granted) {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  }

  return permission == PermissionStatus.granted;
}