import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:selfbookflutter/fetchData/fetch_question.dart';
import 'package:selfbookflutter/model/question.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/widget/basic_draft_info.dart';
import 'package:selfbookflutter/widget/chapter_grid.dart';

class DelegateListScreen extends StatefulWidget {
  final UserInfo userInfo;
  final String chapterCode;
  DelegateListScreen(this.userInfo, this.chapterCode);
  _DelegateListScreen createState() => _DelegateListScreen();
}

class _DelegateListScreen extends State<DelegateListScreen>{
  Map _data;
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
          title: Text('내 원고'),
        ),
        body: FutureBuilder(
          future: getQuestionList(_data, 'delegate'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false){
              return Center(
                child:CircularProgressIndicator()
              );
            }else if(snapshot.hasError) {
              return Center(
                  child: Text("에러가 발생하였습니다!")
              );
            }else{
              delegateList = snapshot.data;
              return makeSlidableList(slidableController, delegateList);
            }
          }
        )

    );
  }

}

Widget makeSlidableList(SlidableController slidableController, List<Question> delegateList){
  bool loadMore = false;
  return ListView.builder(itemCount:delegateList.length ,itemBuilder: (context, index) {
    return Slidable(
      controller: slidableController,
      key: ValueKey(index),
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '더보기',
          color: Colors.grey.shade300,
          icon: Icons.more_horiz,
          closeOnTap: true,
          onTap: () {

          },
        ),
        IconSlideAction(
          caption: '스킵',
          color: Colors.grey.shade300,
          icon: Icons.arrow_right,
          closeOnTap: true,
          onTap: () {

          },
        )
      ],
      child: ListTile(
        title: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(delegateList[index].name),
//              Padding(
//                padding: EdgeInsets.all(3),
//                child: Text(delegateList[index].name),
//              ),
//              TextField(
//
//              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white30)
                    )
                  ),
                  width: double.infinity,
                  child: Center(
                    child: Icon(Icons.arrow_drop_down),
                  ),
                ),
                onTap: () {

                },
             ),
            ],
          ),
        ),
      ),
    );
  });
}