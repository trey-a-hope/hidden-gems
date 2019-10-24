import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/db.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/services/storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/services/validater.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfilePage extends StatefulWidget {
  @override
  State createState() => EditUserProfilePageState();
}

class EditUserProfilePageState extends State<EditUserProfilePage> {
  User _currentUser;
  bool _isLoading = true;
  bool _autoValidate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File _profileImage;
  File _backgroundImage;
  ImageProvider _profileImageProvider;
  ImageProvider _backgroundImageProvider;

  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {

    _currentUser = await getIt<Auth>().getCurrentUser();

    _profileImageProvider = NetworkImage(_currentUser.photoUrl);
    _backgroundImageProvider = NetworkImage(_currentUser.backgroundUrl);

    _nameController.text = _currentUser.name;
    _phoneController.text = _currentUser.phoneNumber;

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future _pickProfileImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImageProvider = FileImage(image);
      _profileImage = image;
    });
  }

  Future _pickBackgroundImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _backgroundImageProvider = FileImage(image);
      _backgroundImage = image;
    });
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await getIt<Modal>().showConfirmation(
          context: context, title: 'Update Profile', message: 'Are you sure?');

      if (confirm) {
        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          await _submitFormData();
          await _submitImages();

          setState(
            () {
              _isLoading = false;
              getIt<Modal>().showInSnackBar(
                  scaffoldKey: _scaffoldKey, message: 'Profile updated.');
            },
          );
        } catch (e) {
          setState(
            () {
              _isLoading = false;
              getIt<Modal>().showInSnackBar(
                  scaffoldKey: _scaffoldKey, message: e.message());
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

  Future<void> _submitImages() async {
    if (_profileImage != null) {
      String newPhotoUrl = await getIt<Storage>().uploadImage(
          file: _profileImage, path: 'Images/Users/${_currentUser.id}/Profile');
          await getIt<DB>().updateUser(userId: _currentUser.id, data: {'photoUrl': newPhotoUrl});
    }

    if (_backgroundImage != null) {
      String newBackgroundUrl = await getIt<Storage>().uploadImage(
          file: _backgroundImage, path: 'Images/Users/${_currentUser.id}/Background');
                    await getIt<DB>().updateUser(userId: _currentUser.id, data: {'backgroundUrl': newBackgroundUrl});
    }
  }

  Future<void> _submitFormData() async {
    await getIt<DB>().updateUser(userId: _currentUser.id, data: {
      'name': _nameController.text,
      'phoneNumber': _phoneController.text,
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'EDIT PROFILE',
        style: TextStyle(letterSpacing: 2.0),
      ),
      actions: [],
    );
  }


  Widget nameFormField() {
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
        icon: Icon(Icons.person, color: Colors.red),
        fillColor: Colors.white,
      ),
    );
  }



  Widget phoneFormField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      maxLength: MyFormData.phoneCarLimit,
      maxLines: 1,
      onFieldSubmitted: (term) {},
      validator: Validater.mobile,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Phone Number',
        icon: Icon(MdiIcons.phone, color: Colors.blue),
        fillColor: Colors.white,
      ),
    );
  }

  

  Widget _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () => _submit(),
        color: Colors.blue,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.save,
                color: Colors.white,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'SAVE',
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
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      appBar: _buildAppBar(),
      body: Builder(
        builder: (context) => _isLoading
            ? Spinner()
            : Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: ListView(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              _pickBackgroundImage();
                            },
                            child: CachedNetworkImage(
                              imageUrl: "http://via.placeholder.com/200x150",
                              fit: BoxFit.cover,
                              fadeInCurve: Curves.easeIn,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: _backgroundImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                          child: Column(
                            children: <Widget>[
                              _buildInfoBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildBasic(),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildBasic() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Basic',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            SizedBox(height: 20),
            nameFormField(),
            phoneFormField(),
          ],
        ),
      ),
    );
  }

  

  _buildInfoBox() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 110.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _nameController.text,
                      style: Theme.of(context).textTheme.title,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(''),
                      subtitle: Text(''),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0)
            ],
          ),
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: _profileImageProvider, fit: BoxFit.cover),
          ),
          margin: EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () {
              _pickProfileImage();
            },
          ),
        ),
      ],
    );
  }
}
