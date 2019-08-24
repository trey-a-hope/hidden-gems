import 'dart:collection';

import 'package:hiddengems_flutter/services/modal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;
  Gem gem;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  // HashMap<String, List<String>> subCategories = HashMap<String, List<String>>();

  List<DropdownMenuItem<String>> musicSubCatDrop,
      mediaSubCatDrop,
      entertainmentSubCatDrop,
      foodSubCatDrop,
      techSubCatDrop,
      artSubCatDrop;
  String _categoryController, _subCategoryController;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  bool _autoValidate = false;
  @override
  void initState() {
    super.initState();

    load();
  }

  load() async {
    await getSubCategories();
    await getUserProfile();
    await setFields();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future<void> getSubCategories() async {
    DocumentSnapshot ds =
        await _db.collection('Miscellaneous').document('HomePage').get();

    dynamic data = ds.data;

    List<String> musicSubCatList = List.from(data['music']['subCategories']);
    musicSubCatDrop = musicSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> mediaSubCatList = List.from(data['media']['subCategories']);
    mediaSubCatDrop = mediaSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> entertainmentSubCatList =
        List.from(data['entertainment']['subCategories']);
    entertainmentSubCatDrop =
        entertainmentSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> foodSubCatList = List.from(data['food']['subCategories']);
    foodSubCatDrop = foodSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> techSubCatList = List.from(data['tech']['subCategories']);
    techSubCatDrop = techSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();

    List<String> artSubCatList = List.from(data['art']['subCategories']);
    artSubCatDrop = artSubCatList.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();
  }

  Future<void> getUserProfile() async {
    FirebaseUser user = await _auth.currentUser();
    QuerySnapshot qs = await _db
        .collection('Gems')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    DocumentSnapshot ds = qs.documents[0];

    gem = Gem.extractDocument(ds);
  }

  Future<void> setFields() async {
    _nameController.text = gem.name;
    _bioController.text = gem.bio;
    _categoryController = gem.category;
    _subCategoryController = gem.subCategory;
  }

  submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await Modal.showConfirmation(
          context, 'Update Profile', 'Are you sure?');
      if (confirm) {
        var data = {
          'name': _nameController.text,
          'bio': _bioController.text,
          'category': _categoryController,
          'subCategory': _subCategoryController
        };

        _db.collection('Gems').document(gem.id).updateData(data).then(
          (res) {
            Modal.showAlert(context, 'Profile Updated', '');
          },
        ).catchError(
          (e) {
            Modal.showAlert(
              context,
              'Error',
              e.toString(),
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

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'EDIT PROFILE',
        style: TextStyle(letterSpacing: 2.0),
      ),
      actions: [],
    );
  }

  List<DropdownMenuItem<String>> _getSubCatOptions() {
    switch (_categoryController) {
      case 'Music':
        return musicSubCatDrop;
      case 'Media':
        return mediaSubCatDrop;
      case 'Entertainment':
        return entertainmentSubCatDrop;
      case 'Food':
        return foodSubCatDrop;
      case 'Tech':
        return techSubCatDrop;
      case 'Art':
        return artSubCatDrop;
      default:
        return null;
    }
  }

  TextFormField nameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: (value) {
        if (value.length == 0) {
          return ('Name cannot be empty.');
        }
      },
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(Icons.person),
        fillColor: Colors.white,
      ),
    );
  }

  TextFormField bioFormField() {
    return TextFormField(
      controller: _bioController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      maxLength: MyFormData.bioCharLimit,
      maxLines: 10,
      onFieldSubmitted: (term) {},
      validator: (value) {
        if (value.length == 0) {
          return ('Bio cannot be empty.');
        }
      },
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Bio',
        icon: Icon(Icons.info),
        fillColor: Colors.white,
      ),
    );
  }

  Container categoryDropdownField() {
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

  Container subCategoryDropdownField() {
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

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () => submit(),
        color: Colors.blue,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.update,
                color: Colors.white,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'UPDATE',
                style: TextStyle(color: Colors.white, letterSpacing: 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Builder(
        builder: (context) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    children: <Widget>[
                      nameFormField(),
                      bioFormField(),
                      SizedBox(height: 20),
                      Text('Category'),
                      categoryDropdownField(),
                      SizedBox(height: 20),
                      Text('Sub Category'),
                      subCategoryDropdownField(),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
