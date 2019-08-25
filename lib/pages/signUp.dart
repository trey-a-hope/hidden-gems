import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/services/validater.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/services/validater.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  static final String path = "lib/src/pages/login/signup1.dart";

  String dropdownValue;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = true;

  List<DropdownMenuItem<String>> _musicSubCatDrop,
      _mediaSubCatDrop,
      _entertainmentSubCatDrop,
      _foodSubCatDrop,
      _techSubCatDrop,
      _artSubCatDrop;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _categoryController, _subCategoryController;

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

      bool confirm =
          await Modal.showConfirmation(context, 'Submit', 'Are you ready?');
      if (confirm) {
        setState(
          () {
            _isLoading = true;
          },
        );

        //Create new user in auth.
        _auth
            .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        )
            .then(
          (authResult) async {
            //Add user info to Database.
            final FirebaseUser user = authResult.user;

            var data = {
              'backgroundUrl': DUMMY_BACKGROUND_PHOTO_URL,
              'bio': '',
              'category': _categoryController,
              'email': user.email,
              'facebookName': '',
              'iTunesID': '',
              'instagramName': '',
              'likes': [],
              'name': _nameController.text,
              'phoneNumber': '',
              'photoUrl': DUMMY_PROFILE_PHOTO_URL,
              'soundCloudName': '',
              'spotifyID': '',
              'subCategory': _subCategoryController,
              'time': DateTime.now(),
              'twitterName': '',
              'uid': user.uid,
              'youTubeID': '',
            };

            DocumentReference dr = await _db.collection('Gems').add(data);
            await _db
                .collection('Gems')
                .document(dr.documentID)
                .updateData({'id': dr.documentID});

            Modal.showAlert(context, 'Done', 'New gem created.');
          },
        ).catchError(
          (e) {
            Modal.showAlert(context, 'Error', e.toString());
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
    return Scaffold(
        body: Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Text(
                            'Create Profile',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60.0),
                    nameFormField(),
                    SizedBox(height: 20),
                    emailFormField(),
                    SizedBox(height: 30),
                    passwordFormField(),
                    SizedBox(height: 20),
                    Text('Talent Category'),
                    categoryDropdownField(),
                    SizedBox(height: 30),
                    _categoryController == null
                        ? Container()
                        : Text('Talent Sub Category'),
                    _categoryController == null
                        ? Container()
                        : subCategoryDropdownField(),
                    const SizedBox(height: 40.0),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: ,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          padding:
                              const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0))),
                          onPressed: () {
                            _signUp();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'SUBMIT',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              const SizedBox(width: 40.0),
                              Icon(
                                MdiIcons.arrowRight,
                                size: 18.0,
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
                          label: Text('Go Back To Login'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    ));
  }

  Widget nameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: Validater.isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Stage Name',
        icon: Icon(Icons.person),
        fillColor: Colors.white,
      ),
    );
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
      maxLengthEnforced: true,
      maxLength: MyFormData.passwordCharLimit,
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

  Widget categoryDropdownField() {
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

  Widget subCategoryDropdownField() {
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
    DocumentSnapshot ds =
        await _db.collection('Miscellaneous').document('HomePage').get();

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

    List<String> techSubCatList = List.from(data['tech']['subCategories']);
    _techSubCatDrop = techSubCatList.map<DropdownMenuItem<String>>(
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
      case 'Tech':
        return _techSubCatDrop;
      case 'Art':
        return _artSubCatDrop;
      default:
        return null;
    }
  }
}
