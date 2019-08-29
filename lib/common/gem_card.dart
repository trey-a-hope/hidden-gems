import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GemCard extends StatelessWidget {
  final Gem gem;
  const GemCard({Key key, this.gem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GemProfilePage(gem.id),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(gem.photoUrl),
            ),
            title: Text(gem.name),
            subtitle:
                Text('${gem.category} / ${gem.subCategory}'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Divider()
      ],
    );
  }
}
