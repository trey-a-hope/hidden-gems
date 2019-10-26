import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/content_heading_widget.dart';
import 'package:hiddengems_flutter/common/drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/constants.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/pages/search_page.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/db.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/common/gem_section_header.dart';
import 'package:hiddengems_flutter/common/gem_section_layout.dart';
import 'package:hiddengems_flutter/models/section.dart';
import 'package:hiddengems_flutter/pages/sub_categories_page.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _isLoading = true;
  User _currentUser;

//Technology
  Section _technology = Section(
      accentColor: Colors.blue[50],
      icon: MdiIcons.laptop,
      photoUrl:
          'https://scontent-ort2-2.cdninstagram.com/vp/22e159e7668abf00d64f5774cd101978/5E1052B3/t51.2885-15/e35/67662559_2578353355550646_3002933519064807049_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com',
      primaryColor: Colors.blue,
      quote: 'Technology is creativity.',
      subCategories: TechnologyTypes,
      subQuote: '-tr3Designs',
      title: 'Technology');

//Art
  Section _art = Section(
      accentColor: Colors.brown[50],
      icon: MdiIcons.formatPaint,
      photoUrl:
          'https://mymodernmet.com/wp/wp-content/uploads/2019/03/elements-of-art-6.jpg',
      primaryColor: Colors.brown,
      quote: 'Art is everywhere.',
      subCategories: ArtTypes,
      subQuote: '-Bruh',
      title: 'Art');

//Food
  Section _food = Section(
      accentColor: Colors.red[50],
      icon: MdiIcons.food,
      photoUrl:
          'https://scontent-ort2-2.cdninstagram.com/vp/24cbcb71da97a6610c6de500654214b8/5DF20946/t51.2885-15/e35/s1080x1080/60652905_2306835062907810_3997595601856234446_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com',
      primaryColor: Colors.red,
      quote: 'Life is sweet, then sour..',
      subCategories: FoodTypes,
      subQuote: '-LBooogi_e',
      title: 'Food');

//Entertainment
  Section _entertainment = Section(
      accentColor: Colors.purple[50],
      icon: MdiIcons.saxophone,
      photoUrl:
          'https://scontent-ort2-2.cdninstagram.com/vp/c642a552e8f7cf9ea35e47e7fec20ed6/5DDE6F21/t51.2885-15/e35/46164547_932051160321720_8307918529059419068_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com',
      primaryColor: Colors.purple,
      quote: 'Lights, camera, action.',
      subCategories: EntertainmentTypes,
      subQuote: '-Ric Sexton',
      title: 'Entertainment');

//Media
  Section _media = Section(
      accentColor: Colors.orange[50],
      icon: MdiIcons.camera,
      photoUrl:
          'https://scontent-ort2-2.cdninstagram.com/vp/2ed3d13d5faaa264cdd8128ecb552da8/5DF1EAC4/t51.2885-15/e35/66276028_161884564943675_1854421925826073563_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com',
      primaryColor: Colors.orange,
      quote: 'Capture every moment.',
      subCategories: MediaTypes,
      subQuote: '-ShotBy3',
      title: 'Media');

//Music
  Section _music = Section(
      accentColor: Colors.teal[50],
      icon: MdiIcons.music,
      photoUrl:
          'https://scontent-ort2-2.cdninstagram.com/vp/d0213198fa4f02835969e8e5fbb752c8/5E100EA8/t51.2885-15/e35/66974585_2186962401426203_1803617320161352121_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com',
      primaryColor: Colors.teal,
      quote: 'Music is the key to happiness.',
      subCategories: MusicTypes,
      subQuote: '-DH The Rula',
      title: 'Music');

  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  void _load() async {
    try {
      _music.previewGems =
          await getIt<Auth>().getGems(limit: 5, category: 'Music');
      _media.previewGems =
          await getIt<Auth>().getGems(limit: 5, category: 'Media');
      _entertainment.previewGems =
          await getIt<Auth>().getGems(limit: 5, category: 'Entertainment');
      _food.previewGems =
          await getIt<Auth>().getGems(limit: 5, category: 'Food');
      _technology.previewGems =
          await getIt<Auth>().getGems(limit: 5, category: 'Technology');
      _art.previewGems = await getIt<Auth>().getGems(limit: 5, category: 'Art');

      _currentUser = await getIt<Auth>().getCurrentUser();
      if (_currentUser != null) {
        _setUpFirebaseMessaging();
      }

      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      getIt<Modal>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<void> _refresh() async {
    // await _getHeaderWidgets();
    _music.previewGems =
        await getIt<Auth>().getGems(limit: 5, category: 'Music');
    _media.previewGems =
        await getIt<Auth>().getGems(limit: 5, category: 'Media');
    _entertainment.previewGems =
        await getIt<Auth>().getGems(limit: 5, category: 'Entertainment');
    _food.previewGems = await getIt<Auth>().getGems(limit: 5, category: 'Food');
    _technology.previewGems =
        await getIt<Auth>().getGems(limit: 5, category: 'Technology');
    _art.previewGems = await getIt<Auth>().getGems(limit: 5, category: 'Art');
    setState(
      () {},
    );
  }

  void _setUpFirebaseMessaging() async {
    if (Platform.isIOS) {
      //Request permission on iOS device.
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    }

    //Update user's fcm token.
    final String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      print(fcmToken);
      getIt<DB>().updateUser(userID: _currentUser.id, data: {'fcmToken': fcmToken});
    }

    //Configure notifications for several action types.
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        getIt<Modal>().showAlert(
            context: context,
            title: message['notification']['title'],
            message: message['notification']['body']);
        //  _showItemDialog(message);
      },
      //  onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //  _navigateToItemDetail(message);
      },
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
            ? Spinner()
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
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
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
                        _entertainment.icon),
                  ),
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
                      builder: (context) => SubCategoriesPage(_food.title,
                          _food.subCategories, _food.accentColor, _food.icon)),
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
                      builder: (context) => SubCategoriesPage(_art.title,
                          _art.subCategories, _art.accentColor, _art.icon)),
                );
              },
              child: Icon(MdiIcons.diamondStone, color: _art.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
