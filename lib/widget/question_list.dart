import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:selfbookflutter/fetchData/fetch_question.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/question.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/putData/put_user_answer.dart';
import 'package:selfbookflutter/putData/skip_delegate.dart';
import 'package:selfbookflutter/widget/show_dialog.dart';
import 'package:toast/toast.dart';

import 'detail_list.dart';

class QuestionList extends StatefulWidget{
  final List<Question> questionList;
  final UserInfo userInfo;
  QuestionList(this.userInfo, this.questionList);
  _QuestionList createState() => _QuestionList();
}

class _QuestionList extends State<QuestionList>{
  //List<Question> questionList = widget.questionList;
  SlidableController slidableController = new SlidableController();
  int tappedIndex;
  List<int> openedTileList = new List<int>();
  List<TextEditingController> _answerTextControllerList = new List<TextEditingController>();
  List<String> _status = new List<String>();
  String _token;

  List<Question> detailList = new List<Question>();
  @override
  void dispose() {
    for(int i = 0; i < _answerTextControllerList.length; i++)
    {
      _answerTextControllerList[i].dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    jwtOrEmpty.then((value){
      _token = value;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount:widget.questionList.length ,itemBuilder: (context, index) {

      _status.add(widget.questionList[index].status);
      _answerTextControllerList.add(new TextEditingController(
          text: widget.questionList[index].answer != null &&  widget.questionList[index].answer.isNotEmpty &&  widget.questionList[index].answer != "null"
          ? widget.questionList[index].answer : ""));
      return Slidable(
        controller: slidableController,
        key: ValueKey(index),
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
//          IconSlideAction(
//            caption: '더보기',
//            color: Colors.grey.shade300,
//            icon: Icons.more_horiz,
//            closeOnTap: true,
//            onTap: () {
//              Navigator.of(context).push(MaterialPageRoute<Null>(
//                //fullscreenDialog: true,
//                  builder: (BuildContext context) {
//                    return DetailScreen(
//                        widget.userInfo, widget.questionList[index].id);
//                  }
//              ));
//            }
//          ),
          IconSlideAction(
            caption: '삭제',
            color: Colors.red,
            icon: Icons.delete_outline,
            closeOnTap: true,
            onTap: () {
              skipDelegate(context ,widget.questionList[index].id)
                  .then((value) {
                if(value == 'success'){
                  Toast.show('성공적으로 업로드하였습니다!', context,duration : Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                  setState(() {
                    _answerTextControllerList[index].text = "skipped";
                    _status[index] = "1";
                  });
                }
              }).catchError((e) {
                if(e == 'upload fail'){
                  showMyDialog(context, '오류가 발생하였습니다. 다시한번 시도해주세요!');
                }else if(e == 'Auth fail'){
                  showMyDialog(context, '인증이 만료되었습니다. 다시 로그인해주세요!');
                }else{
                  showMyDialog(context, '인터넷 연결을 확인해주세요!');
                }
              });
            },
          )
        ],
        child: ExpansionTile(
//          trailing: SizedBox.shrink(),
//          leading: IconButton(
////            icon: tappedIndex == index ? Icon(Icons.close) : Icon(Icons.add),
//              icon: openedTileList.contains(index) ? Icon(Icons.close) : Icon(Icons.add),
//          ),
//          leading: IconButton(
//            icon: Icon(Icons.add),
//            onPressed: () {
//              var _data = {
//                'delegateCode' :widget.questionList[index].id
//              };
//
//              //DetailList(widget.userInfo ,detailList)
//            },
//          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(4,3,4,0),
              child : TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _answerTextControllerList[index],
                decoration: InputDecoration(
                  //isDense: true,
                  contentPadding:EdgeInsets.fromLTRB(5,0,5,0),
                  labelText: "답변",
                  //hintMaxLines: 30,
                  helperText: 'EX) '+widget.questionList[index].hint,
                  helperMaxLines: 10,
                  suffixIcon: IconButton(icon: Icon(Icons.send),
                    onPressed: () {
                      FocusManager.instance.primaryFocus.unfocus();
                      if(_answerTextControllerList[index].text.isEmpty){
                        Toast.show('내용이 없습니다!', context,duration : Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                        return;
                      }
                      print(_answerTextControllerList[index].text);
                      putUserAnswer(context ,widget.questionList[index].id,
                          _answerTextControllerList[index].text, 'answer', _token).catchError((e) {
                        if(e == 'upload fail'){
                          showMyDialog(context, '오류가 발생하였습니다. 다시한번 시도해주세요!');
                        }else{
                          showMyDialog(context, '인터넷 연결을 확인해주세요!');
                        }
                      }).then((value) {
                        if(value == 'success'){
                          Toast.show('성공적으로 업로드하였습니다!', context,duration : Toast.LENGTH_SHORT,gravity: Toast.CENTER);
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
            ),
            FutureBuilder(
                future: getQuestionList({'delegateCode' :widget.questionList[index].id}, 'detail'),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData == false && !snapshot.hasError){
                    return Center(
                        child:CircularProgressIndicator()
                    );
                  }else if(snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                        child: Text('인증서에 문제가 발견되었습니다! 다시 로그인해주세요!')
                    );
                  }else{
                    List<Question> detailList = snapshot.data;
                    return DetailList(widget.userInfo ,detailList);
                  }
                }
            )
          ],
          //enabled: widget.questionList[index].status == "0" ? true : false,
          title: Container(
//            color: widget.questionList[index].status == "0" ? null : Colors.white12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: c,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.questionList[index].name,
                    style: TextStyle(color: _status[index] == "0" ? Colors.white : Colors.white12,),),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

}
