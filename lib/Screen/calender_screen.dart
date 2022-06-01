import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_project/model/user_model.dart';
import 'package:app_project/Screen/login_screen.dart';
import 'package:app_project/Screen/home_screen.dart';
import 'package:app_project/Screen/map_screen.dart';
import 'package:app_project/Screen/community_screen.dart';
import 'package:app_project/Screen/profile_screen.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:http/http.dart' as http;

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {

  late int _currentPageIndex;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  var response;
  var response2;
  List? all_event;

  @override
  void initState() {
    super.initState();
    all_event = new List.empty(growable: true);
    _currentPageIndex = 2;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });

    getJSONDate("result");
  }

  @override
  Widget build(BuildContext context) {

    int count = 0;
    int Cheak_count = 0;
    int Change_month =0;

    List<String> date = [];
    List<String> year = [];

    List<String> start_month = [];
    List<String> start_day = [];
    List<String> end_month =[];
    List<String> end_day =[];

    Map<DateTime, List<CleanCalendarEvent>> _events = {};

    if (all_event!.length != 0) {
      //print(all_event![0]['시작일자'].length);
      for (int i = 0; i < all_event![0]['시작일자'].length; i++) {
        //print(all_event![0]['시작일자'][i.toString()].toString());

        date.add(all_event![0]['시작일자'][i.toString()].toString());
        year.add(all_event![0]['시작일자'][i.toString()].toString().substring(0, 4));

        start_month.add(all_event![0]['시작일자'][i.toString()].toString().substring(5, 7));
        start_day.add(all_event![0]['시작일자'][i.toString()].toString().substring(8));

        end_month.add(all_event![0]['종료일자'][i.toString()].toString().substring(5, 7));
        end_day.add(all_event![0]['종료일자'][i.toString()].toString().substring(8));
      }

      print("$start_month / $start_day");
      print("$end_month / $end_day");

      while(true) {

        int Change_start_day =0;
        int Change_end_day =0;
        if(Cheak_count == all_event![0]['시작일자'].length) break;

        if(start_month[Cheak_count] == "01") Change_start_day = 31;
        else if(start_month[Cheak_count] == "02") Change_start_day = 59;
        else if(start_month[Cheak_count] == "03") Change_start_day = 90;
        else if(start_month[Cheak_count] == "04") Change_start_day = 120;
        else if(start_month[Cheak_count] == "05") Change_start_day = 151;
        else if(start_month[Cheak_count] == "06") Change_start_day = 181;
        else if(start_month[Cheak_count] == "07") Change_start_day = 212;
        else if(start_month[Cheak_count] == "08") Change_start_day = 243;
        else if(start_month[Cheak_count] == "09") Change_start_day = 273;
        else if(start_month[Cheak_count] == "10") Change_start_day = 304;
        else if(start_month[Cheak_count] == "11") Change_start_day = 334;
        else if(start_month[Cheak_count] == "12") Change_start_day = 365;
        else Change_start_day = 365;

        if(end_month[Cheak_count] == "01") Change_end_day = 31;
        else if(end_month[Cheak_count] == "02") Change_end_day = 59;
        else if(end_month[Cheak_count] == "03") Change_end_day = 90;
        else if(end_month[Cheak_count] == "04") Change_end_day = 120;
        else if(end_month[Cheak_count] == "05") Change_end_day = 151;
        else if(end_month[Cheak_count] == "06") Change_end_day = 181;
        else if(end_month[Cheak_count] == "07") Change_end_day = 212;
        else if(end_month[Cheak_count] == "08") Change_end_day = 243;
        else if(end_month[Cheak_count] == "09") Change_end_day = 273;
        else if(end_month[Cheak_count] == "10") Change_end_day = 304;
        else if(end_month[Cheak_count] == "11") Change_end_day = 334;
        else if(end_month[Cheak_count] == "12") Change_end_day = 365;
        else Change_end_day = 365;

        count = (Change_end_day + int.parse(end_day[Cheak_count])) - (Change_start_day + int.parse(start_day[Cheak_count]));

        print(count);

        for(int i =0;i<=count;i++){
          var Cheak_find = DateTime(int.parse(year[Cheak_count]), int.parse(start_month[Cheak_count]), // 가능
              int.parse(start_day[Cheak_count])+i);

          if(_events.containsKey(Cheak_find)){
            // 있을 경우 기존의 map에 리스트 추가
            var test = _events[Cheak_find];
            test?.add(CleanCalendarEvent(
              all_event![0]['행사명'][Cheak_count.toString()].toString().length >= 12 ?
              all_event![0]['행사명'][Cheak_count.toString()].toString().substring(0, 12) + " ... 축제" :
              all_event![0]['행사명'][Cheak_count.toString()].toString(),
                startTime: DateTime(
                    int.parse(year[Cheak_count]), int.parse(start_month[Cheak_count]),
                    int.parse(start_day[Cheak_count])+i, 09, 0),
                endTime: DateTime(int.parse(year[Cheak_count]), int.parse(end_month[Cheak_count]),
                    int.parse(end_day[Cheak_count]), 18, 0),
                color: Colors.blue,
            ));
            //print("찾음 ${_events[Cheak_find]}");
          }
          else {
            //print("대입한다.");
            Map<DateTime, List<CleanCalendarEvent>> _events2 = {
              DateTime(int.parse(year[Cheak_count]), int.parse(start_month[Cheak_count]),
                  int.parse(start_day[Cheak_count])+i): [
                CleanCalendarEvent(
                  all_event![0]['행사명'][Cheak_count.toString()].toString().length >= 12 ?
                  all_event![0]['행사명'][Cheak_count.toString()].toString().substring(0, 12) + " ... 축제" :
                  all_event![0]['행사명'][Cheak_count.toString()].toString(),
                    startTime: DateTime(
                        int.parse(year[Cheak_count]), int.parse(start_month[Cheak_count]),
                        int.parse(start_day[Cheak_count])+i, 09, 0),
                    endTime: DateTime(int.parse(year[Cheak_count]), int.parse(end_month[Cheak_count]),
                        int.parse(end_day[Cheak_count]), 18, 0),
                    color: Colors.blue,
                )
              ],
            };
            _events.addAll(_events2);
          }
          //print(_events);
        }

        count = 0;
        Cheak_count ++;
        //print("${Cheak_count} 는 ${Cheak_count} 입니다.");
      }
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

    final serverText = Text(
      '서버와 연결되지 않습니다.',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.center,
    );

    final main = Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 580,
              child:  all_event!.length == 0 ?
              serverText :
              Container(
                child: Calendar(
                  startOnMonday: true,
                  weekDays: ['일', '월', '화', '수', '목', '금', '토'],
                  events: _events,
                  isExpandable: true,
                  eventDoneColor: Colors.green,
                  selectedColor: Colors.pink,
                  todayColor: Colors.blue,
                  eventColor: Colors.grey,
                  locale: 'ko-KR',
                  isExpanded: true,
                  expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                  dayOfWeekStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12),
                  bottomBarTextStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
            ),
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
          return main;
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
      backgroundColor: Colors.white,
      body: _bodyWidget(),
    );
  }

  Future getJSONDate(String value) async{
    var url;
    var url2;

    if (value == "new") {
      url = 'http://3.15.67.95:5050/new_event';
    }else if (value == "end") {
      url = 'http://3.15.67.95:5050/end_event';
    }else if (value == "progress") {
      url = 'http://3.15.67.95:5050/';
    }else if (value == "result") {
      url = 'http://3.15.67.95:5050/result_event';
    }else {
      print("주소를 받아오지 못하였습니다.");
    }

    //print(url);
    response = await http.get(Uri.parse(url));

    setState(() {
      if (response.statusCode == 200) {
        String text_replace = response.body;
        text_replace = text_replace.replaceAll('&#39;', '"');

        var json_decode = jsonDecode(text_replace);
        all_event = new List.empty(growable: true);
        all_event!.add(json_decode);

        //print(all_event);
        //print(all_event![0]["행사명"]);
      }
    });
  }
}