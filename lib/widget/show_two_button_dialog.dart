import 'package:flutter/material.dart';

Future<String> showTwoButtonDialog(BuildContext context, String message) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: true, // user dont have button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text(
              message
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('확인'),
            onPressed: () {
//              Navigator.of(context).pop();
              return 'ok';
            },
          ),
          FlatButton(
            child: Text('취소'),
            onPressed: () {
//              Navigator.of(context).pop();
              return 'cancel';
            },
          ),
        ],
      );
    },
  );
}