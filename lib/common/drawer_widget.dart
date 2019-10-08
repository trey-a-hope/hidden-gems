import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/pages/profile/edit_gem_profile_page.dart';
import 'package:hiddengems_flutter/pages/profile/edit_user_profile_page.dart';
import 'package:hiddengems_flutter/pages/settings_page.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/pages/login_page.dart';
import 'package:hiddengems_flutter/services/pd_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/constants.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  State createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  final PDInfo _pdInfo = PDInfo();
  final _drawerIconColor = Colors.blueGrey;
  String _projectVersion, _projectCode;
  FirebaseUser user;
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    load();

    getIt<Auth>().onAuthStateChanged().listen(
      (firebaseUser) {
        setState(
          () {
            user = firebaseUser;
          },
        );
      },
    );
  }

  load() async {
    _projectCode = await _pdInfo.getAppBuildNumber();
    _projectVersion = await _pdInfo.getAppVersionNumber();

    setState(
      () => {},
    );
  }

  Widget _buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        'Hidden Gems',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text('Dayton has more to offer...'),
      currentAccountPicture: GestureDetector(
        child: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(DUMMY_PROFILE_PHOTO_URL),
            backgroundColor: Colors.transparent,
            radius: 10.0),
      ),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildUserAccountsDrawerHeader(),
          // ListTile(
          //   leading: Icon(MdiIcons.searchWeb, color: _drawerIconColor),
          //   title: Text(
          //     'Search Gems',
          //     style: TextStyle(fontWeight: FontWeight.bold),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => SearchPage(),
          //       ),
          //     );
          //   },
          // ),
          user != null
              ? ListTile(
                  leading: Icon(MdiIcons.accountEdit, color: _drawerIconColor),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    User currentUser = await getIt<Auth>().getCurrentUser();
                    if (currentUser.isGem) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditGemProfilePage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserProfilePage(),
                        ),
                      );
                    }
                  },
                )
              : Container(),
          user == null
              ? ListTile(
                  leading: Icon(MdiIcons.login, color: _drawerIconColor),
                  title: Text(
                    'Login/Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Become a member.'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                )
              : ListTile(
                  leading: Icon(MdiIcons.logout, color: _drawerIconColor),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    bool confirm = await getIt<Modal>().showConfirmation(
                        context: context,
                        title: 'Sign Out',
                        message: 'Are you sure?');
                    if (confirm) {
                      await getIt<Auth>().signOut();
                    }
                  },
                ),
          user == null
              ? Container()
              : ListTile(
                  leading: Icon(MdiIcons.settings, color: _drawerIconColor),
                  title: Text(
                    'Settings',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Version $_projectVersion / Build $_projectCode.\nCreated by Tr3umphant.Designs, LLC.\nSearch powered by Algolia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
