import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';

class Gem {
  //Required
  String name;
  String category;
  String subCategory;
  String bio;
  String photoUrl;
  String backgroundUrl;

  //Default value.
  String id;
  List<dynamic> likes = List<dynamic>(); //List of user IDs
  DateTime time;

  //Can be null.
  String email;
  String phoneNumber;
  String spotifyID;
  String iTunesID;
  String youTubeID;
  String instagramName;
  String facebookName;
  String twitterName;
  String soundCloudName;
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
