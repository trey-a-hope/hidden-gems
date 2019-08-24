import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();

    getUser();
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    setState((){
      user = firebaseUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS', style: TextStyle(letterSpacing: 2.0)),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          user != null ? ListTile(
            leading: Icon(MdiIcons.email, color: Colors.black),
            title: Text(
              'Change Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ) : Container(),
          user != null ? ListTile(
            leading: Icon(MdiIcons.lock, color: Colors.black),
            title: Text(
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ) : Container(),
        ],
      ),
    );
  }
}
