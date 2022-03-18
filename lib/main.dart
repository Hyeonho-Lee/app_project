import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return _MyApp();
  }
}

class _MyApp extends State {
  var switchValue = false;
  String test = 'hello';
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.light(),
        home: Scaffold(
          body: Center(
              child: ElevatedButton(
                  child: Text('$test'),
                  style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all(_color)),
                  onPressed: () {
                    if(test == 'hello') {
                      setState(() {
                        test = 'flutter';
                        _color = Colors.amber;
                      });
                    } else {
                      setState(() {
                        test = 'hello';
                        _color = Colors.blue;
                      });
                    }
                  })),
        )
    );
  }
}