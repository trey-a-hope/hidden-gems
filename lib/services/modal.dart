import 'package:flutter/material.dart';

class Modal {
  static void showInSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void showInSnackBar2(
      GlobalKey<ScaffoldState> scaffoldKey, String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  static void showAlert(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
        );
      },
    );
  }

  // static Future<Null> showWaitForOk(
  //     BuildContext context, String title, String text) {
  //   return showDialog<Null>(
  //     barrierDismissible: false,
  //     context: context,
  //     child: AlertDialog(
  //       title: Text(title),
  //       content: Text(text),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: const Text('OK'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  // static Future<bool> leaveApp(BuildContext context, String message) {
  //   return showDialog<bool>(
  //     barrierDismissible: false,
  //     context: context,
  //     child: AlertDialog(
  //       title: Text('Leave tr3Designs?'),
  //       content: Text('You will navigate to ${message}'),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: const Text('NO'),
  //           onPressed: () {
  //             Navigator.of(context).pop(false);
  //           },
  //         ),
  //         FlatButton(
  //           child: const Text('YES'),
  //           onPressed: () {
  //             Navigator.of(context).pop(true);
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  static Future<bool> showConfirmation(
      BuildContext context, String title, String text) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text('YES'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
