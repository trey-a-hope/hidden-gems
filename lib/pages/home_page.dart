import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/content_heading_widget.dart';
import 'package:hiddengems_flutter/common/drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/pages/search_page.dart';
import 'package:hiddengems_flutter/services/auth.dart';
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
  final CollectionReference _miscellaneousDB =
      Firestore.instance.collection('Miscellaneous');
  final CollectionReference _usersDB = Firestore.instance.collection('Users');
  // final CollectionReference _gemsDB = Firestore.instance.collection('Gems');
  final FirebaseMessaging _fcm = FirebaseMessaging();

  bool _isLoading = true;

  Section _music = Section('Music');
  Section _media = Section('Media');
  Section _entertainment = Section('Entertainment');
  Section _food = Section('Food');
  Section _technology = Section('Technology');
  Section _art = Section('Art');
  Section _trade = Section('Trade');
  Section _beauty = Section('Beauty');

  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  // void moveGemsToUsersTable() async {
  //   QuerySnapshot querySnapshot = await _gemsDB.getDocuments();
  //   for (int i = 0; i < querySnapshot.documents.length; i++) {
  //     Map<String, dynamic> data = querySnapshot.documents[i].data;
  //     User user = User(
  //         backgroundUrl: data['backgroundUrl'],
  //         instagramUrl: '',
  //         category: data['category'],
  //         email: data['email'],
  //         phoneNumber: data['phoneNumber'],
  //         facebookUrl: '',
  //         id: '',
  //         spotifyUrl: '',
  //         uid: data['uid'],
  //         isGem: true,
  //         iTunesUrl: '',
  //         soundCloudUrl: '',
  //         time: data['time'].toDate(),
  //         name: data['name'],
  //         photoUrl: data['photoUrl'],
  //         subCategory: data['subCategory'],
  //         youTubeUrl: '',
  //         twitterUrl: '',
  //         fcmToken: '',
  //         bio: data['bio']);
  //     DocumentReference docRef = await _usersDB.add(
  //       user.toMap(),
  //     );

  //     _usersDB.document(docRef.documentID).updateData(
  //       {'id': docRef.documentID},
  //     );
  //   }
  //   getIt<Modal>()
  //       .showInSnackBar(scaffoldKey: _scaffoldKey, message: 'Users added.');
  // }

  _getHeaderWidgets() async {
    DocumentSnapshot ds = await _miscellaneousDB.document('HomePage').get();

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

  _getGems() async {
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
    _trade.previewGems =
        await getIt<Auth>().getGems(limit: 5, category: 'Trade');
    _beauty.previewGems =
        await getIt<Auth>().getGems(limit: 5, category: 'Beauty');
  }

  void _load() async {
    await _getHeaderWidgets();
    await _getGems();

    // moveGemsToUsersTable();
    FirebaseUser firebaseUser = await getIt<Auth>().getFirebaseUser();
    if (firebaseUser != null) {
      _setUpFirebaseMessaging(firebaseUser: firebaseUser);
    }

    setState(
      () {
        _isLoading = false;
      },
    );
  }

  Future<void> _refresh() async {
    await _getHeaderWidgets();
    await _getGems();
    setState(
      () {},
    );
  }

  void _setUpFirebaseMessaging({@required FirebaseUser firebaseUser}) async {
    //Fetch the ID of the user document.
    QuerySnapshot querySnapshot =
        await _usersDB.where('uid', isEqualTo: firebaseUser.uid).getDocuments();
    DocumentSnapshot documentSnapshot = querySnapshot.documents.first;
    String id = documentSnapshot.data['id'];

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
      _usersDB.document(id).updateData(
        {'fcmToken': fcmToken},
      );
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
                            child: ContentHeadingWidget(heading: 'Beauty'),
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
