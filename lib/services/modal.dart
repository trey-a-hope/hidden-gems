import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/services/validater.dart';

abstract class Modal {
  void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey, @required String message});
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message});
  Future<String> showChangePassword({@required BuildContext context});
  Future<String> showChangeEmail({@required BuildContext context});
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message});
}

class ModalImplementation extends Modal {
  @override
  void showInSnackBar(
      {@required GlobalKey<ScaffoldState> scaffoldKey, @required String message}) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Future<String> showChangePassword({@required BuildContext context}) {
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
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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
                Navigator.of(context).pop(emailController.text);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Future<String> showChangeEmail({@required BuildContext context}) {
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
            textInputAction: TextInputAction.next,
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

  @override
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text('NO', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text('YES', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
