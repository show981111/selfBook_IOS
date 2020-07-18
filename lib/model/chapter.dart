import 'package:flutter/material.dart';

//private int ID;
//private String name;
//private String hint;
//private String answer;
//private int status;

class Chapter{
  String id;
  String name;
  String status;

  Chapter({this.id, this.name, this.status});

  factory Chapter.fromJson(Map<String, dynamic> json){

    return Chapter(
        id: json['chapterCode'].toString(),
        name: json['chapterName'],
        status: json['status'].toString()
    );
  }

  @override
  String toString() {
    return "Chapter<$id:$name>";
  }
}