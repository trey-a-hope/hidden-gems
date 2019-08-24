import 'dart:io';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditImagePage extends StatefulWidget {
  @override
  State createState() => EditImagePageState();
}

class EditImagePageState extends State<EditImagePage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  final _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File _profileImage, _backgroundImage;
  ImageProvider _profileImageProvider, _backgroundImageProvider;
  Gem _gem;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    await _fetchUserProfile();
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future<void> _fetchUserProfile() async {
    FirebaseUser user = await _auth.currentUser();
    QuerySnapshot qs = await _db
        .collection('Gems')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    DocumentSnapshot ds = qs.documents[0];

    _gem = Gem.extractDocument(ds);

    _profileImageProvider = NetworkImage(_gem.photoUrl);
    _backgroundImageProvider = NetworkImage(_gem.backgroundUrl);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Stack(
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
                        imageBuilder: (context, imageProvider) => Container(
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
                        SizedBox(height: 20.0)
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
                      _gem.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(_gem.category),
                      subtitle: Text(_gem.subCategory),
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

  void submit() async {
    if (_profileImage == null && _backgroundImage == null) {
      Modal.showAlert(context, 'Error', 'Please select a new image first.');
    } else {
      bool confirm = await Modal.showConfirmation(
          context, 'Save Image(s)', 'Are you sure?');
      if (confirm) {
        setState(
          () {
            _isLoading = true;
          },
        );

        if (_profileImage != null) {
          String newPhotoUrl = await _uploadProfileImage();
          await _db
              .collection('Gems')
              .document(_gem.id)
              .updateData({'photoUrl': newPhotoUrl});
        }

        if (_backgroundImage != null) {
          String newBackgroundUrl = await _uploadBackgroundImage();
          await _db
              .collection('Gems')
              .document(_gem.id)
              .updateData({'backgroundUrl': newBackgroundUrl});
        }

        setState(
          () {
            _isLoading = false;
            Modal.showAlert(context, 'Success', 'Images saved.');
          },
        );
      }
    }
  }

  Future<String> _uploadProfileImage() async {
    final StorageReference ref =
        FirebaseStorage().ref().child('Images/Users/${_gem.id}/Profile');
    final StorageUploadTask uploadTask = ref.putFile(_profileImage);
    StorageReference sr = (await uploadTask.onComplete).ref;
    return (await sr.getDownloadURL()).toString();
  }

  Future<String> _uploadBackgroundImage() async {
    final StorageReference ref =
        FirebaseStorage().ref().child('Images/Users/${_gem.id}/Background');
    final StorageUploadTask uploadTask = ref.putFile(_backgroundImage);
    StorageReference sr = (await uploadTask.onComplete).ref;
    return (await sr.getDownloadURL()).toString();
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'EDIT IMAGES',
        style: TextStyle(letterSpacing: 2.0),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
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
}
