import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child : Container(
        height: 50,
        child : TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.play_arrow,
                size: 20,
              ),
              child: Text(
                '만드는 법',
                style: TextStyle(fontSize: 11),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.home,
                size: 20,
              ),
              child: Text(
                '홈',
                style: TextStyle(fontSize: 11),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.account_circle,
                size: 20,
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 11),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
