import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/chapter.dart';
import 'package:selfbookflutter/model/question.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:http/http.dart' as http;


Future<List<Question>> getQuestionList(Map data, String type) async{

  List<Question> questionList = List<Question>();

  String url = '';
  if(type == 'delegate'){
    url = API.GET_DELEGATELIST;
  }else{
    url = API.GET_DETAILLIST;
  }

  var response = await http.post(url, body: data);
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