import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('SEARCH', style: TextStyle(letterSpacing: 2.0))),
        body: Center(child: Text('SEARCH', style: TextStyle(letterSpacing: 2.0))));
  }
}
