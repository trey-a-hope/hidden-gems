import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/fullListing.dart';
import 'package:hiddengems_flutter/widgets/avatarBuilder.dart';
import 'package:hiddengems_flutter/widgets/gemsPreview.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/pages/settings.dart';
import 'package:hiddengems_flutter/models/gem.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  
  List<Gem> gems_musicians = new List<Gem>();
  List<Gem> gems_designers = new List<Gem>();
  List<Gem> gems_photographers = new List<Gem>();

  GemsPreview gems_preview_musicians;

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  void loadPage() async {

    //TEST
    Gem user = new Gem();
    user.name = "Trey Hope";
    user.bio =
        "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";
    user.path =
        "https://pbs.twimg.com/profile_images/1130307959026835457/MuzmNf0T_400x400.jpg";
            Gem user2 = new Gem();
    user2.name = "Trey Hopee";
    user2.bio =
        "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";
    user2.path =
        "https://pbs.twimg.com/profile_images/1130307959026835457/MuzmNf0T_400x400.jpg";
            Gem user3 = new Gem();
    user3.name = "Trey Hopeee";
    user3.bio =
        "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";
    user3.path =
        "https://pbs.twimg.com/profile_images/1130307959026835457/MuzmNf0T_400x400.jpg";

    this.gems_musicians.addAll([user, user2, user3]);


    setState(() {
      this._isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(centerTitle: true, title: Text('Hidden Gems', style: TextStyle(fontFamily: 'RobotoMono')), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              })
        ]),
        body: Builder(
            builder: (context) => this._isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(physics: BouncingScrollPhysics(), slivers: <
                    Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                      Container(
                          constraints: BoxConstraints.expand(
                            height: 250.0,
                          ),
                          padding: EdgeInsets.only(
                              left: 16.0, bottom: 8.0, right: 16.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.luminosity),
                              image: NetworkImage(
                                  "http://gemboutiquepa.com/wp-content/uploads/2014/08/Mix4.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: 0.0,
                                top: 40.0,
                                child: Text(
                                  "Hidden Gems",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0),
                                ),
                              ),
                              Positioned(
                                top: 70.0,
                                left: 0.0,
                                child: Container(
                                  height: 2.0,
                                  width: 150.0,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Positioned(
                                  top: 80.0,
                                  left: 0.0,
                                  child: Text('Click \'?\' to see how to play.',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0))),
                              Positioned(
                                  right: 0.0,
                                  bottom: 0.0,
                                  child: IconButton(
                                      icon: Icon(Icons.help),
                                      onPressed: () async {
                                        // bool yes =
                                        //     await Modal.showConfirmation(
                                        //         context,
                                        //         this._wgDescription,
                                        //         'Want to play?');
                                        // if (yes) {
                                        //   bool open = await Modal.leaveApp(
                                        //       context,
                                        //       'the weekly giveaway page.');
                                        //   if (open) {
                                        //     URLLauncher.launchUrl(
                                        //         this._wgUrl);
                                        //   }
                                        // }
                                      })),
                              Positioned(
                                  left: 0.0,
                                  top: 10.0,
                                  child: Text(
                                    'Weekly Giveaway'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0),
                                  )),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 10.0),
                        child: Text(
                          'What is Hidden Gems?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              letterSpacing: 2.0,
                              color: Colors.black),
                        ),
                      ),
                                           Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 10.0),
                        child: Text(
                          'A one stop shop for finding all the \'Gems\' the city of Dayton has. Alot of the time, talent is overlooked for several reasons, so we wanted to showcase it in a way that would bring the community together and allow us to use one another in a sufficient way.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              letterSpacing: 2.0,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0)),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                      //     Column(
                      //       children: <Widget>[
                      //         IconButton(
                      //             icon: Icon(Icons.lightbulb_outline,
                      //                 color: Colors.orange),
                      //             iconSize: 60,
                      //             onPressed: () {
                      //               // Navigator.push(
                      //               //     context,
                      //               //     MaterialPageRoute(
                      //               //         builder: (context) =>
                      //               //             SuggestionsPage()));
                      //             }),
                      //         Text('Suggestions',
                      //             style:
                      //                 TextStyle(fontWeight: FontWeight.bold)),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         IconButton(
                      //             icon: Icon(Icons.shopping_cart,
                      //                 color: Colors.lightBlue),
                      //             iconSize: 60,
                      //             onPressed: () {
                      //               // Navigator.push(
                      //               //     context,
                      //               //     MaterialPageRoute(
                      //               //         builder: (context) =>
                      //               //             ShopPage()));
                      //             }),
                      //         Text('Shop',
                      //             style:
                      //                 TextStyle(fontWeight: FontWeight.bold)),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         IconButton(
                      //             icon: Icon(MdiIcons.music,
                      //                 color: Colors.green[200]),
                      //             iconSize: 60,
                      //             onPressed: () {
                      //               Modal.showInSnackBar(context, 'Music Page Coming Soon...');
                      //               // Navigator.push(
                      //               //     context,
                      //               //     MaterialPageRoute(
                      //               //         builder: (context) => MusicPage()));
                      //             }),
                      //         Text('Music',
                      //             style:
                      //                 TextStyle(fontWeight: FontWeight.bold)),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: <Widget>[
                      //         IconButton(
                      //             icon: Icon(MdiIcons.information,
                      //                 color: Colors.red[200]),
                      //             iconSize: 60,
                      //             onPressed: () {
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           AboutPage()));
                      //             }),
                      //         Text('About',
                      //             style:
                      //                 TextStyle(fontWeight: FontWeight.bold)),
                      //       ],
                      //     )
                      //   ],
                      // ),

                      GemsPreview(
                        'MUSICIANS', 
                        'Some of the best rappers, singers, producers, engineers, and much more take hold of this list. Ideal for making some of the hottest music the city of Dayton has to offer.', 
                        gems_musicians
                      ),


                    //   Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 8.0)),
                    //   Divider(color: Colors.black),
                    //   Padding(
                    //     padding: const EdgeInsets.only(
                    //         left: 15.0, top: 15.0, bottom: 10.0),
                    //     child: Text(
                    //       'MUSICIANS - ${this.gems_musicians.length}',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 15.0,
                    //           letterSpacing: 2.0,
                    //           color: Colors.black),
                    //     ),
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.only(
                    //         left: 15.0, top: 15.0, bottom: 10.0),
                    //     child: Text(
                    //       'Some of the best rappers, singers, producers, engineers, and much more take hold of this list. Ideal for making some of the hottest music the city of Dayton has to offer.',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 12.0,
                    //           letterSpacing: 2.0,
                    //           color: Colors.black),
                    //     ),
                    //   ),
                    //   ab(this.gems_musicians),
                    //   Padding(
                    //     padding: const EdgeInsets.only(left: 15.0),
                    //     child: InkWell(
                    //       child: Text(
                    //         'VIEW ALL',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             letterSpacing: 2.0,
                    //             color: Colors.black),
                    //       ),
                    //       onTap: () async {
                    //         Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => FullListing()));
                    //       },
                    //     ),
                    //   ),


                      /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/


                      Divider(color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 10.0),
                        child: Text(
                          'DESIGNERS - ${this.gems_designers.length}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              letterSpacing: 2.0,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 10.0),
                        child: Text(
                          'From clothing design to logo design, these group of individuals are perfect for creating visually appealing content.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              letterSpacing: 2.0,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: InkWell(
                          child: Text(
                            'VIEW ALL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                color: Colors.black),
                          ),
                          onTap: () async {
                            Modal.showInSnackBar(context, 'View All');
                            // bool open = await Modal.leaveApp(
                            //     context, 'our Instagram page.');
                            // if (open) {
                            //   URLLauncher.launchUrl(
                            //       'https://www.instagram.com/tr3.designs');
                            // }
                          },
                        ),
                      ),
                      Divider(color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 10.0),
                        child: Text(
                          'PHOTO/VIDEOGRAPHERS - ${this.gems_photographers.length}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              letterSpacing: 2.0,
                              color: Colors.black),
                        ),
                      ),
                                           Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 10.0),
                        child: Text(
                          'A picture is worth a thousand words, a video can leave you speechless. The people in this group are responsible for capturing moments in the city.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              letterSpacing: 2.0,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: InkWell(
                          child: Text(
                            'VIEW ALL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                color: Colors.black),
                          ),
                          onTap: () async {
                            Modal.showInSnackBar(context, 'View All');
                            // bool open = await Modal.leaveApp(
                            //     context, 'our Instagram page.');
                            // if (open) {
                            //   URLLauncher.launchUrl(
                            //       'https://www.instagram.com/tr3.designs');
                            // }
                          },
                        ),
                      ),
                      Divider(color: Colors.black),
                    ]))
                  ])));
  }
}
