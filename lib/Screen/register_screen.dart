import 'package:app_project/Screen/home_screen.dart';
import 'package:app_project/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nicknameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordCheckController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    final register_bg = Image.asset(
      'image/login_bg2.jpg',
      height: MediaQuery.of(context).size.height/3,
      fit: BoxFit.fitHeight,
    );

    final nicknameText = Text(
      '닉네임',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.left,
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

    final passwordCheckText = Text(
      '비밀번호 확인',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.left,
    );

    final nicknameField = TextFormField(
      autofocus: false,
      controller: nicknameController,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("닉네임를 입력해주세요!");
        }
        if (!regex.hasMatch(value)) {
          return ("닉네임 입력이 잘못되었습니다. (최소 2글자)");
        }
        return null;
      },
      onSaved: (value) {
        nicknameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "닉네임",
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          suffixIcon: GestureDetector(
            child: const Icon(
                Icons.cancel_outlined
            ),
            onTap: () => nicknameController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          )
      ),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("이메일 주소를 입력해주세요!");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-z]").hasMatch(value)) {
          return ("이메일 주소가 틀렸습니다!");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "이메일 주소",
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

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("비밀번호를 입력해주세요!");
        }
        if (!regex.hasMatch(value)) {
          return ("비밀번호 입력이 잘못되었습니다. (최소 6글자)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "비밀번호",
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

    final passwordCheckField = TextFormField(
      autofocus: false,
      controller: passwordCheckController,
      obscureText: true,
      validator: (value) {
        if (passwordController.text != value) {
          return "비밀번호가 다릅니다.";
        }
        return null;
      },
      onSaved: (value) {
        passwordCheckController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "비밀번호 확인",
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          suffixIcon: GestureDetector(
            child: const Icon(
                Icons.cancel_outlined
            ),
            onTap: () => passwordCheckController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          )
      ),
    );

    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        child: Text(
          "계속하기",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height/3,
                  child: Column(
                    children: <Widget>[
                      register_bg,
                    ],
                  )
              ),
              Container(
                color: Color(0xffffff),
                height: MediaQuery.of(context).size.height/1.5,
                child: Padding(
                  padding: const EdgeInsets.all(42.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: nicknameText,
                        ),
                        SizedBox(height: 5),
                        nicknameField,
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: emailText,
                        ),
                        SizedBox(height: 5),
                        emailField,
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: passwordText,
                        ),
                        SizedBox(height: 5),
                        passwordField,
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: passwordCheckText,
                        ),
                        SizedBox(height: 5),
                        passwordCheckField,
                        SizedBox(height: 20),
                        registerButton,
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

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
            postDetailsToFirestore()
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.nickname = nicknameController.text;
    
    await firebaseFirestore
      .collection("users")
      .doc(user.uid)
      .set(userModel.toMap());
    Fluttertoast.showToast(msg: "회원가입 성공! :)");
    
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
  }
}