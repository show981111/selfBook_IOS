import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:selfbookflutter/fetchData/fetch_question.dart';
import 'package:selfbookflutter/model/question.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/widget/basic_draft_info.dart';
import 'package:selfbookflutter/widget/chapter_grid.dart';
import 'package:selfbookflutter/widget/question_list.dart';

class DelegateListScreen extends StatefulWidget {
  final UserInfo userInfo;
  final String chapterCode;
  final String title;
  DelegateListScreen(this.userInfo, this.chapterCode, this.title);
  _DelegateListScreen createState() => _DelegateListScreen();
}

class _DelegateListScreen extends State<DelegateListScreen>{
  var _data;
  List<Question> delegateList;
  final SlidableController slidableController = SlidableController();
  @override
  void initState() {
    _data = {
      'userID' : widget.userInfo.userID,
      'chapterCode' : widget.chapterCode
    };
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: getQuestionList(_data, 'delegate'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false && !snapshot.hasError){
              return Center(
                child:CircularProgressIndicator()
              );
            }else if(snapshot.hasError) {
              print(snapshot.error);
              return Center(
                  child: Text("에러가 발생하였습니다!")
              );
            }else{
              delegateList = snapshot.data;
              return QuestionList(widget.userInfo ,delegateList);
            }
          }
        )

    );
  }

}
