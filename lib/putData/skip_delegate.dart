import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/fetchData/get_token.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:http/http.dart' as http;

Future<String> skipDelegate(BuildContext context ,String key) async{

  String token = await jwtOrEmpty;

  Map data = {
    'delegateCode' : key
  };

  var response = await http.put(API.PUT_SKIPDELEGATE, body: data, headers: {
    'Authorization': 'Bearer ' + token
  });
  if(response.statusCode == 200 && response.body.isNotEmpty){
    print(response.body);

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
