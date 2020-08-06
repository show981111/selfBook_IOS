import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:selfbookflutter/fetchData/fetch_question.dart';
import 'package:selfbookflutter/model/question.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/widget/basic_draft_info.dart';
import 'package:selfbookflutter/widget/chapter_grid.dart';
import 'package:selfbookflutter/widget/detail_list.dart';
import 'package:selfbookflutter/widget/question_list.dart';

class DetailScreen extends StatefulWidget {
  final UserInfo userInfo;
  final String delegateCode;
  DetailScreen(this.userInfo, this.delegateCode);
  _DetailScreen createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen>{
  var _data;
  List<Question> detailList;
  @override
  void initState() {
    _data = {
      'delegateCode' : widget.delegateCode
    };
    print(widget.delegateCode);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('더보기'),
        ),
        body: FutureBuilder(
          future: getQuestionList(_data, 'detail'),
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
              detailList = snapshot.data;
              return DetailList(widget.userInfo ,detailList);
            }
          }
        )

    );
  }

}
