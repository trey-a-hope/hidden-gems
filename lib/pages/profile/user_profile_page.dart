import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:timeago/timeago.dart' as timeago;

// https://pub.dev/packages/algolia

class UserProfilePage extends StatefulWidget {
  final String id;
  UserProfilePage(this.id);

  @override
  State createState() => UserProfilePageState(id);
}

class UserProfilePageState extends State<UserProfilePage> {
  UserProfilePageState(this._id);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _id;
  User _user;
  bool _isLoading = true;
  User _currentUser;
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    _user = await getIt<Auth>().getUser(id: _id);
    _currentUser = await getIt<Auth>().getCurrentUser();

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
      backgroundColor: Colors.grey.shade300,
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
                        imageUrl: _user.backgroundUrl),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                    child: Column(
                      children: <Widget>[
                        _buildInfoBox(),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                      _user.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text('General User'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  // Expanded(
                  //   child: Column(
                  //     children: <Widget>[
                  //       Text(
                  //         '${_gemLikes.length}',
                  //         style: TextStyle(fontWeight: FontWeight.bold),
                  //       ),
                  //       Text(_gemLikes.length == 1 ? 'Like' : 'Likes')
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          timeago.format(_user.time),
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
                image: CachedNetworkImageProvider(_user.photoUrl),
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
          );
  }
}
