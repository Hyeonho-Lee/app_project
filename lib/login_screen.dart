import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //final _fromKey = GlobalKey<FromState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    final login_bg = Image.asset(
        'image/login_bg1.jpg',
      height: MediaQuery.of(context).size.height/3,
      fit: BoxFit.fitHeight,
    );

    final emailText = Text(
        '이메일',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.left,
    );

    final passwordText = Text(
      '비밀번호',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.left,
    );

    final registerText = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '아직 회원이 아니신가요?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            //Navigator.push(context, MateralPageRoute(build: (context) => RegisterScreen()));
          },
          child: Text(
            "회원가입",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );

    final easyText = Text(
      '------------------------- 간편 로그인 -------------------------',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );

    // 이메일 입력창 설정
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      //validator: () {},
      onSaved: (value) {
        emailController.text = value!;
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
          onTap: () => emailController.clear(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        )
      ),
    );

    // 비밀번호 입력창 설정
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      //validator: () {},
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "비밀번호를 입력해주세요",
          hintStyle: TextStyle(
            fontSize: 12,
          ),
        suffixIcon: GestureDetector(
          child: const Icon(
            Icons.cancel_outlined
          ),
          onTap: () => passwordController.clear(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        )
      ),
    );

    // 로그인 버튼 설정
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          print("아이디: " + emailController.text.toString());
          print("비밀번호: " + passwordController.text.toString());
          print("로그인 진행중");
        },
        child: Text(
          "로그인",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // 간편로그인 버튼 설정
    final easyloginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          print("간편 로그인");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
                Icons.login
            ),
            SizedBox(width: 10),
            Text(
              "구글 로그인",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
                    login_bg
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: emailText,
                        ),
                        SizedBox(height: 5),
                        emailField,
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: passwordText,
                        ),
                        SizedBox(height: 5),
                        passwordField,
                        SizedBox(height: 20),
                        loginButton,
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: registerText,
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: easyText,
                        ),
                        SizedBox(height: 20),
                        easyloginButton,
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