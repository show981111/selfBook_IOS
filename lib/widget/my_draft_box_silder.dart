import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/login_screen.dart';
import 'package:selfbookflutter/screen/my_draft_screen.dart';

class BoxSlider extends StatelessWidget {
  List<UserInfo> userInfoList;
  BoxSlider({this.userInfoList});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('내가 구매한 원고', style: TextStyle(fontWeight: FontWeight.bold),),
          setSlider(context, userInfoList)
        ],
      ),
    );
  }

}

Widget setSlider(BuildContext context, List<UserInfo> userInfoList){

  if(userInfoList != null && userInfoList.isNotEmpty){
    if(userInfoList[0].userTemplateCode == null || userInfoList[0].userTemplateCode == "null" ){
      return  Text('아직 구매한 원고가 없습니다!');
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

//      child: FlatButton(
//        shape: new RoundedRectangleBorder(
//          borderRadius: new BorderRadius.circular(30.0),
//        ),
//        child: Text('로그인', style: TextStyle(fontSize: 15),),
//        color: Color.fromRGBO(96, 128, 104, 100),
//        textColor: Colors.white,
//        onPressed: () {
//          Navigator.of(context).push(MaterialPageRoute<Null>(
//              fullscreenDialog: true,
//              builder: (BuildContext context) {
//                return LoginScreen();
//              }
//          ));
//        },
//      ) ,
    );
  }
}

List<Widget> makeBoxImages(BuildContext context, List<UserInfo> userInfoList){
  List<Widget> results = [];
  for(int i = 0; i < userInfoList.length; i++)
  {
    print('BOX' + userInfoList.toString() + userInfoList[0].userBookCover);
    results.add(
//        Ink.image(
//          image:  NetworkImage(API.GET_IMAGEBASEURL + userInfoList[i].userBookCover),
//          fit: BoxFit.cover,
//          child: InkWell(
//            onTap: () {},
//          ),
//        )
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
              child: Image.network(API.GET_IMAGEBASEURL + userInfoList[i].userBookCover),
            ),
          ),
        )
    );
  }

  return results;
}