import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'material test app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaterialFlutterApp(),
    );
  }
}

class MaterialFlutterApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaterialFlutterApp();
  }
}

class _MaterialFlutterApp extends State<MaterialFlutterApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Material Design App')
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add_box),
        onPressed: () {

        }
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset('image/flutter_image.jpg'),
              Text('Flutter Image View')
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        )
      )
    );
  }
}