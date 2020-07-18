import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/chapter.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:http/http.dart' as http;


Future<List<Chapter>> getChapterList(String userID, String templateCode) async{
  Map data = {
    'userID' : userID,
    'templateCode' : templateCode
  };
  List<Chapter> chapterList = List<Chapter>();
  var response = await http.post(API.GET_CHAPTERLIST, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = json.decode(response.body);
   
    for(int i = 0; i < result.length ; i++)
    {
      //print(result[i]);
      Chapter chapterItem = Chapter.fromJson(result[i]);
      chapterList.add(chapterItem);
    }
    //print("chapList" + chapterList.toString());
    return chapterList;
  }else{
    return Future.error('loading fail');
  }
}