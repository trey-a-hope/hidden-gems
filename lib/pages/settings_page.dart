import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
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
    user = await getIt<Auth>().getFirebaseUser();
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
          ? Spinner()
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
                        onTap: () async {
                          try {
                            String email = await getIt<Modal>()
                                .showChangeEmail(context: context);
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
                                    scaffoldKey: _scaffoldKey,
                                    message: 'Email updated.');
                              },
                            );
                          } catch (e) {
                            setState(
                              () {
                                _isLoading = false;
                                getIt<Modal>().showInSnackBar(
                                    scaffoldKey: _scaffoldKey,
                                    message: e.toString());
                              },
                            );
                          }
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
                          try {
                            String password = await getIt<Modal>()
                                .showChangePassword(context: context);
                            if (password != null) {
                              setState(
                                () {
                                  _isLoading = true;
                                },
                              );

                              await user.updatePassword(password);

                              setState(
                                () {
                                  _isLoading = false;
                                  getIt<Modal>().showInSnackBar(
                                      scaffoldKey: _scaffoldKey,
                                      message: 'Password updated.');
                                },
                              );
                            }
                          } catch (e) {
                            getIt<Modal>().showAlert(
                                context: context,
                                title: 'Error',
                                message: e.toString());
                          }
                        },
                      )
                    : Container(),
                Divider()
              ],
            ),
    );
  }
}
