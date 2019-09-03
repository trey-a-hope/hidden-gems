import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';

class Section {
  String title;
  String quote;
  String subQuote;
  String photoUrl;
  List<String> subCategories = List<String>();
  Color primaryColor;
  Color accentColor;
  IconData icon;
  List<Gem> previewGems = List<Gem>();

  Section(String title){
    this.title = title;
  }
}