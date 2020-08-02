import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/chapter.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:http/http.dart' as http;


Future<List<Chapter>> getChapterList(String userID, String templateCode) async{

  final String token = await jwtOrEmpty;

  var queryParameters = {
    'userID' : userID,
    'templateCode' : templateCode
  };
  List<Chapter> chapterList = List<Chapter>();

  //var response = await http.post(API.GET_CHAPTERLIST, body: data);

  var uri = Uri.http(API.IP, "/chapters" ,queryParameters);
  print(uri);
  print(token);
  var response = await http.get(uri, headers: {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json',
  });

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
  }else if(response.statusCode == 401){
    return Future.error('Auth fail');
  }else{
    return Future.error('loading fail');
  }
}