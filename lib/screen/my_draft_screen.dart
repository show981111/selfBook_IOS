import 'package:flutter/material.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/widget/basic_draft_info.dart';
import 'package:selfbookflutter/widget/chapter_grid.dart';

class MyDraftScreen extends StatefulWidget {
  final UserInfo userInfo;

  MyDraftScreen(this.userInfo);
  _MyDraftScreen createState() => _MyDraftScreen();
}

class _MyDraftScreen extends State<MyDraftScreen>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(child : Text('기본정보')),
              Tab(child : Text('목차')),
            ],
          ),
          title: Text('내 원고'),
        ),
        body: TabBarView(
          children: <Widget>[
              BasicDraftInfo(widget.userInfo),
              ChapterGrid(widget.userInfo)
//            PastResult(user: widget.user),
//            CurrentResult(user : widget.user),
          ],
        ),
      ),
    );
  }

}