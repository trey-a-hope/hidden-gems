import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/settings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/pages/login.dart';
import 'package:hiddengems_flutter/pages/edit_profile.dart';
import 'package:hiddengems_flutter/services/pd_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/constants.dart';

class DrawerWidget extends StatefulWidget {

  const DrawerWidget({Key key}):super(key:key);

  @override
  State createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  final PDInfo _pdInfo = PDInfo();
  final _drawerIconColor = Colors.blueGrey;
  String _projectVersion, _projectCode;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();

    load();

    _auth.onAuthStateChanged.listen(
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                  },
                )
              : Container(),
          user == null
              ? ListTile(
                  leading: Icon(MdiIcons.creation, color: _drawerIconColor),
                  title: Text(
                    'Are You A Gem?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Login or create a Gem profile.'
                  ),
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
                    bool confirm = await Modal.showConfirmation(
                        context, 'Sign Out', 'Are you sure?');
                    if (confirm) {
                      _auth.signOut().then(
                            (r) {},
                          );
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
