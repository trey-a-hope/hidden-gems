import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GemCard extends StatelessWidget {
  final Gem gem;
  GemCard(this.gem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: Container(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 50.0,
                child: gemCard,
              ),
              Positioned(top: 7.5, child: gemImage),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GemProfilePage(gem.id),
          ),
        );
      },
    );
  }

  Widget get gemImage {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(gem.photoUrl),
        ),
      ),
    );
  }

  Widget get gemCard {
    return Container(
      width: 290.0,
      height: 115.0,
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 64.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(gem.name, style: TextStyle(color: Colors.black, fontSize: 20)),
              Text(gem.subCategory,style: TextStyle(color: Colors.grey, fontSize: 16)),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.thumb_up
                  ),
                  SizedBox(width: 10),
                  Text(gem.likes.length == 1 ? '1 like' : '${gem.likes.length} likes')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
