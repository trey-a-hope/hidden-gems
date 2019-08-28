import 'package:flutter/widgets.dart';
import 'package:hiddengems_flutter/models/section.dart';
import 'package:flutter/material.dart';

class GemSectionHeader extends StatelessWidget {
  final Section section;
  final bool isLeft;
  const GemSectionHeader({Key key, @required this.section, @required this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: 250.0,
      ),
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(section.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: isLeft ? 0.0 : null,
            right: isLeft ? null : 0.0,
            bottom: 10.0,
            child: Container(
              decoration: BoxDecoration(
                color: section.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    '"${section.quote}"',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    section.subQuote,
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
