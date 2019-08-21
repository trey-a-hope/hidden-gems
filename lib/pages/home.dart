import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/subCategories.dart';
import 'package:hiddengems_flutter/widgets/avatarBuilder.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get_version/get_version.dart';
import 'package:flutter/services.dart';
import 'package:hiddengems_flutter/pages/search.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _db = Firestore.instance;
  final _drawerIconColor = Colors.blueGrey;

  bool _isLoading = true;

  List<Gem> _musicians = List<Gem>();

  String _projectVersion;
  String _projectCode;

  @override
  void initState() {
    super.initState();

    loadPage();
  }

  //Fetch gems based on their category and limit them.
  Future<List<Gem>> _getGems(String category) async {
    QuerySnapshot qs = await _db
        .collection('Gems')
        .where('category', isEqualTo: category)
        .getDocuments();
    List<DocumentSnapshot> dss = qs.documents;
    List<Gem> gems = List<Gem>();
    for (DocumentSnapshot ds in dss) {
      Gem gem = Gem();
      gem.name = ds['name'];
      gem.bio = ds['bio'];
      gem.category = ds['category'];
      gem.subCategory = ds['subCategory'];
      gem.photoUrl = ds['photoUrl'];
      gem.likes = ds['likes'];
      gem.instagramName = ds['instagramName'];
      gem.age = ds['age'];
      gem.backgroundUrl = ds['backgroundUrl'];
      gems.add(gem);
    }
    return gems;
  }

  _getVersionDetails() async {
    //Version Name
    try {
      _projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      _projectVersion = 'Failed to get project version.';
    }
    //Version Code
    try {
      _projectCode = await GetVersion.projectCode;
    } on PlatformException {
      _projectCode = 'Failed to get build number.';
    }
  }

  void loadPage() async {
    _musicians = await _getGems('Musician');
    await _getVersionDetails();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'HIDDEN GEMS',
            style: TextStyle(letterSpacing: 2.0),
          ),
          actions: []),
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                'Hidden Gems',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text('Dayton has more to offer...'),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/hidden-gems-e481d.appspot.com/o/HiddenGems_1024x1024.png?alt=media&token=775934c2-5712-4b61-a34d-58ea04963a10'),
                ),
              ),
              decoration: BoxDecoration(color: Colors.green[500]),
            ),
            ListTile(
              leading: Icon(Icons.home, color: _drawerIconColor),
              title: Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(MdiIcons.searchWeb, color: _drawerIconColor),
              title: Text(
                'Search Gems',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.help, color: _drawerIconColor),
              title: Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(MdiIcons.email, color: _drawerIconColor),
              title: Text(
                'Contact Us',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(MdiIcons.helpCircle, color: _drawerIconColor),
              title: Text(
                'Help',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Version ${_projectVersion} / Build ${_projectCode}. App created by Tr3umphant.Designs, LLC',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) => _isLoading
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

                        // GemsPreview(
                        //     'MUSICIANS',
                        //     [
                        //       'Rapper',
                        //       'Singer',
                        //       'Producer',
                        //       'Engineer',
                        //       'Instrumentalist'
                        //     ],
                        //     'Some of the best rappers, singers, producers, engineers, and much more take hold of this list. Ideal for making some of the hottest music the city of Dayton has to offer.',
                        //     gems_musicians),
                        Divider(color: Colors.black),
                        //Musicians
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'MUSICIANS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        letterSpacing: 2.0,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              InkWell(
                                child: Text(
                                  'SEE ALL',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      letterSpacing: 2.0,
                                      color: Colors.green),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategories(
                                          'MUSICIANS',
                                          [
                                            'Rapper',
                                            'Singer',
                                            'Producer',
                                            'Engineer',
                                            'Instrumentalist'
                                          ],
                                          _musicians),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        AvatarBuilder(
                          _musicians.sublist(0, 5),
                        ),
                      ]),
                    )
                  ]),
      ),
    );
  }
}
