
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/putData/put_user_answer.dart';
import 'package:selfbookflutter/screen/overview_screen.dart';
import 'package:selfbookflutter/widget/show_dialog.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';


class BasicDraftInfo extends StatefulWidget {
  final UserInfo userInfo;
  BasicDraftInfo(this.userInfo);

  _BasicDraftInfoState createState() => _BasicDraftInfoState();
}

class _BasicDraftInfoState extends State<BasicDraftInfo>{

  TextEditingController titleTextController = new TextEditingController();
  TextEditingController authorTextController = new TextEditingController();
  TextEditingController publishDateTextController = new TextEditingController();
  Dio dio = Dio();
  bool _isLoading ;
  String _downloadPercent;
  String _token;

  @override
  void initState() {
    _isLoading = false;
    _downloadPercent = '0';
    if(widget.userInfo != null){
      if(widget.userInfo.userBookName.isNotEmpty){
        titleTextController.text = widget.userInfo.userBookName;
      }
      if(widget.userInfo.userName.isNotEmpty){
        authorTextController.text = widget.userInfo.userName;
      }
      if(widget.userInfo.userBookPublishDate.isNotEmpty){
        publishDateTextController.text = widget.userInfo.userBookPublishDate;
      }
    }
    jwtOrEmpty.then((value){
      _token = value;
    });
    dio.interceptors.add(LogInterceptor());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleTextController.dispose();
    authorTextController.dispose();
    publishDateTextController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
//              Expanded(
//                flex: 3,
//                  child:
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: titleTextController,
                      decoration: InputDecoration(
                        labelText: "책 제목",
                        hintText: "쉼표,",
                        suffixIcon: IconButton(icon: Icon(Icons.send),
                          onPressed: () {
                            FocusManager.instance.primaryFocus.unfocus();
                            putUserAnswer(context ,widget.userInfo.userTemplateCode,
                                titleTextController.text , 'setBookTitle', _token).catchError((e) {
                              print("Got error: ${e}");
                              if(e == 'upload fail'){
                                showMyDialog(context, '오류가 발생하였습니다!');
                              }else if(e == 'Auth fail'){
                                showMyDialog(context, '오류가 발생했습니다! 다시 로그인해주세요!');
                              }else {
                                showMyDialog(context, '인터넷 연결을 확인해주세요!');
                              }
                            })
                            .then((value) {
                              if(value == 'success'){
                                Toast.show('성공적으로 업로드하습니다!', context,duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                              }else if(value == 'fail'){
                                Toast.show('이미 설정된 제목입니다.', context,duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                              }
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                //  )
                ),
//              Expanded(
//                  flex: 3,
//                  child:
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      enabled: false,
                      controller: authorTextController,
                      decoration: InputDecoration(
                        labelText: "글쓴이",
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                //  )
              ),
//              Expanded(
//                  flex: 3,
//                  child:
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      enabled: false,
                      controller: publishDateTextController,
                      decoration: InputDecoration(
                        labelText: publishDateTextController.text.isEmpty ? null : "출판일",
                        hintText: "출판일(최종 제출일로 자동 지정)",
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: Colors.white),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                 // )
              ),
//              Expanded(
//                flex: 2,
//                child: Padding(
//                  padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
//                  child: Container(
//                    width: double.infinity,
//                    child: FlatButton(
//                      shape: new RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(30.0),
//                      ),
//                      child: Text('원고 미리보기', style: TextStyle(fontSize: 15),),
//                      color: Color.fromRGBO(96, 128, 104, 100),
//                      textColor: Colors.white,
//                      onPressed: () {
//                        return Navigator.of(context).push(MaterialPageRoute<Null>(
//                          //fullscreenDialog: true,
//                            builder: (BuildContext context) {
//                              return OverView(widget.userInfo);
//                            }
//                        ));
//                        //Navigator.of(context).push(MaterialPageRoute())
//                      },
//                    ),
//                  ),
//                ),
//              ),
//              Expanded(
//                flex: 1,
//                child: Container(),
//              ),
//              Expanded(
//                flex: 2,
//                child: Padding(
//                  padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
//                  child: Container(
//                    width: double.infinity,
//                    child: FlatButton(
//                      shape: new RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(30.0),
//                      ),
//                      child: Text('원고 다운로드', style: TextStyle(fontSize: 15),),
//                      color: Color.fromRGBO(96, 128, 104, 100),
//                      textColor: Colors.white,
//                      onPressed: () async {
//                        _requestPermissions().then((value) async {
//                          if(value == true){
//                            Directory documents = await getApplicationDocumentsDirectory();
//                            print(documents);
//                            String docName = widget.userInfo.userName + '_' +widget.userInfo.userTemplateCode;
//                            download2(dio,API.GET_DOWNLOADDOCX, documents.path+'/$docName.docx',
//                                widget.userInfo.userTemplateCode, context, _token);
//
//                          }
//                        });
//                        //Navigator.of(context).push(MaterialPageRoute())
//                      },
//                    ),
//                  ),
//                ),
//              ),
//              Expanded(
//                flex: 8,
//                child: Container(),
//              )
                  //Container
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


}




