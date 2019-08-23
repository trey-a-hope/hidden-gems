import 'package:flutter/widgets.dart';
import 'package:hiddengems_flutter/models/section.dart';
import 'package:flutter/material.dart';

class GemSectionHeader extends StatelessWidget {

  final Section _section;
  GemSectionHeader(this._section);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_section.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: _section.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    '"${_section.quote}"',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    _section.subQuote,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
