import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {

    final login_bg = Image.asset(
      'image/login_bg.jpg',
      height: MediaQuery.of(context).size.height/3,
      fit: BoxFit.fitHeight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height/3,
                  child: Column(
                    children: <Widget>[

                    ],
                  )
              ),
              Container(
                color: Color(0xffffff),
                height: MediaQuery.of(context).size.height/1.5,
                child: Padding(
                  padding: const EdgeInsets.all(42.0),
                  child: Form(
                    //key: _fromKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}