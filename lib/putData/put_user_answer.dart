import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:http/http.dart' as http;

Future<String> putUserAnswer(BuildContext context ,String key, String userID, String input, String from) async{

  Map data = {
    'key' : key,
    'userID' : userID,
    'input' : input,
    'from' : from
  };
  var response = await http.post(API.POST_SETUSERANSWER, body: data);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    print(response.body);

    var result = response.body;
    if(result != null){
      return result;
    }else{
      return Future.error('upload fail');
    }
  }else{
    return Future.error('connection fail');
  }
}
