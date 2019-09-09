import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/services/validater.dart';

class Modal {
  // static void showInSnackBar(BuildContext context, String text) {
  //   final snackBar = SnackBar(content: Text(text));
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  static void showInSnackBar(
      GlobalKey<ScaffoldState> scaffoldKey, String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  // static void showAlert(BuildContext context, String title, String text) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(text),
  //       );
  //     },
  //   );
  // }

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

  static Future<String> showPasswordResetEmail(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Reset Password'),
        content: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          // child: InputField(
          //     controller: emailController,
          //     hintText: 'Email',
          //     obscureText: false,
          //     textInputType: TextInputType.emailAddress,
          //     icon: Icons.mail_outline,
          //     iconColor: Colors.black,
          //     bottomMargin: 20.0,
          //     validateFunction: Validater.email),
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            maxLengthEnforced: true,
            // maxLength: MyFormData.nameCharLimit,
            onFieldSubmitted: (term) {},
            validator: Validater.email,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'Email',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = _formKey.currentState;
              if (!form.validate()) {
                _autovalidate = true;
              } else {
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  static Future<String> showChangeEmail(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Change Email'),
        content: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            maxLengthEnforced: true,
            // maxLength: MyFormData.nameCharLimit,
            onFieldSubmitted: (term) {},
            validator: Validater.email,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'New Email',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = _formKey.currentState;
              if (!form.validate()) {
                _autovalidate = true;
              } else {
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  static Future<String> showChangePassword(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool _autovalidate = false;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text('Change Password'),
        content: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            maxLengthEnforced: true,

            // maxLength: MyFormData.nameCharLimit,
            onFieldSubmitted: (term) {},
            validator: Validater.password,
            onSaved: (value) {},
            decoration: InputDecoration(
              hintText: 'New Password',
              icon: Icon(Icons.email),
              fillColor: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('SUBMIT'),
            onPressed: () {
              final FormState form = _formKey.currentState;
              if (!form.validate()) {
                _autovalidate = true;
              } else {
                Navigator.of(context).pop(passwordController.text);
              }
            },
          )
        ],
      ),
    );
  }

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
