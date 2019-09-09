import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/common/content_heading_widget.dart';
import 'package:hiddengems_flutter/common/drawer_widget.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/pages/search.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/common/gem_section_header.dart';
import 'package:hiddengems_flutter/common/gem_section_layout.dart';
import 'package:hiddengems_flutter/models/section.dart';
import 'package:hiddengems_flutter/pages/sub_categories.dart';

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

  Section _music = Section('Music');
  Section _media = Section('Media');
  Section _entertainment = Section('Entertainment');
  Section _food = Section('Food');
  Section _technology = Section('Technology');
  Section _art = Section('Art');
  Section _trade = Section('Trade');
  Section _beauty = Section('Beauty');

  @override
  void initState() {
    super.initState();

    loadPage();
  }

  //Fetch 5 most recent gems in each category.
  Future<List<Gem>> _getGems(String category) async {
    QuerySnapshot querySnapshot = await _db
        .collection('Gems')
        .where('category', isEqualTo: category)
        .orderBy('time', descending: true)
        .limit(5)
        .getDocuments();
    List<DocumentSnapshot> docSnapshots = querySnapshot.documents;
    List<Gem> gems = List<Gem>();
    for (DocumentSnapshot docSnapshot in docSnapshots) {
      Gem gem = Gem();

      gem.id = docSnapshot['id'];
      gem.name = docSnapshot['name'];
      gem.category = docSnapshot['category'];
      gem.subCategory = docSnapshot['subCategory'];
      gem.photoUrl = docSnapshot['photoUrl'];
      gem.likes = docSnapshot['likes'];

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

    dynamic technologyData = data['technology'];
    _technology.quote = technologyData['quote'];
    _technology.subQuote = technologyData['subQuote'];
    _technology.photoUrl = technologyData['photoUrl'];
    _technology.subCategories = List.from(technologyData['subCategories']);
    _technology.primaryColor = Colors.blue;
    _technology.accentColor = Colors.blue[50];
    _technology.icon = MdiIcons.laptop;

    dynamic artData = data['art'];
    _art.quote = artData['quote'];
    _art.subQuote = artData['subQuote'];
    _art.photoUrl = artData['photoUrl'];
    _art.subCategories = List.from(artData['subCategories']);
    _art.primaryColor = Colors.brown;
    _art.accentColor = Colors.brown[50];
    _art.icon = MdiIcons.formatPaint;

    dynamic tradeData = data['trade'];
    _trade.quote = tradeData['quote'];
    _trade.subQuote = tradeData['subQuote'];
    _trade.photoUrl = tradeData['photoUrl'];
    _trade.subCategories = List.from(tradeData['subCategories']);
    _trade.primaryColor = Colors.cyan;
    _trade.accentColor = Colors.cyan[50];
    _trade.icon = MdiIcons.electricSwitch;

    dynamic beautyData = data['beauty'];
    _beauty.quote = beautyData['quote'];
    _beauty.subQuote = beautyData['subQuote'];
    _beauty.photoUrl = beautyData['photoUrl'];
    _beauty.subCategories = List.from(beautyData['subCategories']);
    _beauty.primaryColor = Colors.amber;
    _beauty.accentColor = Colors.amber[50];
    _beauty.icon = MdiIcons.bagPersonalOutline;
  }

  _attachGems() async {
    _music.previewGems = await _getGems('Music');
    _media.previewGems = await _getGems('Media');
    _entertainment.previewGems = await _getGems('Entertainment');
    _food.previewGems = await _getGems('Food');
    _technology.previewGems = await _getGems('Technology');
    _art.previewGems = await _getGems('Art');
    _trade.previewGems = await _getGems('Trade');
    _beauty.previewGems = await _getGems('Beauty');
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
                            child: _buildGemShortcut(),
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
                          GemSectionHeader(section: _technology, isLeft: true)
                              .build(context),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ContentHeadingWidget(heading: 'Technology'),
                          ),
                          GemSectionLayout(section: _technology).build(context),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ContentHeadingWidget(heading: 'Art'),
                          ),
                          GemSectionLayout(section: _art).build(context),
                          SizedBox(height: 20),
                          GemSectionHeader(section: _trade, isLeft: true)
                              .build(context),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ContentHeadingWidget(heading: 'Trade'),
                          ),
                          GemSectionLayout(section: _trade).build(context),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child:
                                ContentHeadingWidget(heading: 'Beauty'),
                          ),
                          GemSectionLayout(section: _beauty).build(context),
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

  _buildGemShortcut() {
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                          _music.title,
                          _music.subCategories,
                          _music.accentColor,
                          _music.icon)),
                );
              },
              child: Icon(MdiIcons.diamondStone, color: _music.primaryColor),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubCategoriesPage(_media.title,
                        _media.subCategories, _media.accentColor, _media.icon),
                  ),
                );
              },
              child: Icon(MdiIcons.diamondStone, color: _media.primaryColor),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                          _entertainment.title,
                          _entertainment.subCategories,
                          _entertainment.accentColor,
                          _entertainment.icon)),
                );
              },
              child: Icon(MdiIcons.diamondStone,
                  color: _entertainment.primaryColor),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                          _food.title,
                          _food.subCategories,
                          _food.accentColor,
                          _food.icon)),
                );
              },
              child: Icon(MdiIcons.diamondStone, color: _food.primaryColor),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                          _technology.title,
                          _technology.subCategories,
                          _technology.accentColor,
                          _technology.icon)),
                );
              },
              child:
                  Icon(MdiIcons.diamondStone, color: _technology.primaryColor),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                          _art.title,
                          _art.subCategories,
                          _art.accentColor,
                          _art.icon)),
                );
              },
              child: Icon(MdiIcons.diamondStone, color: _art.primaryColor),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                          _trade.title,
                          _trade.subCategories,
                          _trade.accentColor,
                          _trade.icon)),
                );
              },
              child: Icon(MdiIcons.diamondStone, color: _trade.primaryColor),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoriesPage(
                          _beauty.title,
                          _beauty.subCategories,
                          _beauty.accentColor,
                          _beauty.icon)),
                );
              },
              child: Icon(MdiIcons.diamondStone, color: _beauty.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
