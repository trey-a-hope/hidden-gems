import 'package:flutter/material.dart';

class NewPagePage extends StatefulWidget {
  @override
  State createState() => NewPagePageState();
}

class NewPagePageState extends State<NewPagePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('Page')),
        body: Center(child: Text('Test')));
  }
}
