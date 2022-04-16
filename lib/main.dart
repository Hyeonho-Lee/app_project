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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Http Example'),
          actions: [
            IconButton(
                onPressed: () {
                  getJSONDate();
                },
                icon: Icon(Icons.search))
          ],
        )
    );
  }

  Future getJSONDate() async{
    var url = 'http://3.15.67.95:5050/';

    if (response == null) {
      response = await http.get(Uri.parse(url));
    }

    setState(() {
      if (response.statusCode == 200) {
        String text_replace = response.body;
        text_replace = text_replace.replaceAll('&#39;', '"');

        var json_decode = jsonDecode(text_replace);
        print(json_decode["행사명"]);
        print(json_decode["개최장소"]);
        print(json_decode["위도"]);
        print(json_decode["경도"][1.toString()]);
      }
    });
  }
}