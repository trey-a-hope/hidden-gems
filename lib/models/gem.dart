import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';

class Gem {
  String backgroundUrl;
  String bio;
  String category;
  String email;
  String facebookName;
  String iTunesID;
  String id;
  String instagramName;
  List<dynamic> likes = List<dynamic>(); //List of user IDs
  String name;
  String phoneNumber;
  String photoUrl;
  String soundCloudName;
  String spotifyID;
  String subCategory;
  DateTime time;
  String twitterName;
  String uid; //For authentication.
  String youTubeID;

  static Gem extractDocument(DocumentSnapshot ds) {
    Gem gem = Gem();

    gem.bio = ds['bio'];
    gem.backgroundUrl = ds['backgroundUrl'];
    gem.category = ds['category'];
    gem.email = ds['email'];
    gem.facebookName = ds['facebookName'];
    gem.iTunesID = ds['iTunesID'];
    gem.id = ds['id'];
    gem.instagramName = ds['instagramName'];
    gem.likes = ds['likes'];
    gem.name = ds['name'];
    gem.phoneNumber = ds['phoneNumber'];
    gem.photoUrl = ds['photoUrl'];
    gem.soundCloudName = ds['soundCloudName'];
    gem.spotifyID = ds['spotifyID'];
    gem.subCategory = ds['subCategory'];
    gem.time = ds['time'].toDate();
    gem.twitterName = ds['twitterName'];
    gem.uid = ds['uid'];
    gem.youTubeID = ds['youTubeID'];

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
