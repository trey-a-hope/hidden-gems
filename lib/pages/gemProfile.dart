import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/services/urlLauncher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:device_id/device_id.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class GemProfilePage extends StatefulWidget {
  final String id;
  GemProfilePage(this.id);

  @override
  State createState() => GemProfilePageState(id);
}

class GemProfilePageState extends State<GemProfilePage>
    with SingleTickerProviderStateMixin {
  GemProfilePageState(this._id);
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  final String _id; //Gem ID
  final Color _iconColor = Colors.grey;
  final _db = Firestore.instance;
  String _deviceId; //Viewer ID
  Gem _gem;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  _loadPage() async {
    _deviceId = await _fetchDeviceID();
    Modal.showAlert(context, 'ID', _deviceId);
    _gem = await _fetchGem();

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _fetchDeviceID() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    }
  }

  _fetchGem() async {
    DocumentSnapshot ds = await _db.collection('Gems').document(_id).get();
    Gem gem = Gem();

    gem.id = ds['id'];
    gem.name = ds['name'];
    gem.bio = ds['bio'];
    gem.category = ds['category'];
    gem.subCategory = ds['subCategory'];
    gem.photoUrl = ds['photoUrl'];
    gem.likes = ds['likes'];
    gem.instagramName = ds['instagramName'];
    gem.backgroundUrl = ds['backgroundUrl'];
    gem.spotifyID = ds['spotifyID'];
    gem.twitterName = ds['twitterName'];
    gem.facebookName = ds['facebookName'];
    gem.youTubeID = ds['youTubeID'];
    gem.soundCloudName = ds['soundCloudName'];
    gem.iTunesID = ds['iTunesID'];
    gem.email = ds['email'];
    gem.phoneNumber = ds['phoneNumber'];
    gem.time = ds['time'].toDate();

    return gem;
  }

  _likeGem() async {
    List<dynamic> likes = List.from(_gem.likes);

    if (likes.contains(_deviceId)) {
      likes.remove(_deviceId);
    } else {
      likes.add(_deviceId);
    }

    await _db.collection('Gems').document(_gem.id).updateData({'likes': likes});

    setState(() {
      _gem.likes = likes;
    });
  }

  _text() async {
    if (_gem.phoneNumber == null) {
      Modal.showAlert(
          context, 'Sorry', 'This user did not provide an phone number.');
    } else {
      // Android
      String uri = 'sms:+${_gem.phoneNumber}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        // iOS
        String uri = 'sms:00${_gem.phoneNumber}';
        if (await canLaunch(uri)) {
          await launch(uri);
        } else {
          throw 'Could not launch $uri';
        }
      }
    }
  }

  _email() async {
    if (_gem.email == null) {
      Modal.showAlert(context, 'Sorry', 'This user did not provide an email.');
    } else {
      String uri =
          'mailto:${_gem.email}?subject=Greetings!&body=Hello ${_gem.name}, how are you?';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  _call() async {
    if (_gem.phoneNumber == null) {
      Modal.showAlert(
          context, 'Sorry', 'This user did not provide an phone number.');
    } else {
      // Android
      String uri = 'tel:+1${_gem.phoneNumber}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        // iOS
        String uri = 'tel:00${_gem.phoneNumber}8';
        if (await canLaunch(uri)) {
          await launch(uri);
        } else {
          throw 'Could not launch $uri';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.grey.shade300,
      floatingActionButton: _buildFAB(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
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
                  child: List.from(_gem.likes).contains(_deviceId)
                      ? Icon(Icons.thumb_down, color: Colors.red)
                      : Icon(Icons.thumb_up, color: Colors.green),
                  backgroundColor: Colors.white,
                  label: List.from(_gem.likes).contains(_deviceId)
                      ? 'Unlike'
                      : 'Like',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () => _likeGem()),
              SpeedDialChild(
                child: Icon(Icons.email, color: Colors.blue),
                backgroundColor: Colors.white,
                label: 'Email',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => _email(),
              ),
              SpeedDialChild(
                child: Icon(Icons.phone, color: Colors.orange),
                backgroundColor: Colors.white,
                label: 'Call',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => _call(),
              ),
              SpeedDialChild(
                child: Icon(Icons.textsms, color: Colors.purple),
                backgroundColor: Colors.white,
                label: 'Text',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => _text(),
              )
            ],
          );
    // FloatingActionButton(
    //     backgroundColor: Colors.white,
    //     child: List.from(_gem.likes).contains(_deviceId)
    //         ? Icon(Icons.favorite, color: Colors.red)
    //         : Icon(Icons.favorite_border, color: Colors.red),
    //     onPressed: () {
    //       _likeGem();
    //     },
    //   );
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
                          '${_gem.likes.length}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_gem.likes.length == 1 ? 'Like' : 'Likes')
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
            border: Border.all(width: 2.0, color: Colors.white),
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
    return AppBar(
      centerTitle: true,
      title: Text(
        'GEM DETAILS',
        style: TextStyle(letterSpacing: 2.0),
      ),
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
          _gem.instagramName == null
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("Instagram"),
                    subtitle: Text('@${_gem.instagramName}'),
                    leading: Icon(
                      MdiIcons.instagram,
                      color: _iconColor,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(
                        'https://www.instagram.com/${_gem.instagramName}');
                  },
                ),
          _gem.twitterName == null
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("Twitter"),
                    subtitle: Text('@${_gem.twitterName}'),
                    leading: Icon(
                      MdiIcons.twitter,
                      color: _iconColor,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(
                        'https://twitter.com/${_gem.twitterName}');
                  },
                ),
          _gem.facebookName == null
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("Facebook"),
                    subtitle: Text('${_gem.facebookName}'),
                    leading: Icon(
                      MdiIcons.facebook,
                      color: _iconColor,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(
                        'https://www.facebook.com/${_gem.facebookName}');
                  },
                ),
          _gem.youTubeID == null
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("YouTube"),
                    subtitle: Text('${_gem.youTubeID}'),
                    leading: Icon(
                      MdiIcons.youtube,
                      color: _iconColor,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(
                        'https://www.instagram.com/${_gem.instagramName}');
                  },
                ),
          _gem.spotifyID == null
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("Spotify"),
                    subtitle: Text('${_gem.spotifyID}'),
                    leading: Icon(
                      MdiIcons.spotify,
                      color: _iconColor,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(
                        'https://open.spotify.com/artist/${_gem.spotifyID}');
                  },
                ),
          _gem.iTunesID == null
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("iTunes"),
                    subtitle: Text('${_gem.iTunesID}'),
                    leading: Icon(
                      MdiIcons.itunes,
                      color: _iconColor,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(
                        'https://music.apple.com/us/artist/${_gem.iTunesID}');
                  },
                ),
          _gem.soundCloudName == null
              ? Container()
              : InkWell(
                  child: ListTile(
                    title: Text("SoundCloud"),
                    subtitle: Text('${_gem.soundCloudName}'),
                    leading: Icon(
                      MdiIcons.soundcloud,
                      color: _iconColor,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  onTap: () {
                    URLLauncher.launchUrl(
                        'https://soundcloud.com/${_gem.soundCloudName}');
                  },
                ),
        ],
      ),
    );
  }
}
