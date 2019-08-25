import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/services/modal.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    await _fetchUser();
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  _fetchUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    setState(() {
      user = firebaseUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('SETTINGS', style: TextStyle(letterSpacing: 2.0)),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                user != null
                    ? ListTile(
                        leading: Icon(MdiIcons.email, color: Colors.black),
                        title: Text(
                          'Change Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Modal.showChangeEmail(context).then(
                            (email) async {
                              if (email != null) {
                                try {
                                  setState(
                                    () {
                                      _isLoading = true;
                                    },
                                  );

                                  await user.updateEmail(email);

                                  setState(
                                    () {
                                      _isLoading = false;
                                      Modal.showInSnackBar(
                                          _scaffoldKey, 'Email updated.');
                                    },
                                  );
                                } catch (e) {
                                  setState(
                                    () {
                                      _isLoading = false;
                                      Modal.showInSnackBar(
                                          _scaffoldKey, e.message);
                                    },
                                  );
                                }
                              }
                            },
                          );
                        },
                      )
                    : Container(),
                user != null
                    ? ListTile(
                        leading: Icon(MdiIcons.lock, color: Colors.black),
                        title: Text(
                          'Change Password',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          Modal.showChangePassword(context).then(
                            (password) async {
                              if (password != null) {
                                try {
                                  setState(
                                    () {
                                      _isLoading = true;
                                    },
                                  );

                                  await user.updatePassword(password);

                                  setState(
                                    () {
                                      _isLoading = false;
                                      Modal.showInSnackBar(
                                          _scaffoldKey, 'Password updated.');
                                    },
                                  );
                                } catch (e) {
                                  setState(
                                    () {
                                      _isLoading = false;
                                      Modal.showInSnackBar(
                                          _scaffoldKey, e.message);
                                    },
                                  );
                                }
                              }
                            },
                          );
                        },
                      )
                    : Container(),
              ],
            ),
    );
  }
}
