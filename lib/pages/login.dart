/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:flutter_ui_challenges/src/pages/login/signup1.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/pages/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  static final String path = "lib/src/pages/login/login2.dart";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  _login() async {
    setState(
      () {
        _isLoading = true;
      },
    );

    _auth
        .signInWithEmailAndPassword(
            email: 'trey.a.hope@gmail.com', password: 'Peachy33')
        .then(
      (r) {
        Navigator.pop(context);
      },
    ).catchError(
      (e) {
        Modal.showAlert(
          context,
          'Error',
          e.toString(),
        );
      },
    ).whenComplete(
      () {
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          CircleAvatar(
            child: Image.asset('assets/img/origami.png'),
            maxRadius: 50,
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            height: 20.0,
          ),
          _buildLoginForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Go Back",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SignUpPage(),
                    ),
                  );
                },
                child: Text(
                  "Create Gem Profile",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Email address",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          Container(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  _login();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white70),
                ),
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildPageContent(context),
    );
  }
}
