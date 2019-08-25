class Validater {
  static String isEmpty(String value) {
    if (value.length == 0) {
      return ('Field cannot be empty.');
    }
  }

  static String mobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value.length == 0) {
      return null;
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid number or leave blank.';
    }
    return null;
  }

  static String email(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid email.';
    else
      return null;
  }

  static String password(String value) {
    Pattern pattern = '.{6,}';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return '6 character minimum.';
    else
      return null;
  }
}
