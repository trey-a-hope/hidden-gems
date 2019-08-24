import 'package:hiddengems_flutter/services/modal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;
  Gem gem = Gem();
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  bool _autoValidate = false;
  @override
  void initState() {
    super.initState();

    load();
  }

  load() async {
    gem = await getUserProfile();
    await setFields();
    setState(() {
      _isLoading = false;
    });
  }

  Future<Gem> getUserProfile() async {
    FirebaseUser user = await _auth.currentUser();
    QuerySnapshot qs = await _db
        .collection('Gems')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    DocumentSnapshot ds = qs.documents[0];

    return Gem.extractDocument(ds);
  }

  Future<void> setFields() async {
    _nameController.text = gem.name;
  }

  update() async {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();

      bool confirm = await Modal.showConfirmation(
          context, 'Update Profile', 'Are you sure?');
      if (confirm) {
        _db
            .collection('Gems')
            .document(gem.id)
            .updateData({'name': _nameController.text}).then(
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
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
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

  TextFormField nameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      // focusNode: _heightFocus,
      onFieldSubmitted: (term) {
        // _fieldFocusChange(context, _heightFocus, _weightFocus);
      },
      validator: (value) {
        if (value.length == 0) {
          return ('Name cannot be empty.');
        }
      },
      onSaved: (value) {
        // _height = value;
      },
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(Icons.person),
        fillColor: Colors.white,
      ),
    );
  }

  _buildBottomNavigationBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: RaisedButton(
        onPressed: () {
          update();
        },
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
                  child: Column(
                    children: <Widget>[
                      nameFormField(),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
