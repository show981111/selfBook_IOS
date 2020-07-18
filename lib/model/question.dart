import 'package:flutter/material.dart';
import 'package:selfbookflutter/model/chapter.dart';

//private int ID;
//private String name;
//private String hint;
//private String answer;
//private int status;

class Question extends Chapter{
  final String id;
  final String name;
  final String hint;
  final String answer;
  final String status;

  Question({this.id, this.name, this.hint, this.answer, this.status});

  factory Question.fromJsonDelegate(Map<String, dynamic> json){
    return Question(
        id: json['delegateCode'].toString(),
        name: json['delegateName'],
        hint: json['delegateHint'],
        answer: json['delegateAnswer'],
        status: json['status'].toString()
    );
  }
  factory Question.fromJsonDetail(Map<String, dynamic> json){
    return Question(
        id: json['detailCode'].toString(),
        name: json['detailName'],
        hint: json['detailHint'],
        answer: json['detailAnswer'],
        status: json['status'].toString()
    );
  }


  @override
  String toString() {
    return "Question<$id:$name>";
  }
}