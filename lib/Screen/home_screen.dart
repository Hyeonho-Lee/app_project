import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_project/model/user_model.dart';
import 'package:app_project/Screen/login_screen.dart';
import 'package:app_project/Screen/map_screen.dart';
import 'package:app_project/Screen/profile_screen.dart';
import 'package:app_project/Screen/community_screen.dart';
import 'package:app_project/Screen/calender_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

enum Menus { progress, news, ends}

extension ParseToString on Menus {
  String toStrings() {
    var result;

    if (this.toString().split('.').last == 'progress') {
      result = '진행';
    }else if (this.toString().split('.').last == 'news') {
      result = '예정';
    }
    if (this.toString().split('.').last == 'ends') {
      result = '완료';
    }

    return result;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<bool> _selections1 = List.generate(3, (index) => false);
  Menus? _selection;
  String? lavels;

  late int _currentPageIndex;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  var response;
  List? all_event;

  Completer<GoogleMapController> _controller = Completer();

  String country='';
  String locality='';
  String postalCode='';
  String location_text='';

  Position? position;

  List<Placemark> placemarks = [];

  @override
  void initState() {
    super.initState();
    all_event = new List.empty(growable: true);
    lavels = "진행중";

    _currentPageIndex = 0;

    FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get()
    .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });

    getJSONDate("progress");
  }

  @override
  Widget build(BuildContext context) {

    getLocation() async {
      LocationPermission permission = await Geolocator.requestPermission();
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      placemarks = await placemarkFromCoordinates(position!.latitude, position!.longitude);
      //print(position!.latitude);
      //print(position!.longitude);
      //print(placemarks!.toString());
      setState(() {
        //country = placemarks[0].country == null? "": placemarks[0].country!;
        //locality = placemarks[0].locality == null? "": placemarks[0].locality!;
        location_text = placemarks[0].subLocality == null? "": placemarks[0].subLocality!;
        //print(location_text);
        //postalCode = placemarks[0].postalCode == null? "": placemarks[0].postalCode!;
        //print(placemarks[0].toString());
      });
    }

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

    final slides = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(width: 10),
        Text(
          '축제 일정',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 200),
        Row(
          children: <Widget>[
            Text(
              '${lavels}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            PopupMenuButton(
              icon: Icon(Icons.settings),
              onSelected: (Menus result) {
                setState(() {
                  _selection = result;
                  if (_selection == Menus.news) {
                    getJSONDate("new");
                    lavels = "예정중";
                  }

                  if (_selection == Menus.progress) {
                    getJSONDate("progress");
                    lavels = "진행중";
                  }

                  if (_selection == Menus.ends) {
                    getJSONDate("end");
                    lavels = "완료중";
                  }
                });
              },
              itemBuilder: (BuildContext context) => Menus.values
                  .map((value) => PopupMenuItem (
                value: value,
                child: Text(value.toStrings()),
              )).toList(),
            )
          ],
        )
      ],
    );

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

    final main = Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black12,
              height: MediaQuery.of(context).size.height/1.175,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      //color: Colors.blue,
                      height: MediaQuery.of(context).size.height/20,
                      child: slides,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height/1.32,
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: all_event!.length == 0 ?
                          serverText :
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
                                      height: 200,
                                      onPressed: () {
                                        print('눌럿냐');
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: festival_bg,
                                          ),
                                          SizedBox(width: 20),
                                          Container (
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  //color: Colors.red,
                                                    height: 50,
                                                    width: 190,
                                                    child: Text(
                                                      all_event![0]['행사명'][index.toString()],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        letterSpacing: 0.1,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                      //overflow: TextOverflow.ellipsis,
                                                    )
                                                ),
                                                SizedBox(height: 1),
                                                Container(
                                                  //color: Colors.red,
                                                    height: 20,
                                                    width: 190,
                                                    child: Text(
                                                      '기간: ' + all_event![0]['시작일자'][index.toString()] + ' ~ ' + all_event![0]['종료일자'][index.toString()],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        letterSpacing: 0.1,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                      //overflow: TextOverflow.ellipsis,
                                                    )
                                                ),
                                                SizedBox(height: 1),
                                                Container(
                                                  //color: Colors.red,
                                                    height: 20,
                                                    width: 190,
                                                    child: Text(
                                                      '장소: ' + all_event![0]['개최장소'][index.toString()],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        letterSpacing: 0.1,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                      //overflow: TextOverflow.ellipsis,
                                                    )
                                                ),
                                                SizedBox(height: 1),
                                                Container(
                                                  //color: Colors.red,
                                                    height: 50,
                                                    width: 190,
                                                    child: Text(
                                                      '내용: ' + all_event![0]['행사내용'][index.toString()],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        letterSpacing: 0.1,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                      //overflow: TextOverflow.ellipsis,
                                                    )
                                                ),
                                              ],
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
          return main;
          break;
        case 1:
          return MapScreen();
          break;
        case 2:
          return CalenderScreen();
          break;
        case 3:
          return CommunityScreen();
          break;
        case 4:
          return ProfileScreen();
          break;
      }
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '컬쳐 라이프',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Container(
            //color: Colors.red,
            width: 120,
            child: Center(
              child: Text(
                '${location_text}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                getLocation();
              },
              icon: Icon(Icons.location_on)
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarwidget(),
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