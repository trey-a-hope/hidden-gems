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
      'name': 'Ric Sexton',
      'category': 'Entertainment',
      'subCategory': 'Host',
      'bio': 'Ric Sexton is a new entertainer.',
      'photoUrl':
          'https://scontent-ort2-2.cdninstagram.com/vp/97fe4bba90a722ce1cbef1b58ff703cd/5DDF78A8/t51.2885-19/s150x150/42766276_275030050005202_1769734999369580544_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com',
      'backgroundUrl':
          'https://i.pinimg.com/originals/00/16/01/00160120217169c7a933abefd15ed319.jpg',
      'likes': [],
      'instagramName': 'ricsexton',
      'time': DateTime.now()
    };

    // //Can be null.
    // String spotifyID;
    // String iTunesID;
    // String youTubeID;
    // String instagramName;
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
