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

class DetailList extends StatefulWidget{
  final List<Question> detailList;
  final UserInfo userInfo;
  DetailList(this.userInfo, this.detailList);
  _DetailList createState() => _DetailList();
}

class _DetailList extends State<DetailList>{
  //List<Question> questionList = widget.questionList;
  SlidableController slidableController = new SlidableController();
  int tappedIndex;
  List<TextEditingController> _answerTextControllerList = new List<TextEditingController>();
  List<String> _status = new List<String>();
  String _token;
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
    return ListView.builder(itemCount:widget.detailList.length ,itemBuilder: (context, index) {
      _status.add(widget.detailList[index].status);
      _answerTextControllerList.add(new TextEditingController(
          text: widget.detailList[index].answer != null &&  widget.detailList[index].answer.isNotEmpty &&  widget.detailList[index].answer != "null"
          ? widget.detailList[index].answer : ""));
      return Slidable(
        controller: slidableController,
        key: ValueKey(index),
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '스킵',
            color: Colors.grey.shade300,
            icon: Icons.arrow_right,
            closeOnTap: true,
            onTap: () {
              putUserAnswer(context ,widget.detailList[index].id,
                  'skipped', 'answer', _token).catchError((e) {
                if(e == 'upload fail'){
                  showMyDialog(context, '오류가 발생하였습니다. 다시한번 시도해주세요!');
                }else{
                  showMyDialog(context, '인터넷 연결을 확인해주세요!');
                }
              }).then((value) {
                if(value == 'success'){
                  Toast.show('성공적으로 업로드하였습니다!', context,duration : Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                  setState(() {
                    _answerTextControllerList[index].text = 'skipped';
                    _status[index] = "1";
                  });
                }
              });
            },
          )
        ],
        child: ListTile(
          //enabled: widget.questionList[index].status == "0" ? true : false,
          title: Container(
//            color: widget.questionList[index].status == "0" ? null : Colors.white12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(widget.detailList[index].name,
                  style: TextStyle(color: _status[index] == "0" ? Colors.white : Colors.white12,),),
                Visibility(
                  visible: tappedIndex == index ? true : false,
                  child : Padding(
                    padding: EdgeInsets.only(top: 5),
                    child :
//                    SizedBox(
//                      height : 45,
//                      child :
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _answerTextControllerList[index],
                        decoration: InputDecoration(
                          //isDense: true,
                          contentPadding:EdgeInsets.fromLTRB(10,0,10,0),
                          labelText: "답변",
                          //hintText: widget.detailList[index].hint,
                          helperText: 'EX) '+widget.detailList[index].hint,
                          helperMaxLines: 10,
                          suffixIcon: IconButton(icon: Icon(Icons.send),
                            onPressed: () {
                              if(_answerTextControllerList[index].text.isEmpty){
                                Toast.show('내용이 없습니다!', context,duration : Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                                return;
                              }
                              print(_answerTextControllerList[index].text);
                              putUserAnswer(context ,widget.detailList[index].id,
                                  _answerTextControllerList[index].text, 'answer', _token).catchError((e) {
                                  if(e == 'upload fail'){
                                    showMyDialog(context, '오류가 발생하였습니다. 다시한번 시도해주세요!');
                                  }else{
                                    showMyDialog(context, '인터넷 연결을 확인해주세요!');
                                  }
                              }).then((value) {
                                if(value == 'success'){
                                  Toast.show('성공적으로 업로드하였습니다!', context,duration : Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                                  setState(() {
                                    _status[index] = '1';
                                  });
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
                  ),
              //  ),
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.white30)
                        )
                    ),
                    width: double.infinity,
                    child: Center(
                      child: tappedIndex == index ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  onTap: () {
                    if(tappedIndex == index){
                      setState(() {
                        tappedIndex = null;
                      });
                    }else{
                      setState(() {
                        tappedIndex = index;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

}
