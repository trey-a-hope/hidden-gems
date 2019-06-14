import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/widgets/avatarBuilder.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/pages/fullListing.dart';
import "dart:math";

class GemsPreview extends StatelessWidget {
  final String main_category;
  final String description;
  final List<Gem> gems;
  
  final int gemPreviewCount = 3;

  GemsPreview(this.main_category, this.description, this.gems);

  List<Gem> _getRandomGems(int amount){
    final random = Random();
    int randomIndex = random.nextInt(amount);

    List<int> randomIndexes = List<int>();
    List<Gem> randomGems = List<Gem>();

    while(randomGems.length != amount){
      if(!randomIndexes.contains(randomIndex)){
        randomIndexes.add(randomIndex);
        Gem randomGem = this.gems[randomIndex];
        randomGems.add(randomGem);
      }
    }

    return randomGems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
        Divider(color: Colors.black),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
          child: Text(
            this.main_category,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                letterSpacing: 2.0,
                color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
          child: Text(
            this.description,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                letterSpacing: 2.0,
                color: Colors.black),
          ),
        ),
        AvatarBuilder(this._getRandomGems(this.gemPreviewCount)),
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
              switch (this.main_category) {
                case 'MUSICIANS':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullListing(
                            this.main_category,
                            ['Rappers', 'Singers', 'Producers', 'Engineers', 'Instrumentalists'],
                            this.gems)));
                  break;
                default:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullListing(
                            this.main_category,
                            ['Rappers', 'Singers', 'Producers', 'Engineers', 'Instrumentalists'],
                            this.gems)));
              }
            },
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
      ],
    );
  }
}
