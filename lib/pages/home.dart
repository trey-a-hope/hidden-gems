import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/common/content_heading_widget.dart';
import 'package:hiddengems_flutter/common/drawer_widget.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/pages/search.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/common/gem_section_header.dart';
import 'package:hiddengems_flutter/common/gem_section_layout.dart';
import 'package:hiddengems_flutter/common/drawer_widget.dart';
import 'package:hiddengems_flutter/models/section.dart';
import 'package:hiddengems_flutter/pages/subCategories.dart';

import '../style/colors.dart';
import '../style/text.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final _db = Firestore.instance;

  bool _isLoading = true;

  Section _music = Section('MUSIC');
  Section _media = Section('MEDIA');
  Section _entertainment = Section('ENTERTAINMENT');
  Section _food = Section('FOOD');
  Section _tech = Section('TECH');
  Section _art = Section('ART');

  int _totalGemCount;

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

    List<Section> sections = [
      _music,
      _media,
      _entertainment,
      _food,
      _tech,
      _art
    ];

    _totalGemCount = 0;

    for (Section s in sections) {
      _totalGemCount += s.gems.length;
    }
  }

  void loadPage() async {
    await _getHeaderWidgets();
    await _attachGems();

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future<void> _refresh() async {
    await _getHeaderWidgets();
    await _attachGems();
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: DrawerWidget(),
      body: Builder(
        builder: (context) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _refresh,
                key: _refreshIndicatorKey,
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Material(
                              elevation: 4,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "TOTAL GEMS",
                                              style: hoursPlayedLabelTextStyle,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '$_totalGemCount',
                                          style: hoursPlayedTextStyle,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubCategories(
                                                          _music.title,
                                                          _music.subCategories,
                                                          _music.gems,
                                                          _music.accentColor,
                                                          _music.icon)),
                                            );
                                          },
                                          child: Icon(MdiIcons.diamondStone,
                                              color: _music.primaryColor),
                                        ),
                                        SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubCategories(
                                                          _media.title,
                                                          _media.subCategories,
                                                          _media.gems,
                                                          _media.accentColor,
                                                          _media.icon)),
                                            );
                                          },
                                          child: Icon(MdiIcons.diamondStone,
                                              color: _media.primaryColor),
                                        ),
                                        SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubCategories(
                                                          _entertainment.title,
                                                          _entertainment
                                                              .subCategories,
                                                          _entertainment.gems,
                                                          _entertainment
                                                              .accentColor,
                                                          _entertainment.icon)),
                                            );
                                          },
                                          child: Icon(MdiIcons.diamondStone,
                                              color:
                                                  _entertainment.primaryColor),
                                        ),
                                        SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubCategories(
                                                          _food.title,
                                                          _food.subCategories,
                                                          _food.gems,
                                                          _food.accentColor,
                                                          _food.icon)),
                                            );
                                          },
                                          child: Icon(MdiIcons.diamondStone,
                                              color: _food.primaryColor),
                                        ),
                                        SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubCategories(
                                                          _tech.title,
                                                          _tech.subCategories,
                                                          _tech.gems,
                                                          _tech.accentColor,
                                                          _tech.icon)),
                                            );
                                          },
                                          child: Icon(MdiIcons.diamondStone,
                                              color: _tech.primaryColor),
                                        ),
                                        SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubCategories(
                                                          _art.title,
                                                          _art.subCategories,
                                                          _art.gems,
                                                          _art.accentColor,
                                                          _art.icon)),
                                            );
                                          },
                                          child: Icon(MdiIcons.diamondStone,
                                              color: _art.primaryColor),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GemSectionHeader(section: _music, isLeft: true)
                              .build(context),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ContentHeadingWidget(heading: 'Music'),
                          ),
                          GemSectionLayout(section: _music).build(context),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ContentHeadingWidget(heading: 'Media'),
                          ),
                          GemSectionLayout(section: _media).build(context),
                          SizedBox(height: 20),
                          GemSectionHeader(
                                  section: _entertainment, isLeft: true)
                              .build(context),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child:
                                ContentHeadingWidget(heading: 'Entertainment'),
                          ),
                          GemSectionLayout(section: _entertainment)
                              .build(context),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ContentHeadingWidget(heading: 'Food'),
                          ),
                          GemSectionLayout(section: _food).build(context),
                          SizedBox(height: 20),
                          GemSectionHeader(section: _tech, isLeft: true)
                              .build(context),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ContentHeadingWidget(heading: 'Tech'),
                          ),
                          GemSectionLayout(section: _tech).build(context),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ContentHeadingWidget(heading: 'Art'),
                          ),
                          GemSectionLayout(section: _art).build(context),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
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
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ),
            );
          },
        )
      ],
    );
  }
}
