import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';

class GemInfoPage extends StatefulWidget {

  final Gem gem;
  GemInfoPage(this.gem); 

  @override
  State createState() => GemInfoPageState(gem);
}

class GemInfoPageState extends State<GemInfoPage>
    with SingleTickerProviderStateMixin {

      final Gem gem;
      GemInfoPageState(this.gem);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text(gem.name.toUpperCase(), style: TextStyle(letterSpacing: 2.0))),
        body: Center(child: Text('Test')));
  }
}
