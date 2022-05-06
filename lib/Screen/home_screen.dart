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

    //getJSONDate("progress");
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

    final festival_bg = Image.asset(
      'image/festival.png',
      width: 60,
      height: 60,
      fit: BoxFit.fitHeight,
    );

    final cards = ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              child: MaterialButton(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                minWidth: 500,
                height: 100,
                onPressed: () {
                  print('눌럿냐');
                },
                child: Row(
                  children: <Widget>[
                    festival_bg,
                    SizedBox(width: 20),
                    Container (
                      child: Text(
                        all_event![0]['행사명'][index.toString()] + '\n' +
                            '기간: ' + all_event![0]['시작일자'][index.toString()] + ' ~ ' +
                            all_event![0]['종료일자'][index.toString()] + '\n' +
                            '장소: ' + all_event![0]['개최장소'][index.toString()],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: all_event![0]["행사명"].length,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('메인 화면'),
        actions: [
          IconButton(
              onPressed: () {
                print('아이콘 클릭');
                getJSONDate("new");
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
                color: Colors.black12,
                height: MediaQuery.of(context).size.height/1.5,
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: cards,
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

        //print(all_event);
        //print(all_event![0]["행사명"]['0']);
      }
    });
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}