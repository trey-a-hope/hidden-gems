import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/subCategories.dart';
import 'package:hiddengems_flutter/widgets/avatarBuilder.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/pages/search.dart';
import 'package:hiddengems_flutter/pages/createGem.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/services/pdInfo.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class Section {
  String quote;
  String subQuote;
  String photoUrl;
  List<String> subCategories = List<String>();
  Color primaryColor;
  Color accentColor;
  IconData icon;
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _db = Firestore.instance;
  final _drawerIconColor = Colors.blueGrey;
  final PDInfo _pdInfo = PDInfo();

  bool _isLoading = true;

  Section _music = Section();
  Section _media = Section();
  Section _entertainment = Section();
  Section _food = Section();
  Section _tech = Section();
  Section _art = Section();


  List<Gem> _musicGems,
      _mediaGems,
      _entertainmentGems,
      _foodGems,
      _techGems,
      _artGems = List<Gem>();

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

  void loadPage() async {
    _musicGems = await _getGems('Music');
    _mediaGems = await _getGems('Media');
    _entertainmentGems = await _getGems('Entertainment');
    _foodGems = await _getGems('Food');
    _techGems = await _getGems('Tech');
    _artGems = await _getGems('Art');

    _deviceID = await _pdInfo.getDeviceID();
    _projectCode = await _pdInfo.getAppBuildNumber();
    _projectVersion = await _pdInfo.getAppVersionNumber();

    await _getHeaderWidgets();

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
                        _buildMusicHeader(),
                        SizedBox(height: 20),
                        _buildMusicLayout(),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        _buildMediaHeader(),
                        SizedBox(height: 20),
                        _buildMediaLayout(),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        _buildEntertainmentHeader(),
                        SizedBox(height: 20),
                        _buildEntertainmentLayout(),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        _buildFoodHeader(),
                        SizedBox(height: 20),
                        _buildFoodLayout(),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        _buildTechHeader(),
                        SizedBox(height: 20),
                        _buildTechLayout(),
                        SizedBox(height: 20),
                        Divider(color: Colors.black),
                        SizedBox(height: 20),
                        _buildArtHeader(),
                        SizedBox(height: 20),
                        _buildArtLayout(),
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

  _buildMusicHeader() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_music.photoUrl),
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
                color: _music.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    '"${_music.quote}"',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    _music.subQuote,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  )
                ],
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
        color: _music.accentColor,
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
                          fontSize: 16.0,
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
                        fontSize: 16.0,
                        letterSpacing: 2.0,
                        color: _music.primaryColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubCategories(
                              'MUSIC',
                              _music.subCategories,
                              _musicGems,
                              _music.accentColor,
                              _music.icon)),
                    );
                  },
                )
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          AvatarBuilder(
            _musicGems.sublist(
                0, _musicGems.length < 5 ? _musicGems.length : 5),
          ),
          Divider(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(_music.icon, color: _music.primaryColor),
                  SizedBox(width: 20),
                  Text('${_musicGems.length} artists currently.')
                ],
              ))
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
          image: NetworkImage(_media.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: _media.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    '"${_media.quote}"',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    _media.subQuote,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildMediaLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: _media.accentColor,
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
                        color: _media.primaryColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                            'MEDIA',
                            _media.subCategories,
                            _mediaGems,
                            _media.accentColor,
                            _media.icon),
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
            _mediaGems.sublist(
                0, _mediaGems.length < 5 ? _mediaGems.length : 5),
          ),
          Divider(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(_media.icon, color: _media.primaryColor),
                  SizedBox(width: 20),
                  Text('${_mediaGems.length} artists currently.')
                ],
              ))
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
          image: NetworkImage(_entertainment.photoUrl),
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
                color: _entertainment.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    '"${_entertainment.quote}"',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    _entertainment.subQuote,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEntertainmentLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: _entertainment.accentColor,
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
                        color: _entertainment.primaryColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                            'ENTERTAINMENT',
                            _entertainment.subCategories,
                            _entertainmentGems,
                            _entertainment.accentColor,
                            _entertainment.icon),
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
            _entertainmentGems.sublist(0,
                _entertainmentGems.length < 5 ? _entertainmentGems.length : 5),
          ),
          Divider(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(_entertainment.icon, color: _entertainment.primaryColor),
                  SizedBox(width: 20),
                  Text('${_entertainmentGems.length} artists currently.')
                ],
              ))
        ],
      ),
    );
  }

  _buildFoodHeader() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_food.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: _food.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    '"${_food.quote}"',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    _food.subQuote,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildFoodLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: _food.accentColor,
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
                      'FOOD',
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
                        color: _food.primaryColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                          'FOOD',
                          _food.subCategories,
                          _foodGems,
                          _food.accentColor,
                          _food.icon,
                        ),
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
            _foodGems.sublist(0, _foodGems.length < 5 ? _foodGems.length : 5),
          ),
          Divider(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(_food.icon, color: _food.primaryColor),
                  SizedBox(width: 20),
                  Text('${_foodGems.length} artists currently.')
                ],
              ))
        ],
      ),
    );
  }

  _buildTechHeader() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_tech.photoUrl),
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
                color: _tech.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    '"${_tech.quote}"',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    _tech.subQuote,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTechLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: _tech.accentColor,
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
                      'TECH',
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
                        color: _tech.primaryColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                            'TECH',
                            _tech.subCategories,
                            _techGems,
                            _tech.accentColor,
                            _tech.icon),
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
            _techGems.sublist(0, _techGems.length < 5 ? _techGems.length : 5),
          ),
          Divider(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(_tech.icon, color: _tech.primaryColor),
                  SizedBox(width: 20),
                  Text('${_techGems.length} artists currently.')
                ],
              ))
        ],
      ),
    );
  }

  _buildArtHeader() {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_art.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: _art.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    '"${_art.quote}"',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    _art.subQuote,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildArtLayout() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: _art.accentColor,
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
                      'ART',
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
                        color: _art.primaryColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategories(
                            'ART',
                            _art.subCategories,
                            _artGems,
                            _art.accentColor,
                            _art.icon),
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
            _artGems.sublist(0, _artGems.length < 5 ? _artGems.length : 5),
          ),
          Divider(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(_art.icon, color: _art.primaryColor),
                  SizedBox(width: 20),
                  Text('${_artGems.length} artists currently.')
                ],
              ))
        ],
      ),
    );
  }
}
