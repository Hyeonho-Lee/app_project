import 'package:app_project/Screen/home_screen.dart';
import 'package:app_project/model/write_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({Key? key}) : super(key: key);

  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  WriteModel loggedInUser = WriteModel();

  final TextEditingController titleController = new TextEditingController();
  final TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = WriteModel.fromMap(value.data());
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final writeText = Text(
      '글 쓰기',
      style: TextStyle(
        color: Colors.black,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.center,
    );

    final titleText = Text(
      '제목',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.left,
    );

    final textText = Text(
      '내용',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.left,
    );

    final titleField = TextFormField(
      autofocus: false,
      controller: titleController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("제목을 입력해주세요!");
        }
        return null;
      },
      onSaved: (value) {
        titleController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.title),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "제목을 입력해주세요",
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          )
      ),
    );

    final textField = TextFormField(
      autofocus: false,
      controller: textController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("내용을 입력해주세요!");
        }
        return null;
      },
      onSaved: (value) {
        textController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          hintText: "내용",
          hintStyle: TextStyle(
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          )
      ),
      maxLines: 18,
      minLines: 18,
    );

    final uploadButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          postDetailsToFirestore();
          Navigator.of(context).pop();
        },
        child: Text(
          "작성하기",
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
                color: Colors.white,
                height: MediaQuery.of(context).size.height/1.1,
                child: Padding(
                  padding: const EdgeInsets.all(42.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: writeText,
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: titleText,
                        ),
                        SizedBox(height: 5),
                        titleField,
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: textText,
                        ),
                        SizedBox(height: 5),
                        textField,
                        SizedBox(height: 20),
                        uploadButton,
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

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    WriteModel writeModel = WriteModel();

    writeModel.uid = user!.uid;
    writeModel.nickname = loggedInUser.nickname;
    writeModel.title = titleController.text;
    writeModel.text = textController.text;

    await firebaseFirestore
        .collection("dashboard")
        .doc(DateTime.now().toString())
        .set(writeModel.toMap());
    Fluttertoast.showToast(msg: "작성 성공! :)");
  }
}