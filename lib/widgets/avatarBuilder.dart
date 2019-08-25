import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarBuilder extends StatelessWidget {
  final List<Gem> gems;
  AvatarBuilder(this.gems);

  @override
  Widget build(BuildContext context) {
    return Container(
      //aspectRatio: 16/15,
      height: 205.0,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: this.gems.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            Gem gem = gems[i];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 0.0),
              child: Column(
                children: <Widget>[
                  InkResponse(
                    child: SizedBox(
                      child: Hero(
                        tag: gem.name,
                        child: Container(
                            height: 130.0,
                            width: 130.0,
                            child: CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(gem.photoUrl),
                            )),
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
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Padding(
                      // padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              gem.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Center(
                            child: Text(
                              gem.subCategory.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
