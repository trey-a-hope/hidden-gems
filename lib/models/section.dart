import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/user.dart';

class Section {
  String title;
  String quote;
  String subQuote;
  String photoUrl;
  List<String> subCategories = List<String>();
  Color primaryColor;
  Color accentColor;
  IconData icon;
  List<User> previewGems = List<User>();

  Section(
      {@required String title,
      @required String quote,
      @required String subQUote,
      @required String photoUrl,
      @required List<String> subCategories,
      @required Color primaryColor,
      @required Color accentColor,
      @required IconData icon,
      List<User> previewGems}) {
    this.title = title;
    this.quote = quote;
    this.subQuote = subQuote;
    this.photoUrl = photoUrl;
    this.subCategories = subCategories;
    this.primaryColor = primaryColor;
    this.accentColor = accentColor;
    this.icon = icon;
    this.previewGems = previewGems;
  }
}
