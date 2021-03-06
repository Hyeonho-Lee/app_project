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
      //print(all_event![0]['μμμΌμ'].length);
      for (int i = 0; i < all_event![0]['μμμΌμ'].length; i++) {
        //print(all_event![0]['μμμΌμ'][i.toString()].toString());

        date.add(all_event![0]['μμμΌμ'][i.toString()].toString());
        year.add(all_event![0]['μμμΌμ'][i.toString()].toString().substring(0, 4));

        start_month.add(all_event![0]['μμμΌμ'][i.toString()].toString().substring(5, 7));
        start_day.add(all_event![0]['μμμΌμ'][i.toString()].toString().substring(8));

        end_month.add(all_event![0]['μ’λ£μΌμ'][i.toString()].toString().substring(5, 7));
        end_day.add(all_event![0]['μ’λ£μΌμ'][i.toString()].toString().substring(8));
      }

      print("$start_month / $start_day");
      print("$end_month / $end_day");

      while(true) {

        int Change_start_day =0;
        int Change_end_day =0;
        if(Cheak_count == all_event![0]['μμμΌμ'].length) break;

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
          var Cheak_find = DateTime(int.parse(year[Cheak_count]), int.parse(start_month[Cheak_count]), // κ°λ₯
              int.parse(start_day[Cheak_count])+i);

          if(_events.containsKey(Cheak_find)){
            // μμ κ²½μ° κΈ°μ‘΄μ mapμ λ¦¬μ€νΈ μΆκ°
            var test = _events[Cheak_find];
            test?.add(CleanCalendarEvent(
              all_event![0]['νμ¬λͺ'][Cheak_count.toString()].toString().length >= 12 ?
              all_event![0]['νμ¬λͺ'][Cheak_count.toString()].toString().substring(0, 12) + " ... μΆμ " :
              all_event![0]['νμ¬λͺ'][Cheak_count.toString()].toString(),
                startTime: DateTime(
                    int.parse(year[Cheak_count]), int.parse(start_month[Cheak_count]),
                    int.parse(start_day[Cheak_count])+i, 09, 0),
                endTime: DateTime(int.parse(year[Cheak_count]), int.parse(end_month[Cheak_count]),
                    int.parse(end_day[Cheak_count]), 18, 0),
                color: Colors.blue,
            ));
            //print("μ°Ύμ ${_events[Cheak_find]}");
          }
          else {
            //print("λμνλ€.");
            Map<DateTime, List<CleanCalendarEvent>> _events2 = {
              DateTime(int.parse(year[Cheak_count]), int.parse(start_month[Cheak_count]),
                  int.parse(start_day[Cheak_count])+i): [
                CleanCalendarEvent(
                  all_event![0]['νμ¬λͺ'][Cheak_count.toString()].toString().length >= 12 ?
                  all_event![0]['νμ¬λͺ'][Cheak_count.toString()].toString().substring(0, 12) + " ... μΆμ " :
                  all_event![0]['νμ¬λͺ'][Cheak_count.toString()].toString(),
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
        //print("${Cheak_count} λ ${Cheak_count} μλλ€.");
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
        type: BottomNavigationBarType.fixed, //μ€μ  νμ§μμΌλ©΄ μμ΄μ½ λλ₯Όκ²½μ° μλ‘ μ¬λΌκ°.
        onTap: (int index){
          //print(index); // μλνλμ§ νμ€νΈ.
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        selectedFontSize: 12,
        selectedItemColor: Colors.black, // μ νν μμ΄μ½ κΈμ νμ λ° μμ μ€μ 
        selectedLabelStyle: TextStyle(color: Colors.black),// μ νν μμ΄μ½ κΈμ νμ λ° μμ μ€μ 
        items: [
          _bottomNavigationBarItem("home", "ν"),
          _bottomNavigationBarItem("location", "μ§λ"),
          _bottomNavigationBarItem("notes", "μΊλ¦°λ"),
          _bottomNavigationBarItem("chat", "μ»€λ?€λν°"),
          _bottomNavigationBarItem("user", "μ€μ "),
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
          print("μμΉμ€μ ");
        },
        minWidth: 320,
        height: 50,
        child: Text(
          "μμΉμ€μ ",
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
      'μλ²μ μ°κ²°λμ§ μμ΅λλ€.',
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
              height: MediaQuery.of(context).size.height/1.2,
              child:  all_event!.length == 0 ?
              serverText :
              Container(
                child: Calendar(
                  startOnMonday: true,
                  weekDays: ['μΌ', 'μ', 'ν', 'μ', 'λͺ©', 'κΈ', 'ν '],
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
      print("μ£Όμλ₯Ό λ°μμ€μ§ λͺ»νμμ΅λλ€.");
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
        //print(all_event![0]["νμ¬λͺ"]);
      }
    });
  }
}