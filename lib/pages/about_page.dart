import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('About')),
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(
            height: 250.0,
          ),
          padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              // colorFilter: ColorFilter.mode(
              //     Colors.black.withOpacity(0.6),
              //     BlendMode.luminosity),
              image: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/hidden-gems-e481d.appspot.com/o/HiddenGems_1024x1024.png?alt=media&token=775934c2-5712-4b61-a34d-58ea04963a10"),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Container(),
        ),
      ),
    );
  }
}
