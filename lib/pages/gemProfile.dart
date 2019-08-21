import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hiddengems_flutter/services/urlLauncher.dart';

class GemProfilePage extends StatefulWidget {
  final Gem gem;
  GemProfilePage(this.gem);

  @override
  State createState() => GemProfilePageState(gem);
}

class GemProfilePageState extends State<GemProfilePage>
    with SingleTickerProviderStateMixin {
  final Gem gem;
  GemProfilePageState(this.gem);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'GEM DETAILS',
            style: TextStyle(letterSpacing: 2.0),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                Modal.showAlert(context, 'Todo', 'Favorite gem.');
              },
            )
          ]),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 250,
              width: double.infinity,
              child: CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(),
                  fit: BoxFit.cover,
                  fadeInCurve: Curves.easeIn,
                  imageUrl: gem.backgroundUrl),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Stack(
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
                              margin: EdgeInsets.only(left: 96.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    gem.name,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: Text(gem.category),
                                    subtitle: Text(gem.subCategory),
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
                                        '${gem.likes}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Likes')
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Comments")
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Favourites")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.0, color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(gem.photoUrl),
                              fit: BoxFit.cover),
                        ),
                        margin: EdgeInsets.only(left: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Information',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Age'),
                          subtitle: Text('${gem.age}'),
                          leading: Icon(Icons.cake, color: Colors.teal),
                        ),
                        ListTile(
                          title: Text('Bio'),
                          subtitle: Text(gem.bio),
                          leading: Icon(Icons.person, color: Colors.deepOrange),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Social Media',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(),
                        InkWell(
                          child: ListTile(
                            title: Text("Instagram"),
                            subtitle: Text('@${gem.instagramName}'),
                            leading: Icon(
                              MdiIcons.instagram,
                              color: Colors.purple,
                            ),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          onTap: () {
                            URLLauncher.launchUrl(
                                'https://www.instagram.com/${gem.instagramName}');
                          },
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text("Twitter"),
                            subtitle: Text('TODO'),
                            leading: Icon(
                              MdiIcons.twitter,
                              color: Colors.lightBlue,
                            ),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          onTap: () {
                            URLLauncher.launchUrl(
                                'https://www.instagram.com/${gem.instagramName}');
                          },
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text("Facebook"),
                            subtitle: Text('TODO'),
                            leading: Icon(
                              MdiIcons.facebook,
                              color: Colors.blue,
                            ),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          onTap: () {
                            URLLauncher.launchUrl(
                                'https://www.instagram.com/${gem.instagramName}');
                          },
                        ),
                        InkWell(
                          child: ListTile(
                            title: Text("YouTube"),
                            subtitle: Text('TODO'),
                            leading: Icon(
                              MdiIcons.youtube,
                              color: Colors.red,
                            ),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          onTap: () {
                            URLLauncher.launchUrl(
                                'https://www.instagram.com/${gem.instagramName}');
                          },
                        ),
                        gem.category == 'Musician'
                            ? InkWell(
                                child: ListTile(
                                  title: Text("Spotify"),
                                  subtitle: Text('TODO'),
                                  leading: Icon(
                                    MdiIcons.spotify,
                                    color: Colors.green,
                                  ),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                                onTap: () {
                                  URLLauncher.launchUrl(
                                      'https://www.instagram.com/${gem.instagramName}');
                                },
                              )
                            : Container(),
                        gem.category == 'Musician'
                            ? InkWell(
                                child: ListTile(
                                  title: Text("SoundCloud"),
                                  subtitle: Text('TODO'),
                                  leading: Icon(
                                    MdiIcons.soundcloud,
                                    color: Colors.orange,
                                  ),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                                onTap: () {
                                  URLLauncher.launchUrl(
                                      'https://www.instagram.com/${gem.instagramName}');
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            // )
          ],
        ),
      ),
    );
  }
}
