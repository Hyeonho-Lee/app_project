import 'dart:io';

import 'package:app_project/Screen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_project/model/user_model.dart';
import 'package:app_project/model/write_model.dart';
import 'package:app_project/Screen/login_screen.dart';
import 'package:app_project/Screen/home_screen.dart';
import 'package:app_project/Screen/map_screen.dart';
import 'package:app_project/Screen/write_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  late int _currentPageIndex;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late var all_write;
  var test;

  final TextEditingController titleController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _currentPageIndex = 3;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });

    Update_Data();
  }

  @override
  Widget build(BuildContext context) {

    BottomNavigationBarItem _bottomNavigationBarItem(String iconName, String label) {
      return BottomNavigationBarItem(
        icon:Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_off.svg",width:22),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_on.svg",width:22),
        ),
        label: label,
      );
    }

    Widget _bottomNavigationBarwidget(){
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //설정 하지않으면 아이콘 누를경우 위로 올라감.
        onTap: (int index){
          //print(index); // 작동하는지 테스트.
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        selectedFontSize: 12,
        selectedItemColor: Colors.black, // 선택한 아이콘 글자 표시 및 색상 설정
        selectedLabelStyle: TextStyle(color: Colors.black),// 선택한 아이콘 글자 표시 및 색상 설정
        items: [
          _bottomNavigationBarItem("home", "홈"),
          _bottomNavigationBarItem("location", "지도"),
          _bottomNavigationBarItem("notes", "캘린더"),
          _bottomNavigationBarItem("chat", "커뮤니티"),
          _bottomNavigationBarItem("user", "설정"),
        ],
      );
    }

    final emailField = TextFormField(
      autofocus: false,
      controller: titleController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("이메일 주소를 입력해주세요!");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-z]").hasMatch(value)) {
          return ("이메일 주소가 틀렸습니다!");
        }
        return null;
      },
      onSaved: (value) {
        titleController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "이메일 주소를 입력해주세요",
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          suffixIcon: GestureDetector(
            child: const Icon(
                Icons.cancel_outlined
            ),
            //onTap: () => emailController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          )
      ),
    );

    final main = Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height/1.23,
              child: Padding(
                padding: const EdgeInsets.all(21.0),
                child: Column(
                  children: <Widget>[
                    Text("hello"),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

    Widget _bodyWidget() {
      switch (_currentPageIndex) {
        case 0:
          return HomeScreen();
          break;
        case 1:
          return MapScreen();
          break;
        case 2:
          return Container();
          break;
        case 3:
          return main;
          break;
        case 4:
          return ProfileScreen();
          break;
      }
      return Container();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _bodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WriteScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void Update_Data() async {
    all_write = FirebaseFirestore.instance.collection("dashboard")
        .get()
        .then((value) {
          print(value.docs.length);
          print(value.docs[4].data()["nickname"]);
        }
    );
  }
}