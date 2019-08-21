import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/pages/gemInfo.dart';

class GemListTile extends StatelessWidget {
  final Gem gem;
  GemListTile(this.gem);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(gem.photoUrl),
          ),
          title: Text(gem.name),
          subtitle: Text(gem.subCategory),
          trailing: _simplePopup(context)),
    );
  }

  Widget _simplePopup(BuildContext context) => PopupMenuButton<int>(
        onSelected: (index) {
          switch (index) {
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GemInfoPage(gem)));
              break;
            case 2:
              Modal.showAlert(context, 'Send Email', 'Coming Soon...');
              break;
            default:
              break;
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("View"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Send Email"),
              ),
            ],
      );
}
