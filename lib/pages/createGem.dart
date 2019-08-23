import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddengems_flutter/services/modal.dart';

class CreateGemPage extends StatefulWidget {
  @override
  State createState() => CreateGemPageState();
}

class CreateGemPageState extends State<CreateGemPage>
    with SingleTickerProviderStateMixin {
  final _db = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  //Move this to a separate class in the future.
  _createNewGem() async {
    var data = {
      'name': 'lbooogi_e',
      'category': 'Food',
      'subCategory': 'Chef',
      'bio': 'Cheesecakes are fire!',
      'photoUrl':
          'https://scontent-ort2-2.cdninstagram.com/vp/3a56d7546b56e8ade15bc689fde5d6e2/5DDCEB42/t51.2885-19/s150x150/67434243_2440150902697790_6474788590290206720_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com',
      'backgroundUrl':
          'https://cdn.wallpapersafari.com/71/53/hb9IVU.jpg',
      'likes': [],
      'time': DateTime.now()
    };

    // //Can be null.
    // String spotifyID;
    // String iTunesID;
    // String instagram;
    // String youTubeID;
    // String facebookName;
    // String twitterName;
    // String soundCloudName;

    DocumentReference dr = await _db.collection('Gems').add(data);
    await _db
        .collection('Gems')
        .document(dr.documentID)
        .updateData({'id': dr.documentID});
    Modal.showAlert(context, 'Done', 'New gem created.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Create New Gem')),
      body: Center(
        child: RaisedButton(
          child: Text('Create New Gem'),
          onPressed: (){
            _createNewGem();
          },
        ),
      ),
    );
  }
}
