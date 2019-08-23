// import 'package:flutter/material.dart';
// import 'package:hiddengems_flutter/pages/subCategories.dart';
// import 'package:hiddengems_flutter/widgets/avatarBuilder.dart';
// import 'package:hiddengems_flutter/models/gem.dart';

// class GemsPreview extends StatelessWidget {
//   final String mainCategory;
//   final List<String> subCategories;
//   final String description;
//   final List<Gem> gems;

//   final int gemPreviewCount = 3;

//   GemsPreview(
//       this.mainCategory, this.subCategories, this.description, this.gems);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
//         Divider(color: Colors.black),
//         Padding(
//           padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
//           child: Text(
//             this.mainCategory,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15.0,
//                 letterSpacing: 2.0,
//                 color: Colors.black),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(15),
//           child: Text(
//             this.description,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12.0,
//                 letterSpacing: 2.0,
//                 color: Colors.black),
//           ),
//         ),
//         AvatarBuilder(this.gems.sublist(0, 3)),
//         Padding(
//           padding: const EdgeInsets.only(left: 15.0),
//           child: InkWell(
//             child: Text(
//               'VIEW ALL',
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 2.0,
//                   color: Colors.black),
//             ),
//             onTap: () async {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SubCategories(
//                       this.mainCategory, this.subCategories, this.gems),
//                 ),
//               );
//             },
//           ),
//         ),
//         Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
//       ],
//     );
//   }
// }
