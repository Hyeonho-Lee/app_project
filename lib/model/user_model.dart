class UserModel {
  String? uid;
  String? nickname;
  String? email;

  UserModel({this.uid, this.nickname, this.email});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      nickname: map['nickname'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'email': email,
    };
  }
}