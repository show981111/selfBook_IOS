import 'package:flutter/material.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'dart:ui';
import 'package:selfbookflutter/model/template.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/widget/show_dialog.dart';
import 'package:selfbookflutter/widget/show_purchase_dialog.dart';

class TemplateInfoScreen extends StatefulWidget {
  final UserInfo userInfo;
  final TemplateInfo templateInfo;
  TemplateInfoScreen({this.templateInfo, this.userInfo});

  _TemplateInfoScreen createState() => _TemplateInfoScreen();
}

class _TemplateInfoScreen extends State<TemplateInfoScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(
//                          var queryParameters = {
//                          'coverName' : userInfoList[i].userBookCover
//                          };
//                          var uri = Uri.http(API.IP, '/getCover',queryParameters);
                          image: NetworkImage(Uri.http(API.IP, '/getCover',{
                            'coverName' : widget.templateInfo.bookCover
                          }).toString()),
                          fit: BoxFit.cover,
                        )
                    ),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black.withOpacity(0.1),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 45, 0, 10),
                                  child: Image.network(Uri.http(API.IP, '/getCover',{
                                    'coverName' : widget.templateInfo.bookCover
                                  }).toString()),
                                  height: 300,
                                ),
                                Container(
                                  padding: EdgeInsets.all(7),
                                  child: Text(
                                    widget.templateInfo.templateName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(7),
                                  child: FlatButton(
                                    onPressed: () {
                                      if(widget.userInfo == null ){
                                        showMyDialog(context, '먼저 로그인을 해주세요!');
                                        return;
                                      }
                                      showPurchaseDialog(context,widget.templateInfo.templateName+'를 구매하시겠습니까?\n가격 ' + widget.templateInfo.bookPrice + '원'
                                          ,widget.templateInfo.templateCode);
                                    },
                                    color: Colors.white70,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.add_circle, color: Colors.black),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text('구매', style : TextStyle(color: Colors.black)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(widget.templateInfo.templateIntro),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.centerLeft,
                                  child: Text('저자 : ' + widget.templateInfo.author+ '\n출판일 :'+widget.templateInfo.madeDate,
                                    style: TextStyle(color:  Colors.white60, fontSize: 12 ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

