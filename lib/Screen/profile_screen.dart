import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_project/model/user_model.dart';
import 'package:app_project/Screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final profile_bg = Image.asset(
      'image/profile.png',
      height: 200,
      fit: BoxFit.fitHeight,
    );

    final nicknameText = Text(
      '아이디: ${loggedInUser.nickname}',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        letterSpacing: 2.0,
        fontWeight: FontWeight.bold,
      ),
    );

    final emailText = Text(
      '이메일: ${loggedInUser.email}',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        letterSpacing: 2.0,
        fontWeight: FontWeight.bold,
      ),
    );

    final locationButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          print("위치설정");
        },
        minWidth: 320,
        height: 50,
        child: Text(
          "위치설정",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final loginoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          logout(context);
        },
        minWidth: 320,
        height: 50,
        child: Text(
          "로그아웃",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final top_bg = Container(
      width: 400,
      height: 350,
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          profile_bg,
          SizedBox(height: 20),
          nicknameText,
          SizedBox(height: 5),
          emailText,
          SizedBox(height: 5),
        ],
      ),
    );

    final bottom_bg = Container(
      width: 350,
      height: 200,
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          locationButton,
          SizedBox(height: 5),
          loginoutButton,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('메인 화면'),
        actions: [
          IconButton(
              onPressed: () {
                print('아이콘 클릭');
              },
              icon: Icon(Icons.location_on)
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height/1.2,
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: Column(
                    children: <Widget>[
                      top_bg,
                      SizedBox(height: 5),
                      bottom_bg,
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/20,
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: Column(
                    children: <Widget>[
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}