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
import 'package:app_project/Screen/calender_screen.dart';

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

  var all_title = new List.empty(growable: true);
  var all_text = new List.empty(growable: true);
  var all_nickname = new List.empty(growable: true);
  var all_date = new List.empty(growable: true);

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
        type: BottomNavigationBarType.fixed, //?????? ??????????????? ????????? ???????????? ?????? ?????????.
        onTap: (int index){
          //print(index); // ??????????????? ?????????.
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        selectedFontSize: 12,
        selectedItemColor: Colors.black, // ????????? ????????? ?????? ?????? ??? ?????? ??????
        selectedLabelStyle: TextStyle(color: Colors.black),// ????????? ????????? ?????? ?????? ??? ?????? ??????
        items: [
          _bottomNavigationBarItem("home", "???"),
          _bottomNavigationBarItem("location", "??????"),
          _bottomNavigationBarItem("notes", "?????????"),
          _bottomNavigationBarItem("chat", "????????????"),
          _bottomNavigationBarItem("user", "??????"),
        ],
      );
    }

    final emailField = TextFormField(
      autofocus: false,
      controller: titleController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("????????? ????????? ??????????????????!");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-z]").hasMatch(value)) {
          return ("????????? ????????? ???????????????!");
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
          hintText: "????????? ????????? ??????????????????",
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
              height: MediaQuery.of(context).size.height/1.15,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height/1.25,
                      child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: all_title.length == 0 ?
                          Text("???????????? ???????????? ????????????.") :
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                child: InkWell(
                                  child: Material(
                                    color: Colors.black12,
                                    child: MaterialButton(
                                      elevation: 5,
                                      color: Colors.white,
                                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      minWidth: 500,
                                      height: 300,
                                      onPressed: () {
                                        print('?????????');
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 500,
                                            height: 40,
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 80,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(100)
                                                  )
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  all_nickname[index].toString() + " / " +
                                                  all_date[index].toString().substring(0,10),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: 500,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              "??????: " + all_title[index].toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: 500,
                                            height: 180,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              "??????: " + all_text[index].toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: all_title.length,
                          )
                      ),
                    )
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
          return CalenderScreen();
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
          for (int i = 0; i < value.docs.length; i++) {
            all_title.add(value.docs[i].data()["title"]);
            all_text.add(value.docs[i].data()["text"]);
            all_nickname.add(value.docs[i].data()["nickname"]);
            all_date.add(value.docs[i].data()["date"]);
          }
          print("???????????? ??????");
          all_title = List.from(all_title.reversed);
          all_text = List.from(all_text.reversed);
          all_nickname = List.from(all_nickname.reversed);
          all_date = List.from(all_date.reversed);
        }
    );

    print(all_title);
  }
}