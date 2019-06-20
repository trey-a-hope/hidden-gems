import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/fullListing.dart';
import 'package:hiddengems_flutter/widgets/avatarBuilder.dart';
import 'package:hiddengems_flutter/widgets/gemsPreview.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/mockData.dart';
import 'package:hiddengems_flutter/pages/settings.dart';
import 'package:hiddengems_flutter/models/gem.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  List<Gem> gems_musicians = new List<Gem>();
  List<Gem> gems_designers = new List<Gem>();
  List<Gem> gems_photographers = new List<Gem>();

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  Future<List<Gem>> loadGemsMusicians() async {
    //Show spinner with text.
    return MOCK_MUSICIANS;
  }

  void loadPage() async {
    this.gems_musicians = await loadGemsMusicians();

    setState(() {
      this._isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            centerTitle: true,
            title:
                Text('Hidden Gems', style: TextStyle(fontFamily: 'RobotoMono')),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.settings, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  })
            ]),
        body: Builder(
            builder: (context) => this._isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                        SliverList(
                            delegate: SliverChildListDelegate(<Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 15.0, bottom: 10.0),
                          ),
                          Container(
                            constraints: BoxConstraints.expand(
                              height: 250.0,
                            ),
                            padding: EdgeInsets.only(
                                left: 16.0, bottom: 8.0, right: 16.0),
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

                          GemsPreview(
                              'MUSICIANS',
                              'Some of the best rappers, singers, producers, engineers, and much more take hold of this list. Ideal for making some of the hottest music the city of Dayton has to offer.',
                              this.gems_musicians),
                          Divider(color: Colors.black),
                          // GemsPreview(
                          //     'DESIGNERS',
                          //     'From clothing design to logo design, these group of individuals are perfect for creating visually appealing content.',
                          //     gems_designers),
                          // Divider(color: Colors.black),
                          // GemsPreview(
                          //     'MEDIA',
                          //     'A picture is worth a thousand words, a video can leave you speechless. The people in this group are responsible for capturing moments in the city.',
                          //     gems_photographers),
                          // Divider(color: Colors.black),
                        ]))
                      ])));
  }
}
