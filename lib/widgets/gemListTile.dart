import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';

class GemListTile extends StatelessWidget {
  final Gem gem;
  GemListTile(this.gem);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(gem.path),
          ),
          title: Text(gem.name),
          subtitle: Text(gem.sub_category),
          trailing: _simplePopup()),
    );
  }

  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("View"),
              ),
              PopupMenuItem(
                enabled: gem.email != null,
                value: 2,
                child: Text("Send Email"),
              ),
            ],
      );
}
