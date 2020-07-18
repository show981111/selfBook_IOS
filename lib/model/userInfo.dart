//public String userID;
//public String userName;
//public int userTemplateCode;
//public String userBookName;
//public String userBookPublishDate;
//public String userBookCover;

class UserInfo{
  final String userID;
  final String userName;
  final String userTemplateCode;
  final String userBookName;
  final String userBookPublishDate;
  final String userBookCover;


  UserInfo({this.userID, this.userName, this.userTemplateCode, this.userBookName,
      this.userBookPublishDate, this.userBookCover});

  factory UserInfo.fromJson(Map<String, dynamic> json){
    return UserInfo(
        userID: json['userID'],
        userName: json['userName'],
        userTemplateCode: json['userTemplateCode'],
        userBookName: json['userBookName'],
        userBookPublishDate: json['userBookPublishDate'],
        userBookCover: json['userBookCover']
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'user<$userID,$userTemplateCode>';
  }
}
