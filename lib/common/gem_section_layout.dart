import 'package:flutter/widgets.dart';
import 'package:hiddengems_flutter/common/rounded_image_widget.dart';
import 'package:hiddengems_flutter/models/section.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/subCategories.dart';
import 'package:hiddengems_flutter/pages/gemProfile.dart';

class GemSectionLayout extends StatelessWidget {
  final Section section;
  const GemSectionLayout({Key key, @required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Material(
            color: section.accentColor,
            elevation: 4,
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                          Icon(section.icon, color: section.primaryColor),
                          SizedBox(width: 20),
                          Text(section.gems.length == 1 ? '1 gem' : '${section.gems.length} gems')
                        ],
                      ),
                      InkWell(
                        child: Text(
                          'SEE ALL',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              letterSpacing: 2.0,
                              color: section.primaryColor),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubCategories(
                                    section.title,
                                    section.subCategories,
                                    section.gems,
                                    section.accentColor,
                                    section.icon)),
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 130)
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 65),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  for (var i = 0; i < section.gems.length; i++)
                    InkWell(
                      child: RoundedImageWidget(
                        imagePath: section.gems[i].photoUrl,
                        isOnline: true,
                        name: section.gems[i].name,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GemProfilePage(section.gems[i].id),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
