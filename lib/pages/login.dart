import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:flutter_ui_challenges/src/pages/login/signup1.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/pages/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/services/validater.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  static final String path = "lib/src/pages/login/login2.dart";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        setState(
          () {
            _isLoading = true;
          },
        );
        AuthResult authResult = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        Navigator.pop(context);
      } catch (e) {
        setState(
          () {
            _isLoading = false;
            Modal.showInSnackBar(
              _scaffoldKey,
              e.message,
            );
          },
        );
      }
    } else {
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  Widget emailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.email,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Email',
        icon: Icon(Icons.email),
        fillColor: Colors.white,
      ),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      obscureText: true,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Password',
        icon: Icon(Icons.lock),
        fillColor: Colors.white,
      ),
    );
  }

  _sendForgotEmail() async {
    try {
      String email = await Modal.showPasswordResetEmail(context);
      if (email != null) {
        setState(
          () {
            _isLoading = true;
          },
        );

        await _auth.sendPasswordResetEmail(email: email);

        setState(
          () {
            _isLoading = false;
            Modal.showInSnackBar(_scaffoldKey,
                'Sent - A link to reset your password has been sent via the email provided.');
          },
        );
      }
    } catch (e) {
      setState(
        () {
          _isLoading = false;
          Modal.showInSnackBar(_scaffoldKey, e.message);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 40.0),
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60.0),
                      emailFormField(),
                      SizedBox(height: 30),
                      passwordFormField(),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.only(left: 32.0),
                        child: InkWell(
                          child: Text('Forgot Password',
                              textAlign: TextAlign.center),
                          onTap: () {
                            _sendForgotEmail();
                          },
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: ,
                      // ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            padding: const EdgeInsets.fromLTRB(
                                40.0, 16.0, 30.0, 16.0),
                            color: Colors.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0))),
                            onPressed: () {
                              //_subm;
                              _login();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                const SizedBox(width: 40.0),
                                Icon(
                                  MdiIcons.arrowRight,
                                  size: 18.0,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 10.0),
                          OutlineButton.icon(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 30.0,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            highlightedBorderColor: Colors.indigo,
                            borderSide: BorderSide(color: Colors.indigo),
                            color: Colors.indigo,
                            textColor: Colors.indigo,
                            icon: Icon(
                              MdiIcons.arrowLeft,
                              size: 18.0,
                            ),
                            label: Text('Go Back'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          OutlineButton.icon(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 30.0,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            highlightedBorderColor: Colors.indigo,
                            borderSide: BorderSide(color: Colors.indigo),
                            color: Colors.indigo,
                            textColor: Colors.indigo,
                            icon: Icon(
                              MdiIcons.arrowRight,
                              size: 18.0,
                            ),
                            label: Text('Create Profile'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SignUpPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
