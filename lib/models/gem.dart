import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';

class Gem {
  //Required
  String name;
  String email;
  String category;
  String subCategory;

  //Default value.
  String id;
  String uid;
  List<dynamic> likes = List<dynamic>(); //List of user IDs
  DateTime time;
  bool isSafe;
  String photoUrl;
  String backgroundUrl;

  //Can be null.
  String bio;
  String phoneNumber;
  String spotifyID;
  String iTunesID;
  String youTubeID;
  String instagramName;
  String facebookName;
  String twitterName;
  String soundCloudName;

  static Gem extractDocument(DocumentSnapshot ds) {
    Gem gem = Gem();

    gem.name = ds['name'];
    gem.email = ds['email'];
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
    gem.phoneNumber = ds['phoneNumber'];
    gem.time = ds['time'].toDate();

    return gem;
  }
}

// buildGemCard(Gem gem, BuildContext context) {
//   return Card(
//     elevation: 3,
//     child: InkWell(
//       child: Row(
//         children: <Widget>[
//           Container(
//             height: 125,
//             width: 110,
//             padding: EdgeInsets.only(left: 0, top: 10, bottom: 70, right: 20),
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: NetworkImage(gem.photoUrl), fit: BoxFit.cover),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   gem.name,
//                   style: TextStyle(
//                       color: Colors.deepOrange,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 17),
//                 ),
//                 Text(
//                   gem.category,
//                   style: TextStyle(fontSize: 14, color: Colors.black87),
//                 ),
//                 Text(
//                   gem.subCategory,
//                   style: TextStyle(fontSize: 14, color: Colors.black87),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => GemProfilePage(gem.id),
//           ),
//         );
//       },
//     ),
//   );
// }
