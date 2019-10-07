import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/pages/profile/gem_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GemCard extends StatelessWidget {
  final User gem;
  const GemCard({Key key, this.gem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GemProfilePage(gem.id),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(gem.photoUrl),
          ),
          title: Text(gem.name),
          subtitle: Text('${gem.category} / ${gem.subCategory}'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider()
      ],
    );
  }
}
