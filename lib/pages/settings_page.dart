import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/db.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser _firebaseUser;
  User _currentUser;
  bool _isLoading = true;
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    try {
      _firebaseUser = await getIt<Auth>().getFirebaseUser();
      _currentUser = await getIt<Auth>().getCurrentUser();
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      getIt<Modal>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
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
                _changeEmail(),
                Divider(),
                _changePassword(),
                Divider(),
                _deleteAccount()
              ],
            ),
    );
  }

  ListTile _changeEmail() {
    return ListTile(
      leading: Icon(MdiIcons.email, color: Colors.black),
      title: Text(
        'Change Email',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        try {
          String email = await getIt<Modal>().showChangeEmail(context: context);
          setState(
            () {
              _isLoading = true;
            },
          );

          await _firebaseUser.updateEmail(email);

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
                  scaffoldKey: _scaffoldKey, message: e.toString());
            },
          );
        }
      },
    );
  }

  ListTile _changePassword() {
    return ListTile(
      leading: Icon(MdiIcons.lock, color: Colors.black),
      title: Text(
        'Change Password',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        try {
          String password =
              await getIt<Modal>().showChangePassword(context: context);
          if (password != null) {
            setState(
              () {
                _isLoading = true;
              },
            );

            await _firebaseUser.updatePassword(password);

            setState(
              () {
                _isLoading = false;
                getIt<Modal>().showInSnackBar(
                    scaffoldKey: _scaffoldKey, message: 'Password updated.');
              },
            );
          }
        } catch (e) {
          getIt<Modal>().showAlert(
              context: context, title: 'Error', message: e.toString());
        }
      },
    );
  }

  Widget _deleteAccount() {
    return ListTile(
      leading: Icon(MdiIcons.trashCan, color: Colors.black),
      title: Text(
        'Delete Account',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        bool confirm = await getIt<Modal>().showConfirmation(
            context: context,
            title: 'Delete Account',
            message: 'We hate to see you leave. Are you sure?');
        if (confirm) {
          try {
            getIt<DB>().deleteUser(userID: _currentUser.id);
            getIt<Auth>().deleteUser();
            Navigator.of(context).pop();
          } catch (e) {
            getIt<Modal>().showAlert(
                context: context, title: 'Error', message: e.toString());
          }
        }
      },
    );
  }
}
