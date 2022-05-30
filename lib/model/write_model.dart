class WriteModel {
  String? uid;
  String? nickname;
  String? title;
  String? text;
  String? date;

  WriteModel({this.uid, this.nickname, this.title, this.text, this.date});

  factory WriteModel.fromMap(map) {
    return WriteModel(
      uid: map['uid'],
      nickname: map['nickname'],
      title: map['title'],
      text: map['text'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'title': title,
      'text': text,
      'date': date,
    };
  }
}