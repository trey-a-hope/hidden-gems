import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/subCategories.dart';
import 'package:hiddengems_flutter/widgets/avatarBuilder.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get_version/get_version.dart';
import 'package:flutter/services.dart';
import 'package:hiddengems_flutter/pages/search.dart';
import 'package:hiddengems_flutter/pages/about.dart';

import 'package:hiddengems_flutter/pages/createGem.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:device_id/device_id.dart';

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
  String _deviceId;

  String _musicHeaderQuote;
  String _musicHeaderUrl;
  List<Gem> _musicGems = List<Gem>();
  String _mediaHeaderQuote;
  String _mediaHeaderUrl;
  List<Gem> _mediaGems = List<Gem>();
  String _entertainmentHeaderQuote;
  String _entertainmentHeaderUrl;
  List<Gem> _entertainmentGems = List<Gem>();

  String _projectVersion;
  String _projectCode;

  @override
  void initState() {
    super.initState();

    loadPage();
  }

  Future<String> _fetchDeviceID() async {
    return await DeviceId.getID;
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

      gem.id = ds['id'];
      gem.name = ds['name'];
      gem.category = ds['category'];
      gem.subCategory = ds['subCategory'];
      gem.photoUrl = ds['photoUrl'];

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

  _getHeaderWidgets() async {
    DocumentSnapshot ds =
        await _db.collection('Miscellaneous').document('HomePage').get();

    _musicHeaderQuote = ds['musicHeaderQuote'];
    _mediaHeaderQuote = ds['mediaHeaderQuote'];
    _entertainmentHeaderQuote = ds['entertainmentHeaderQuote'];

    _musicHeaderUrl = ds['musicHeaderUrl'];
    _mediaHeaderUrl = ds['mediaHeaderUrl'];
    _entertainmentHeaderUrl = ds['entertainmentHeaderUrl'];
  }

  void loadPage() async {
    _deviceId = await _fetchDeviceID();
    _musicGems = await _getGems('Music');
    _mediaGems = await _getGems('Media');
    _entertainmentGems = await _getGems('Entertainment');
    await _getHeaderWidgets();
    await _getVersionDetails();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Builder(
        builder: (context) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        _buildMusicHeader(),
                        SizedBox(height: 20),
                        _buildMusicLayout(),
                        SizedBox(height: 20),
                        _buildMediaHeader(),
                        SizedBox(height: 20),
                        _buildMediaLayout(),
                        SizedBox(height: 20),
                        _buildEntertainmentHeader(),
                        SizedBox(height: 20),
                        _buildEntertainmentLayout()
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: Text(
        'HIDDEN GEMS',
        style: TextStyle(letterSpacing: 2.0),
      ),
      actions: [],
    );
  }

  _buildDrawer() {
    return Drawer(
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
            decoration: BoxDecoration(
              color: Colors.black,
            ),
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
          Divider(),
          _deviceId == ADMIN_DEVICE_ID
              ? ListTile(
                  leading: Icon(MdiIcons.creation, color: _drawerIconColor),
                  title: Text(
                    'Create Gem',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateGemPage(),
                      ),
                    );
                  },
                )
              : Container(),
          ListTile(
            leading: Icon(MdiIcons.help, color: _drawerIconColor),
            title: Text(
              'About',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              );
            },
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
    );
  }

  _buildMusicLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'MUSIC',
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
                        color: Colors.teal),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                            'MUSIC',
                            [
                              'Rapper',
                              'Singer',
                              'Producer',
                              'Engineer',
                              'Instrumentalist',
                              'DJ'
                            ],
                            _musicGems),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          AvatarBuilder(
            _musicGems.sublist(0, 5),
          ),
        ],
      ),
    );
  }

  _buildEntertainmentLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'ENTERTAINMENT',
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
                        color: Colors.purple),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                            'ENTERTAINMENT',
                            ['Host', 'Dancer', 'Comedian', 'Model'],
                            _entertainmentGems),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          AvatarBuilder(
            _entertainmentGems,
          ),
        ],
      ),
    );
  }

  _buildMediaLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'MEDIA',
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
                        color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories('MEDIA',
                            ['Photographer', 'Videographer'], _mediaGems),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          AvatarBuilder(
            _mediaGems,
          ),
        ],
      ),
    );
  }

  _buildMusicHeader() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_musicHeaderUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                _musicHeaderQuote,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildMediaHeader() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_mediaHeaderUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                _mediaHeaderQuote,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEntertainmentHeader() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_entertainmentHeaderUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                _entertainmentHeaderQuote,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
