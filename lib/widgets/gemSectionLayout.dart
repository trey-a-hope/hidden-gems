import 'package:flutter/widgets.dart';
import 'package:hiddengems_flutter/models/section.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/widgets/avatarBuilder.dart';
import 'package:hiddengems_flutter/pages/subCategories.dart';

class GemSectionLayout extends StatelessWidget {

  final Section _section;
  GemSectionLayout(this._section);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: _section.accentColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      _section.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          letterSpacing: 2.0,
                          color: Colors.black),
                    )
                  ],
                ),
                InkWell(
                  child: Text(
                    'SEE ALL',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: 2.0,
                        color: _section.primaryColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubCategories(
                              _section.title,
                              _section.subCategories,
                              _section.gems,
                              _section.accentColor,
                              _section.icon)),
                    );
                  },
                )
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          AvatarBuilder(
            _section.gems.sublist(
                0, _section.gems.length < 5 ? _section.gems.length : 5),
          ),
          Divider(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(_section.icon, color: _section.primaryColor),
                  SizedBox(width: 20),
                  Text('${_section.gems.length} artists currently.')
                ],
              ))
        ],
      ),
    );
  }
}
