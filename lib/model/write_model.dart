class WriteModel {
  String? uid;
  String? nickname;
  String? title;
  String? text;

  WriteModel({this.uid, this.nickname, this.title, this.text});

  factory WriteModel.fromMap(map) {
    return WriteModel(
      uid: map['uid'],
      nickname: map['nickname'],
      title: map['title'],
      text: map['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'title': title,
      'text': text,
    };
  }
}