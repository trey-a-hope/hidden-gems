import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/db.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/services/validater.dart';
import 'package:hiddengems_flutter/asset_images.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserSignUpPage extends StatefulWidget {
  @override
  State createState() => UserSignUpPageState();
}

class UserSignUpPageState extends State<UserSignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String dropdownValue;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    try {
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      getIt<Modal>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await getIt<Modal>().showConfirmation(
          context: context, title: 'Submit', message: 'Are you ready?');
      if (confirm) {
        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          //Create new user in auth.
          AuthResult authResult =
              await getIt<Auth>().createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          final FirebaseUser user = authResult.user;

          User newUser = User(
              id: '',
              fcmToken: '',
              backgroundUrl: DUMMY_BACKGROUND_PHOTO_URL,
              bio: '',
              category: '',
              email: user.email,
              facebookUrl: '',
              iTunesUrl: '',
              instagramUrl: '',
              name: _nameController.text,
              phoneNumber: '',
              photoUrl: DUMMY_PROFILE_PHOTO_URL,
              soundCloudUrl: '',
              spotifyUrl: '',
              subCategory: '',
              time: DateTime.now(),
              twitterUrl: '',
              uid: user.uid,
              youTubeUrl: '',
              isGem: false);

          getIt<DB>().createUser(
            user: newUser,
          );

          Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName));
        } catch (e) {
          setState(
            () {
              _isLoading = false;
            },
          );
          getIt<Modal>()
              .showInSnackBar(scaffoldKey: _scaffoldKey, message: e.message);
        }
      }
    } else {
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: _isLoading
          ? Spinner()
          : Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: (screenWidth * 0.1) / 2,
                  bottom: (screenWidth * 0.1) / 2,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: dayton_background_two,
                          fit: BoxFit.cover,
                          alignment: Alignment.center)),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.5),
                          Colors.blue.withOpacity(0.9)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 1]),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: _autoValidate ? 390 : 370,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 6),
                                blurRadius: 6),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                _nameFormField(),
                                SizedBox(height: 20),
                                _emailFormField(),
                                SizedBox(height: 30),
                                _passwordFormField(),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _cancelButton(),
                                    _signUpButton()
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _cancelButton() {
    return OutlineButton.icon(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      highlightedBorderColor: Colors.red,
      borderSide: BorderSide(color: Colors.red),
      color: Colors.red,
      textColor: Colors.red,
      icon: Icon(
        MdiIcons.arrowLeft,
        size: 18.0,
      ),
      label: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _signUpButton() {
    return OutlineButton.icon(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 15.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      highlightedBorderColor: Colors.blue,
      borderSide: BorderSide(color: Colors.blue),
      color: Colors.blue,
      textColor: Colors.blue,
      icon: Icon(
        MdiIcons.send,
        size: 18.0,
      ),
      label: Text('Submit'),
      onPressed: () {
        _signUp();
      },
    );
  }

  Widget _nameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(Icons.person),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _emailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
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

  Widget _passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      obscureText: true,
      maxLengthEnforced: true,
      maxLength: MyFormData.passwordCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.password,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Password',
        icon: Icon(Icons.lock),
        fillColor: Colors.white,
      ),
    );
  }
}
