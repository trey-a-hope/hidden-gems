// import 'package:flutter/material.dart';
// // import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// // import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// // import 'package:hiddengems_flutter/pages/notifications.dart';
// // import 'package:hiddengems_flutter/services/urlLauncher.dart';
// // import 'package:hiddengems_flutter/constants.dart';
// import 'package:hiddengems_flutter/services/modal.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// class SettingsPage extends StatefulWidget {
//   @override
//   State createState() => SettingsPageState();
// }

// class SettingsPageState extends State<SettingsPage> {
//   final Color _iconColor = Colors.lightGreen;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: ListView(
//         physics: BouncingScrollPhysics(),
//         children: <Widget>[
//           ListTile(
//               onTap: () async {
//                 bool open = await Modal.leaveApp(context, 'our mailing list.');
//                 if (open) {
//                   // URLLauncher.launchUrl(MAILING_LIST_URL);
//                 }
//               },
//               title: Text('Mailing List'),
//               leading: Icon(MdiIcons.email, color: this._iconColor)),
//           Divider(),
//           ListTile(
//               onTap: () async {
//                 showDialog(
//                   barrierDismissible: false,
//                   builder: (_) => AlertDialog(
//                         title: Text('Logout'),
//                         actions: <Widget>[
//                           //Cancel logout.
//                           FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text('Cancel',
//                                   style: TextStyle(color: Colors.white))),
//                           //Confirm logout.
//                           FlatButton(
//                               onPressed: () async {
 
//                               },
//                               child: Text('Yes',
//                                   style: TextStyle(color: Colors.white))),
//                         ],
//                       ),
//                   context: context,
//                 );
//               },
//               title: Text('Logout'),
//               leading: Icon(Icons.exit_to_app, color: this._iconColor)),
//           Divider()
//         ],
//       ),
//     );
//   }
// }
