import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget{
  @override
  State createState() => _HttpApp();
}

class _HttpApp extends State {
  int page = 1;
  var response;

  List? all_event;

  @override
  void initState() {
    super.initState();
    all_event = new List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
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
        body: Container(
          child: Center(
            child: all_event!.length == 0
              ? Text('서버와 연결되지 않습니다.',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center)
              : ListView.builder (
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text(all_event![0]["행사명"][index.toString()]),
                          Text(all_event![0]["개최장소"][index.toString()]),
                          Text(all_event![0]["시작일자"][index.toString()]),
                          Text(all_event![0]["종료일자"][index.toString()]),
                          Text(all_event![0]["위도"][index.toString()].toString()),
                          Text(all_event![0]["경도"][index.toString()].toString()),
                        ],
                      ),
                    ),
                  );
                },
              itemCount: all_event![0]["행사명"].length,
            )
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
}