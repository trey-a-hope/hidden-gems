import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/pages/profile/gem_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hiddengems_flutter/pages/profile/user_profile_page.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            if (user.isGem) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GemProfilePage(user.id),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(user.id),
                ),
              );
            }
          },
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          ),
          title: Text(user.name),
          subtitle: user.isGem
              ? Text('${user.category} / ${user.subCategory}')
              : Text('General Member'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider()
      ],
    );
  }
}
