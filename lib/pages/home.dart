import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/pages/search.dart';
import 'package:hiddengems_flutter/pages/createGem.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/services/pdInfo.dart';
import 'package:hiddengems_flutter/widgets/gemSectionHeader.dart';
import 'package:hiddengems_flutter/widgets/gemSectionLayout.dart';
import 'package:hiddengems_flutter/models/section.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _db = Firestore.instance;
  final _drawerIconColor = Colors.blueGrey;
  final PDInfo _pdInfo = PDInfo();

  bool _isLoading = true;

  Section _music = Section('MUSIC');
  Section _media = Section('MEDIA');
  Section _entertainment = Section('ENTERTAINMENT');
  Section _food = Section('FOOD');
  Section _tech = Section('TECH');
  Section _art = Section('ART');

  String _projectVersion, _projectCode, _deviceID;

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

      gem.id = ds['id'];
      gem.name = ds['name'];
      gem.category = ds['category'];
      gem.subCategory = ds['subCategory'];
      gem.photoUrl = ds['photoUrl'];
      gem.likes = ds['likes'];

      gems.add(gem);
    }
    return gems;
  }

  _getHeaderWidgets() async {
    DocumentSnapshot ds =
        await _db.collection('Miscellaneous').document('HomePage').get();

    dynamic data = ds.data;

    dynamic musicData = data['music'];
    _music.quote = musicData['quote'];
    _music.subQuote = musicData['subQuote'];
    _music.photoUrl = musicData['photoUrl'];
    _music.subCategories = List.from(musicData['subCategories']);
    _music.primaryColor = Colors.teal;
    _music.accentColor = Colors.teal[50];
    _music.icon = MdiIcons.music;

    dynamic mediaData = data['media'];
    _media.quote = mediaData['quote'];
    _media.subQuote = mediaData['subQuote'];
    _media.photoUrl = mediaData['photoUrl'];
    _media.subCategories = List.from(mediaData['subCategories']);
    _media.primaryColor = Colors.orange;
    _media.accentColor = Colors.orange[50];
    _media.icon = MdiIcons.camera;

    dynamic entertainmentData = data['entertainment'];
    _entertainment.quote = entertainmentData['quote'];
    _entertainment.subQuote = entertainmentData['subQuote'];
    _entertainment.photoUrl = entertainmentData['photoUrl'];
    _entertainment.subCategories =
        List.from(entertainmentData['subCategories']);
    _entertainment.primaryColor = Colors.purple;
    _entertainment.accentColor = Colors.purple[50];
    _entertainment.icon = MdiIcons.saxophone;

    dynamic foodData = data['food'];
    _food.quote = foodData['quote'];
    _food.subQuote = foodData['subQuote'];
    _food.photoUrl = foodData['photoUrl'];
    _food.subCategories = List.from(foodData['subCategories']);
    _food.primaryColor = Colors.red;
    _food.accentColor = Colors.red[50];
    _food.icon = MdiIcons.food;

    dynamic techData = data['tech'];
    _tech.quote = techData['quote'];
    _tech.subQuote = techData['subQuote'];
    _tech.photoUrl = techData['photoUrl'];
    _tech.subCategories = List.from(techData['subCategories']);
    _tech.primaryColor = Colors.blue;
    _tech.accentColor = Colors.blue[50];
    _tech.icon = MdiIcons.laptop;

    dynamic artData = data['art'];
    _art.quote = artData['quote'];
    _art.subQuote = artData['subQuote'];
    _art.photoUrl = artData['photoUrl'];
    _art.subCategories = List.from(artData['subCategories']);
    _art.primaryColor = Colors.brown;
    _art.accentColor = Colors.brown[50];
    _art.icon = MdiIcons.formatPaint;
  }

  _attachGems() async {
    _music.gems = await _getGems('Music');
    _media.gems = await _getGems('Media');
    _entertainment.gems = await _getGems('Entertainment');
    _food.gems = await _getGems('Food');
    _tech.gems = await _getGems('Tech');
    _art.gems = await _getGems('Art');
  }

  void loadPage() async {
    _deviceID = await _pdInfo.getDeviceID();
    _projectCode = await _pdInfo.getAppBuildNumber();
    _projectVersion = await _pdInfo.getAppVersionNumber();

    await _getHeaderWidgets();
    await _attachGems();

    setState(
      () {
        _isLoading = false;
      },
    );
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
                        GemSectionHeader(_music).build(context),
                        SizedBox(height: 20),
                        GemSectionLayout(_music).build(context),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        GemSectionHeader(_media).build(context),
                        SizedBox(height: 20),
                        GemSectionLayout(_media).build(context),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        GemSectionHeader(_entertainment).build(context),
                        SizedBox(height: 20),
                        GemSectionLayout(_entertainment).build(context),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        GemSectionHeader(_food).build(context),
                        SizedBox(height: 20),
                        GemSectionLayout(_food).build(context),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        GemSectionHeader(_tech).build(context),
                        SizedBox(height: 20),
                        GemSectionLayout(_tech).build(context),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        GemSectionHeader(_art).build(context),
                        SizedBox(height: 20),
                        GemSectionLayout(_art).build(context),
                        SizedBox(height: 20),
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
                backgroundColor: Colors.transparent,
                radius: 10.0,
                child: Image.asset('assets/images/logo.jpg'),
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
          _deviceID == ADMIN_DEVICE_ID
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
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Version $_projectVersion / Build $_projectCode. App created by Tr3umphant.Designs, LLC',
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
}
