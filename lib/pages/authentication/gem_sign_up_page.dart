import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/db.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/services/validater.dart';
import 'package:hiddengems_flutter/asset_images.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GemSignUpPage extends StatefulWidget {
  @override
  State createState() => GemSignUpPageState();
}

class GemSignUpPageState extends State<GemSignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String dropdownValue;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = true;

  List<DropdownMenuItem<String>> _musicSubCatDrop,
      _mediaSubCatDrop,
      _entertainmentSubCatDrop,
      _foodSubCatDrop,
      _technologySubCatDrop,
      _artSubCatDrop,
      _tradeSubCatDrop,
      _beautySubCatDrop;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _categoryController;
  String _subCategoryController;
  final GetIt getIt = GetIt.I;
  final CollectionReference _miscellaneousDB =
      Firestore.instance.collection('Miscellaneous');

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    await _fetchSubCategories();
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_categoryController == null) {
        getIt<Modal>().showInSnackBar(
            scaffoldKey: _scaffoldKey,
            message: 'Please select a talent first.');
        return;
      }

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
              category: _categoryController,
              email: user.email,
              facebookUrl: '',
              iTunesUrl: '',
              instagramUrl: '',
              name: _nameController.text,
              phoneNumber: '',
              photoUrl: DUMMY_PROFILE_PHOTO_URL,
              soundCloudUrl: '',
              spotifyUrl: '',
              subCategory: _subCategoryController,
              time: DateTime.now(),
              twitterUrl: '',
              uid: user.uid,
              youTubeUrl: '',
              isGem: true);

          getIt<DB>().createUser(
            data: newUser.toMap(),
          );

          Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName));
        } catch (e) {
          setState(
            () {
              getIt<Modal>().showInSnackBar(
                  scaffoldKey: _scaffoldKey, message: e.message);
            },
          );
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
                        height: 550,
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
                                Text('Talent Category'),
                                _categoryDropdownField(),
                                SizedBox(height: 30),
                                _categoryController == null
                                    ? Container()
                                    : Text('Talent Sub Category'),
                                _categoryController == null
                                    ? Container()
                                    : _subCategoryDropdownField(),
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

  Widget _categoryDropdownField() {
    return Container(
      width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: _categoryController,
            onChanged: (String value) {
              setState(
                () {
                  _categoryController = value;
                  //Set the sub category to the first option available.
                  _subCategoryController = _getSubCatOptions()[0].value;
                },
              );
            },
            items: MyFormData.categories.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  Widget _subCategoryDropdownField() {
    return Container(
      width: 300.0,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: _subCategoryController,
            onChanged: (String value) {
              setState(
                () {
                  _subCategoryController = value;
                },
              );
            },
            items: _getSubCatOptions(),
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  //Convert SubCategories into DropdownMenuItem lists.
  Future<void> _fetchSubCategories() async {
    DocumentSnapshot ds = await _miscellaneousDB.document('HomePage').get();

    dynamic data = ds.data;

    List<String> musicSubCatList = List.from(data['music']['subCategories']);
    _musicSubCatDrop = musicSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> mediaSubCatList = List.from(data['media']['subCategories']);
    _mediaSubCatDrop = mediaSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> entertainmentSubCatList =
        List.from(data['entertainment']['subCategories']);
    _entertainmentSubCatDrop =
        entertainmentSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> foodSubCatList = List.from(data['food']['subCategories']);
    _foodSubCatDrop = foodSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> technologySubCatList =
        List.from(data['technology']['subCategories']);
    _technologySubCatDrop = technologySubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> artSubCatList = List.from(data['art']['subCategories']);
    _artSubCatDrop = artSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> tradeSubCatList = List.from(data['trade']['subCategories']);
    _tradeSubCatDrop = tradeSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> beautySubCatList = List.from(data['beauty']['subCategories']);
    _beautySubCatDrop = beautySubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();
  }

  List<DropdownMenuItem<String>> _getSubCatOptions() {
    switch (_categoryController) {
      case 'Music':
        return _musicSubCatDrop;
      case 'Media':
        return _mediaSubCatDrop;
      case 'Entertainment':
        return _entertainmentSubCatDrop;
      case 'Food':
        return _foodSubCatDrop;
      case 'Technology':
        return _technologySubCatDrop;
      case 'Art':
        return _artSubCatDrop;
      case 'Trade':
        return _tradeSubCatDrop;
      case 'Beauty':
        return _beautySubCatDrop;
      default:
        return null;
    }
  }
}
