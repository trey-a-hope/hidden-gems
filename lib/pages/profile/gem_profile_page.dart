import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/models/like.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/db.dart';
import 'package:hiddengems_flutter/services/message.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/services/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeago/timeago.dart' as timeago;

// https://pub.dev/packages/algolia

class GemProfilePage extends StatefulWidget {
  final String id;
  GemProfilePage(this.id);

  @override
  State createState() => GemProfilePageState(id);
}

class GemProfilePageState extends State<GemProfilePage> {
  GemProfilePageState(this._id);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _id;
  User _gem;
  bool _isLoading = true;
  User _currentUser;
  final GetIt getIt = GetIt.I;
  List<Like> _likes = List<Like>();
  bool hasLikedGem;

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    try {
      _gem = await getIt<DB>().retrieveUser(userID: _id);
      _currentUser = await getIt<Auth>().getCurrentUser();
      _likes = await getIt<DB>().retrieveLikes(gemID: _gem.id);
      hasLikedGem =
          _likes.where((like) => like.userID == _currentUser.id).length > 0;

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

  _likeGem() async {
    try {
      if (hasLikedGem) {
        getIt<DB>().deleteLike(gemID: _gem.id, userID: _currentUser.id);
        _likes.removeWhere((like) => like.userID == _currentUser.id);
      } else {
        Like newLike = Like(id: '', userID: _currentUser.id);
        getIt<DB>().createLike(like: newLike, gemID: _gem.id);
        _likes.add(newLike);
      }

      hasLikedGem = !hasLikedGem;

      setState(() {});
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  _copyToClipboard(String text) async {
    try {
      if (text.isEmpty) {
        getIt<Modal>().showInSnackBar(
            scaffoldKey: _scaffoldKey,
            message: 'User did not provide this info.');
        return;
      }

      await Clipboard.setData(ClipboardData(text: text));
      getIt<Modal>().showInSnackBar(
          scaffoldKey: _scaffoldKey, message: 'Copied to clipboard.');
      // bool success = await ClipboardManager.copyToClipBoard(text);
      // if (success)
      //   Modal.showInSnackBar(_scaffoldKey, 'Copied to clipboard.');
      // else
      //   Modal.showInSnackBar(_scaffoldKey, 'Could not copy to clipboard.');

    } catch (e) {
      getIt<Modal>()
          .showInSnackBar(scaffoldKey: _scaffoldKey, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      backgroundColor: Colors.grey.shade300,
      floatingActionButton: _buildFAB(),
      body: _isLoading
          ? Spinner()
          : SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        fadeInCurve: Curves.easeIn,
                        imageUrl: _gem.backgroundUrl),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                    child: Column(
                      children: <Widget>[
                        _buildInfoBox(),
                        SizedBox(height: 20.0),
                        _buildBio(),
                        SizedBox(height: 20.0),
                        _buildSocialMedia(),
                        SizedBox(height: 75.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _buildFAB() {
    return _isLoading
        ? Container()
        : SpeedDial(
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: true,
            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'More',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(Icons.email, color: Colors.blue),
                backgroundColor: Colors.white,
                label: 'Message',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  if (_currentUser == null) {
                    getIt<Modal>().showAlert(
                        context: context,
                        title: 'Sorry',
                        message: 'You must be logged in to use this feature.');
                  } else {
                    if (_gem.id == _currentUser.id) {
                      getIt<Modal>().showAlert(
                          context: context,
                          title: 'Ummm',
                          message: 'You can\'t message yourself...');
                    } else {
                      getIt<Message>().openMessageThread(
                          context: context,
                          sender: _currentUser,
                          sendee: _gem,
                          title: _gem.name);
                    }
                  }
                },
              )
            ],
          );
  }

  _buildInfoBox() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 110.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _gem.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(_gem.category),
                      subtitle: Text(_gem.subCategory),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${_likes.length}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_likes.length == 1 ? 'Like' : 'Likes')
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          timeago.format(_gem.time),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Joined')
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: CachedNetworkImageProvider(_gem.photoUrl),
                fit: BoxFit.cover),
          ),
          margin: EdgeInsets.only(left: 16.0),
        ),
      ],
    );
  }

  _buildAppBar() {
    return _isLoading
        ? null
        : AppBar(
            centerTitle: true,
            title: Text(
              'GEM DETAILS',
              style: TextStyle(letterSpacing: 2.0),
            ),
            actions: <Widget>[
              _currentUser == null
                  ? IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                        getIt<Modal>().showAlert(
                            context: context,
                            title: 'Sorry',
                            message:
                                'You must be logged in to use this feature.');
                      },
                    )
                  : IconButton(
                      icon: hasLikedGem
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border),
                      onPressed: () {
                        _likeGem();
                      },
                    )
            ],
          );
  }

  _buildBio() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Bio',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(_gem.bio),
          )
        ],
      ),
    );
  }

  _buildSocialMedia() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Social Media',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          _gem.instagramUrl.isEmpty
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("Instagram"),
                    // subtitle: Text('@${_gem.instagramName}'),
                    leading: Icon(
                      MdiIcons.instagram,
                      color: Colors.pink,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(_gem.instagramUrl);
                  },
                ),
          _gem.twitterUrl.isEmpty
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("Twitter"),
                    // subtitle: Text('@${_gem.twitterName}'),
                    leading: Icon(
                      MdiIcons.twitter,
                      color: Colors.lightBlue,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(_gem.twitterUrl);
                  },
                ),
          _gem.facebookUrl.isEmpty
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("Facebook"),
                    // subtitle: Text('${_gem.facebookName}'),
                    leading: Icon(
                      MdiIcons.facebook,
                      color: Colors.blue,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(_gem.facebookUrl);
                  },
                ),
          _gem.youTubeUrl.isEmpty
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("YouTube"),
                    // subtitle: Text('${_gem.youTubeID}'),
                    leading: Icon(
                      MdiIcons.youtube,
                      color: Colors.red,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(_gem.youTubeUrl);
                  },
                ),
          _gem.spotifyUrl.isEmpty
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("Spotify"),
                    // subtitle: Text('${_gem.spotifyID}'),
                    leading: Icon(
                      MdiIcons.spotify,
                      color: Colors.green,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(_gem.spotifyUrl);
                  },
                ),
          _gem.iTunesUrl.isEmpty
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("iTunes"),
                    // subtitle: Text('${_gem.iTunesID}'),
                    leading: Icon(
                      MdiIcons.itunes,
                      color: Colors.grey,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(_gem.iTunesUrl);
                  },
                ),
          _gem.soundCloudUrl.isEmpty
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("SoundCloud"),
                    // subtitle: Text('${_gem.soundCloudName}'),
                    leading: Icon(
                      MdiIcons.soundcloud,
                      color: Colors.orange,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(_gem.soundCloudUrl);
                  },
                ),
        ],
      ),
    );
  }
}
