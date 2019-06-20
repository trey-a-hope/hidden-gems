import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/gem.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:hiddengems_flutter/pages/fullListing.dart';

//MAKE A STATELESS WIDGET

class AvatarBuilder extends StatelessWidget {
  final List<Gem> gems;
  AvatarBuilder(this.gems);

  @override
  Widget build(BuildContext context) {
    return Container(
    //aspectRatio: 16/15,
    height: 200.0,
    child: ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: this.gems.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 0.0),
            child: Column(
              children: <Widget>[
                InkResponse(
                  child: SizedBox(
                    child: Hero(
                        tag: this.gems[i].name,
                        child: Container(
                          height: 130.0,
                          width: 130.0,

                          child: CircleAvatar(
                            backgroundImage: NetworkImage(this.gems[i].path),
                          )

                          // child: Material(
                          //   elevation: 0.0,
                          //   color: Colors.transparent,
                          //   shape: CircleBorder(),
                          //   child: ClipRRect(
                          //       borderRadius: BorderRadius.circular(30.0),
                          //       child: Image.asset(users[i].path)),
                          // ),

                        )),
                  ),
                  onTap: () {
                    Modal.showAlert(context, 'ToDo', 'text');
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
                            this.gems[i].name.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Center(
                          child: Text(
                            this.gems[i].sub_category.toUpperCase(),
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
          ),
    ),
  ); 
  }
}