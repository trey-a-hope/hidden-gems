import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:algolia/algolia.dart';

class Gem {
  String backgroundUrl;
  String bio;
  String category;
  String email;
  String facebookName;
  String iTunesID;
  String id;
  String instagramName;
  String name;
  List<dynamic> likes = List<dynamic>(); //List of user IDs
  String phoneNumber;
  String soundCloudName;
  String spotifyID;
  String subCategory;
  String twitterName;
  String youTubeID;
  String photoUrl;
  DateTime time;
  String uid;
  bool isSitter;

  static Gem extractDocument(DocumentSnapshot ds) {
    Gem gem = Gem();

    gem.bio = ds['bio'];
    gem.backgroundUrl = ds['backgroundUrl'];
    gem.category = ds['category'];
    gem.email = ds['email'];
    gem.facebookName = ds['facebookName'];
    gem.iTunesID = ds['iTunesID'];
    gem.id = ds['id'];
    gem.instagramName = ds['instagramName'];
    gem.likes = ds['likes'];
    gem.name = ds['name'];
    gem.phoneNumber = ds['phoneNumber'];
    gem.photoUrl = ds['photoUrl'];
    gem.soundCloudName = ds['soundCloudName'];
    gem.spotifyID = ds['spotifyID'];
    gem.subCategory = ds['subCategory'];
    gem.time = ds['time'].toDate();
    gem.twitterName = ds['twitterName'];
    gem.uid = ds['uid'];
    gem.youTubeID = ds['youTubeID'];
    gem.isSitter = ds['isSitter'];

    return gem;
  }

  static Gem extractAlgoliaObjectSnapshot(AlgoliaObjectSnapshot aob) {
    Gem gem = Gem();

    gem.bio = aob.data['bio'];
    gem.backgroundUrl = aob.data['backgroundUrl'];
    gem.category = aob.data['category'];
    gem.email = aob.data['email'];
    gem.facebookName = aob.data['facebookName'];
    gem.iTunesID = aob.data['iTunesID'];
    gem.id = aob.data['id'];
    gem.instagramName = aob.data['instagramName'];
    gem.likes = aob.data['likes'];
    gem.name = aob.data['name'];
    gem.phoneNumber = aob.data['phoneNumber'];
    gem.photoUrl = aob.data['photoUrl'];
    gem.soundCloudName = aob.data['soundCloudName'];
    gem.spotifyID = aob.data['spotifyID'];
    gem.subCategory = aob.data['subCategory'];
    // gem.time = aob.data['time'].toDate();
    gem.twitterName = aob.data['twitterName'];
    gem.uid = aob.data['uid'];
    gem.youTubeID = aob.data['youTubeID'];

    return gem;
  }
}
