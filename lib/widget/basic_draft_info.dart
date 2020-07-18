import 'package:flutter/material.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/putData/putUserAnswer.dart';
import 'package:selfbookflutter/widget/show_dialog.dart';
import 'package:toast/toast.dart';

class BasicDraftInfo extends StatefulWidget {
  UserInfo userInfo;
  BasicDraftInfo(this.userInfo);

  _BasicDraftInfoState createState() => _BasicDraftInfoState();
}

class _BasicDraftInfoState extends State<BasicDraftInfo>{

  TextEditingController titleTextController = new TextEditingController();
  TextEditingController authorTextController = new TextEditingController();
  TextEditingController publishDateTextController = new TextEditingController();

  @override
  void initState() {
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: titleTextController,
                    decoration: InputDecoration(
                      labelText: "책 제목",
                      hintText: "쉼표,",
                      suffixIcon: IconButton(icon: Icon(Icons.send),
                        onPressed: () {
                          putUserAnswer(context ,widget.userInfo.userTemplateCode, widget.userInfo.userID,
                              titleTextController.text , 'setBookTitle').catchError((e) {
                            print("Got error: ${e}");
                            if(e == 'upload fail'){
                              showMyDialog(context, '오류가 발생하였습니다!');
                            }else{
                              showMyDialog(context, '인터넷 연결을 확인해주세요!');
                            }
                          })
                          .then((value) {
                            if(value == 'success'){
                              Toast.show('성공적으로 업로드하습니다!', context,duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                            }else{
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
                )
              ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    enabled: false,
                    controller: authorTextController,
                    decoration: InputDecoration(
                      labelText: "글쓴이",
                      hintText: "미정",
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1,color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                )
            ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    enabled: false,
                    controller: publishDateTextController,
                    decoration: InputDecoration(
                      labelText: "출판일",
                      hintText: "미정",
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1,color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                )
            ),
            Expanded(
              flex: 7,
              child: Container(),
            )
                //Container
          ],
      ),
    );
  }

}
