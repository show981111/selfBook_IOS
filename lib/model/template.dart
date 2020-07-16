class TemplateInfo{
  final String templateCode;
  final String author;
  final String templateName;
  final String bookPrice;
  final String madeDate;
  final String bookCover;
  final String templateIntro;


  TemplateInfo({this.templateCode, this.author, this.templateName,
      this.bookPrice, this.madeDate, this.bookCover, this.templateIntro});

  factory TemplateInfo.fromJson(Map<String, dynamic> json){
    return TemplateInfo(
        templateCode: json['templateCode'],
        author: json['author'],
        templateName: json['templateName'],
        bookPrice: json['bookPrice'],
        madeDate: json['madeDate'],
        bookCover: json['bookCover'],
        templateIntro: json['templateIntro']
    );
  }
  @override
  String toString() {
    return "Template<$templateCode:$templateName>";
  }

}
