import 'package:flutter/material.dart';
import 'package:selfbookflutter/fetchData/fetch_chapter_list.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/chapter.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/delegate_screen.dart';

class ChapterGrid extends StatelessWidget{
  final UserInfo userInfo;

  ChapterGrid(this.userInfo);

  @override
  Widget build(BuildContext context) {
    List<Chapter> chapterList;
    return FutureBuilder(
      future: getChapterList(userInfo.userID, userInfo.userTemplateCode),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData == false && !snapshot.hasError){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if(snapshot.hasError){
          print(snapshot.error);
          return Container(
            child: Text('error'),
          );
        }else{
          chapterList = snapshot.data;
          return GridView.count(
            crossAxisCount: 3,
            children: chapterGrid(context, chapterList, userInfo),
          );
        }
      }
    );
  }

}


List<Widget> chapterGrid(BuildContext context, List<Chapter> chapterList, UserInfo userInfo){

  List<Widget> results = [];
  for(int i = 0; i < chapterList.length; i ++){
    results.add(
//        Stack(
//          alignment: AlignmentDirectional.center,
//          children: <Widget>[
//            Ink.image(
//              image: Icons.folder_open,
//              fit: BoxFit.cover,
//              child: InkWell(
//                onTap: () {},
//              ),
//            ),
//            Text("CH." + (i+1).toString())
//          ],
//        )
        InkWell(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            child: Center(
              child: Text("CH." + (i+1).toString(),
                style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: chapterList[i].status == "0" ? Colors.white : Colors.lightGreen
                ),),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  return DelegateListScreen(userInfo, chapterList[i].id, "CH." + (i+1).toString());
                }
            ));
          },
        )
    );
  }

  return results;
}