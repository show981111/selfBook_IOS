import 'package:flutter/material.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/widget/basic_draft_info.dart';
import 'package:selfbookflutter/widget/chapter_grid.dart';
import 'package:selfbookflutter/widget/submit_draft.dart';

class MyDraftScreen extends StatefulWidget {
  final UserInfo userInfo;

  MyDraftScreen(this.userInfo);
  _MyDraftScreen createState() => _MyDraftScreen();
}

class _MyDraftScreen extends State<MyDraftScreen>{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,//make view intact when keyboard appears
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(child : Text('기본정보')) ,
              Tab(child : Text('목차')) ,
              Tab(child : Text('제출')) ,
            ],
          ),
          title: Text('내 원고'),
        ),
        body: TabBarView(
          children: <Widget>[
              BasicDraftInfo(widget.userInfo),
              ChapterGrid(widget.userInfo),
              SubmitDraft(widget.userInfo),
//            PastResult(user: widget.user),
//            CurrentResult(user : widget.user),
          ],
        ),
      ),
    );
  }

}