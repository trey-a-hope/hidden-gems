import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:hiddengems_flutter/services/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  static final String path = "lib/src/pages/login/signup1.dart";

  String dropdownValue;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;

  _signUp() async {
    bool confirm =
        await Modal.showConfirmation(context, 'Submit', 'Are you sure?');
    if (confirm) {
      //Create new user in auth.
      _auth
          .createUserWithEmailAndPassword(
        email: 'trey.a.hope@gmail.com',
        password: 'Peachy33',
      )
          .then(
        (authResult) async {
          //Add user info to Database.
          final FirebaseUser user = authResult.user;

          var data = {
            'uid': user.uid,
            'name': 'lbooogi_e',
            'email': user.email,
            'category': 'Food',
            'subCategory': 'Desert Chef',
            'bio': '',
            'photoUrl':
                'https://scontent-ort2-2.cdninstagram.com/vp/3a56d7546b56e8ade15bc689fde5d6e2/5DDCEB42/t51.2885-19/s150x150/67434243_2440150902697790_6474788590290206720_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com',
            'backgroundUrl': 'https://cdn.wallpapersafari.com/71/53/hb9IVU.jpg',
            'likes': [],
            'time': DateTime.now(),
            'spotifyID': '',
            'iTunesID': '',
            'soundCloudName': '',
            'youTubeID': '',
            'instagramName': '',
            'facebookName': '',
            'twitterName': '',
            'phoneNumber': ''
          };

          DocumentReference dr = await _db.collection('Gems').add(data);
          await _db
              .collection('Gems')
              .document(dr.documentID)
              .updateData({'id': dr.documentID});
          Modal.showAlert(context, 'Done', 'New gem created.');
        },
      ).catchError(
        (e) {
          Modal.showAlert(context, 'Error', e.toString());
        },
      );
    }
  }

  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          CircleAvatar(
            child: Image.asset('assets/img/origami.png'),
            maxRadius: 50,
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            height: 20.0,
          ),
          _buildLoginForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.blue,
                child: Icon(Icons.arrow_back),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.blue),
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.blue.shade200),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                    width: 300.0,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: dropdownValue,
                          onChanged: (String value) {
                            setState(() {
                              dropdownValue = value;
                            });
                          },
                          items: <String>['One', 'Two', 'Free', 'Four']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade600,
                child: Icon(Icons.person),
              ),
            ],
          ),
          Container(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  _signUp();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white70),
                ),
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }
}
