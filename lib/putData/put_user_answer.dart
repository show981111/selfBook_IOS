import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:http/http.dart' as http;

Future<String> putUserAnswer(BuildContext context ,String key, String userID, String input, String from, String token) async{

  Map data = {
    'key' : key,
    'userID' : userID,
    'input' : input,
    'from' : from
  };
  var response = await http.put(API.PUT_USERANSWER, body: data, headers: {
    'Authorization': 'Bearer ' + token
  });
  print(response.statusCode);

  if(response.statusCode == 200 && response.body.isNotEmpty){

    var result = response.body;
    if(result != null){
      return result;
    }else{
      return Future.error('upload fail');
    }
  }else if(response.statusCode == 401){
    return Future.error('Auth fail');
  }else{
    return Future.error('connection fail');
  }
}
