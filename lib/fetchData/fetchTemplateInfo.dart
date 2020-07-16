import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:selfbookflutter/Api/Api.dart';
import 'package:selfbookflutter/model/template.dart';
import 'package:http/http.dart' as http;


Future<List<TemplateInfo>> getTemplateInfoList() async{

  List<TemplateInfo> templateInfoList = List<TemplateInfo>();
  var response = await http.get(API.GET_TEMPLATEINFO);
  if(response.statusCode == 200 && response.body.isNotEmpty){
    var result = json.decode(response.body);
    for(int i = 0; i < result.length ; i++)
    {

      TemplateInfo templateItem = TemplateInfo.fromJson(result[i]);
      templateInfoList.add(templateItem);
      print(templateItem.templateName);
    }
    return templateInfoList;
  }else{
    return Future.error('loading fail');
  }
}