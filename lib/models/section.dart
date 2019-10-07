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

  Section(String title){
    this.title = title;
  }
}