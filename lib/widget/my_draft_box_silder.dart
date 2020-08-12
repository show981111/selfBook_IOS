import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/login_screen.dart';
import 'package:selfbookflutter/screen/my_draft_screen.dart';

class BoxSlider extends StatefulWidget {

  List<UserInfo> userInfoList;
  BoxSlider({this.userInfoList});
  _BoxSlider createState() => _BoxSlider();


}

class _BoxSlider extends State<BoxSlider>{

  void setUserInfoList(List<UserInfo> userInfoList){
    setState(() {
      widget.userInfoList = userInfoList;
    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('내가 구매한 원고', style: TextStyle(fontWeight: FontWeight.bold),),
          setSlider(context, widget.userInfoList),
          widget.userInfoList != null && widget.userInfoList.isNotEmpty ?
              Padding(
                padding: EdgeInsets.all(10),
                child : Center(
                  child: InkWell(
                    child: Text('탭하여 로그아웃'),
                    onTap: () async {
                      await storage.delete(key: "jwt");
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:
                          (BuildContext context) => LoginScreen()), (
                          Route<dynamic> route) => false);
                    } ,
                  ),
                )
              )
              : Container()
        ],
      ),
    );
  }

}
Widget setSlider(BuildContext context, List<UserInfo> userInfoList){

  if(userInfoList != null && userInfoList.isNotEmpty){
    if(userInfoList[0].userTemplateCode == null || userInfoList[0].userTemplateCode == "null" ){
      return Center(
        child:Text('아직 구매한 원고가 없습니다!', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),) ,
      );
    }else{
      return Container(
            height: 120,
            child: ListView(
            scrollDirection: Axis.horizontal,
            children: makeBoxImages(context, userInfoList)
          )
      );
    }
  }else{
    return Center(

      child: InkWell(
        child: Text('탭하여 로그인'),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<Null>(
              //fullscreenDialog: true,
              builder: (BuildContext context) {
                return LoginScreen();
              }
          ));
        } ,
      ),

    );
  }
}

List<Widget> makeBoxImages(BuildContext context, List<UserInfo> userInfoList){
  List<Widget> results = [];
  for(int i = 0; i < userInfoList.length; i++)
  {
    var queryParameters = {
      'coverName' : userInfoList[i].userBookCover
    };
    var uri = Uri.http(API.IP, '/getCover',queryParameters);
    results.add(
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<Null>(
                //fullscreenDialog: true,
                builder: (BuildContext context) {
                  return MyDraftScreen(userInfoList[i]);
                }
            ));
          },//API.GET_IMAGEBASEURL + userInfoList[i].userBookCover
          child: Container(
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.network(uri.toString()),
            ),
          ),
        )
    );
  }

  return results;
}