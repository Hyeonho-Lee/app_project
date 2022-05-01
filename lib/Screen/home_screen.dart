import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_project/model/user_model.dart';
import 'package:app_project/Screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  var response;
  List? all_event;

  @override
  void initState() {
    super.initState();
    all_event = new List.empty(growable: true);
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

    final serverText = Text(
      '서버와 연결되지 않습니다.',
       style: TextStyle(
         color: Colors.black,
         fontSize: 18,
         letterSpacing: 2.0,
       ),
       textAlign: TextAlign.center,
    );

    final nicknameText = Text(
      '${loggedInUser.nickname}',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        letterSpacing: 2.0,
      ),
    );

    final emailText = Text(
      '${loggedInUser.email}',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        letterSpacing: 2.0,
      ),
    );

    final loginoutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () {
          logout(context);
        },
        child: Text(
          "로그아웃",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('메인 화면'),
        actions: [
          IconButton(
              onPressed: () {
                getJSONDate("new");
              },
              icon: Icon(Icons.first_page)
          ),
          IconButton(
              onPressed: () {
                getJSONDate("end");
              },
              icon: Icon(Icons.contact_page)
          ),
          IconButton(
              onPressed: () {
                getJSONDate("progress");
              },
              icon: Icon(Icons.last_page)
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Color(0xffffff),
                height: MediaQuery.of(context).size.height/1.5,
                child: Padding(
                  padding: const EdgeInsets.all(42.0),
                  child: Form(
                    //key: _fromKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        nicknameText,
                        SizedBox(height: 5),
                        emailText,
                        SizedBox(height: 5),
                        loginoutButton,
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getJSONDate(String value) async{
    var url;

    if (value == "new") {
      url = 'http://3.15.67.95:5050/new_event';
    }else if (value == "end") {
      url = 'http://3.15.67.95:5050/end_event';
    }else if (value == "progress") {
      url = 'http://3.15.67.95:5050/';
    }else {
      print("주소를 받아오지 못하였습니다.");
    }

    print(url);
    response = await http.get(Uri.parse(url));

    setState(() {
      if (response.statusCode == 200) {
        String text_replace = response.body;
        text_replace = text_replace.replaceAll('&#39;', '"');

        var json_decode = jsonDecode(text_replace);
        all_event = new List.empty(growable: true);
        all_event!.add(json_decode);
      }
    });
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}