import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/chapter.dart';
import 'package:selfbookflutter/model/question.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:http/http.dart' as http;

import 'package:selfbookflutter/fetchData/get_token.dart';


Future<List<Question>> getQuestionList(var data, String type) async{

  final String token = await jwtOrEmpty;

  List<Question> questionList = List<Question>();

  String path = '';
  if(type == 'delegate'){
    path = "/delegates";
  }else{
    path = "/details";
  }

  //var response = await http.post(url, body: data);

  var uri = Uri.http(API.IP, path,data);
  print(uri);
  //print(token);
  var response = await http.get(uri, headers: {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json',
  });

  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = json.decode(response.body);
    for(int i = 0; i < result.length ; i++)
    {
      Question questionItem;
      if(type == 'delegate'){
        questionItem = Question.fromJsonDelegate(result[i]);
      }else{
        questionItem = Question.fromJsonDetail(result[i]);
      }
      if(questionItem != null) questionList.add(questionItem);
    }
    return questionList;
  }else{
    return Future.error('loading fail');
  }
}