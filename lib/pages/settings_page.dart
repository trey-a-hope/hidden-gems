import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/services/modal.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser user;
  bool _isLoading = true;
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    await getIt<Auth>().getFirebaseUser();
    setState(
      () {
        _isLoading = false;
      },
    );
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
                          getIt<Modal>().showChangeEmail(context: context).then(
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
                                      getIt<Modal>().showInSnackBar(
                                          scaffoldKey: _scaffoldKey, message: 'Email updated.');
                                    },
                                  );
                                } catch (e) {
                                  setState(
                                    () {
                                      _isLoading = false;
                                      getIt<Modal>().showInSnackBar(
                                          scaffoldKey: _scaffoldKey, message: e.message);
                                    },
                                  );
                                }
                              }
                            },
                          );
                        },
                      )
                    : Container(),
                Divider(),
                user != null
                    ? ListTile(
                        leading: Icon(MdiIcons.lock, color: Colors.black),
                        title: Text(
                          'Change Password',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          // getIt<Modal>().showChangePassword(context: context).then(
                          //   (password) async {
                          //     if (password != null) {
                          //       try {
                          //         setState(
                          //           () {
                          //             _isLoading = true;
                          //           },
                          //         );

                          //         await user.updatePassword(password);

                          //         setState(
                          //           () {
                          //             _isLoading = false;
                          //             getIt<Modal>().showInSnackBar(
                          //                 scaffoldKey: _scaffoldKey, message: 'Password updated.');
                          //           },
                          //         );
                          //       } catch (e) {
                          //         setState(
                          //           () {
                          //             _isLoading = false;
                          //             getIt<Modal>().showInSnackBar(
                          //                 scaffoldKey: _scaffoldKey, message: e.message);
                          //           },
                          //         );
                          //       }
                          //     }
                          //   },
                          // );
                        },
                      )
                    : Container(),
                Divider()
              ],
            ),
    );
  }
}
