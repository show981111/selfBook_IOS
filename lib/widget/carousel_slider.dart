import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/fetch_template_info.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:selfbookflutter/model/userInfo.dart';
import 'package:selfbookflutter/screen/template_info_screen.dart';
import 'package:selfbookflutter/widget/show_dialog.dart';
import 'package:selfbookflutter/widget/show_purchase_dialog.dart';


class CarouselImage extends StatefulWidget {
  final UserInfo userInfo;

  CarouselImage({this.userInfo});

  _CarouselImageState createState() => _CarouselImageState();

}

class _CarouselImageState extends State<CarouselImage> {
  List<TemplateInfo> templates;
  int _currentPage = 0;
  List<Widget> networkImages = new List<Widget>();
  String _currentTitle = "";
  String _currentPrice = "";
  @override
  void initState() {//상위클래스 statefulwidget에 가져온 movies 를 참조
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTemplateInfoList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData == false){
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircularProgressIndicator(),
              ),
            );
          }else if(snapshot.hasError){
            return Container(
              child: Text('error'),
            );
          }else{
            templates = snapshot.data;
            if(templates.length < 1) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            networkImages.clear();
            _currentTitle = templates[_currentPage].templateName;
            _currentPrice = templates[_currentPage].bookPrice;
            for (int i = 0; i < templates.length; i++) {
              networkImages.add(Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        API.GET_IMAGEBASEURL + templates[i].bookCover),
                    fit: BoxFit.fitHeight,
                  ),
//                   border:
//                       Border.all(color: Theme.of(context).accentColor),
//                  borderRadius: BorderRadius.circular(32.0),
                ),
              ));
            }

            return new Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                  ),
                  CarouselSlider(
                    items: networkImages,
                    options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        //aspectRatio: 1.5,
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        onPageChanged : (index, reason) {
                          print("index " +index.toString());
                          if(index <= templates.length) {
                            setState(() {
                              _currentPage = index;
//                              _currentTitle = templates[index].templateName;
//                              _currentPrice = templates[index].bookPrice;
                            });
                          }
                        }
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 3),
                    child: Text(
                      _currentTitle,
                      style: TextStyle(fontSize: 15),),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Column(children: <Widget>[
                            IconButton(icon : Icon(Icons.attach_money), onPressed: () {},),
                            //Padding(padding: EdgeInsets.only(top: 3),),
                            Text(_currentPrice + "원",style: TextStyle(fontSize: 11),),
                          ],),
                        ),
                        Container(
//                          padding: EdgeInsets.only(right : 10),
                          child: FlatButton(
                            color: Colors.white,
                            onPressed: () {
                              if(widget.userInfo == null ){
                                showMyDialog(context, '먼저 로그인을 해주세요!');
                                return;
                              }
                              showPurchaseDialog(context,templates[_currentPage].templateName+'를 구매하시겠습니까?\n가격 ' + templates[_currentPage].bookPrice + '원'
                                 ,templates[_currentPage].templateCode);
                            },
                            child : Row(
                              children: <Widget>[
                                Icon(Icons.add_circle, color: Colors.black,),
                                Padding(padding: EdgeInsets.all(3),),
                                Text('구매', style: TextStyle(color: Colors.black),),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          //padding: EdgeInsets.only(right: 3),
                          child: Column(children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute<Null>(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) {
                                      return TemplateInfoScreen(
                                        templateInfo: templates[_currentPage],
                                        userInfo: widget.userInfo != null ? widget.userInfo : null,
                                      );
                                    }
                                ));
                              },
                            ),
                            Text(
                              '정보',
                              style: TextStyle(fontSize: 11),
                            )
                          ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: makeIndicator(templates, _currentPage),
                    ),
                  ),
                ],
              ),
            );
          }
        },
    );
  }
}

List<Widget> makeIndicator(List list, int _currentPage){
  List<Widget> results = [];
  for(int i = 0; i < list.length; i++)
  {
    results.add(
        Container(
        width: 8,
        height: 8,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == i
            ? Color.fromRGBO(255, 255, 255, 0.9)
            : Color.fromRGBO(255, 255, 255, 0.4),
        ),
      )
    );
  }
  return results;
}
