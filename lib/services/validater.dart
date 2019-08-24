class Validater {
  static String isEmpty(String value) {
    if (value.length == 0) {
      return ('Field cannot be empty.');
    }
  }

  static String mobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return null;
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid number or leave blank.';
    }
    return null;
  }
}
