import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/protocols.dart';

class User extends ObjectMethods {
  String backgroundUrl;
  String bio;
  String category;
  String email;
  String facebookUrl;
  String fcmToken;
  String iTunesUrl;
  String id;
  String instagramUrl;
  String name;
  String phoneNumber;
  String soundCloudUrl;
  String spotifyUrl;
  String subCategory;
  String twitterUrl;
  String youTubeUrl;
  String photoUrl;
  DateTime time;
  String uid;
  bool isGem;

  User(
      {@required String backgroundUrl,
      @required String bio,
      @required String category,
      @required String email,
      @required String facebookUrl,
      @required String fcmToken,
      @required String id,
      @required String instagramUrl,
      @required bool isGem,
      @required String iTunesUrl,
      @required String name,
      @required String phoneNumber,
      @required String photoUrl,
      @required String soundCloudUrl,
      @required String spotifyUrl,
      @required String subCategory,
      @required DateTime time,
      @required String twitterUrl,
      @required String youTubeUrl,
      @required String uid}) {
    this.backgroundUrl = backgroundUrl;
    this.bio = bio;
    this.category = category;
    this.email = email;
    this.facebookUrl = facebookUrl;
    this.fcmToken = fcmToken;
    this.iTunesUrl = iTunesUrl;
    this.id = id;
    this.instagramUrl = instagramUrl;
    this.name = name;
    this.phoneNumber = phoneNumber;
    this.soundCloudUrl = soundCloudUrl;
    this.spotifyUrl = spotifyUrl;
    this.subCategory = subCategory;
    this.twitterUrl = twitterUrl;
    this.youTubeUrl = youTubeUrl;
    this.photoUrl = photoUrl;
    this.time = time;
    this.uid = uid;
    this.isGem = isGem;
  }

  static User extractDocument(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data;
    return User(
        backgroundUrl: data['backgroundUrl'],
        bio: data['bio'],
        category: data['category'],
        email: data['email'],
        facebookUrl: data['facebookUrl'],
        fcmToken: data['fcmToken'],
        iTunesUrl: data['iTunesUrl'],
        id: data['id'],
        instagramUrl: data['instagramUrl'],
        name: data['name'],
        phoneNumber: data['phoneNumber'],
        photoUrl: data['photoUrl'],
        soundCloudUrl: data['soundCloudUrl'],
        spotifyUrl: data['spotifyUrl'],
        subCategory: data['subCategory'],
        time: data['time'].toDate(),
        twitterUrl: data['twitterUrl'],
        uid: data['uid'],
        youTubeUrl: data['youTubeUrl'],
        isGem: data['isGem']);
  }

  static User extractAlgoliaObjectSnapshot(AlgoliaObjectSnapshot aob) {
    Map<String, dynamic> data = aob.data;

    return User(
        backgroundUrl: data['backgroundUrl'],
        bio: data['bio'],
        category: data['category'],
        email: data['email'],
        facebookUrl: data['facebookUrl'],
        fcmToken: data['fcmToken'],
        iTunesUrl: data['iTunesUrl'],
        id: data['id'],
        instagramUrl: data['instagramUrl'],
        name: data['name'],
        phoneNumber: data['phoneNumber'],
        photoUrl: data['photoUrl'],
        soundCloudUrl: data['soundCloudUrl'],
        spotifyUrl: data['spotifyUrl'],
        subCategory: data['subCategory'],
        time: DateTime.now(), //Fix this later...
        twitterUrl: data['twitterUrl'],
        uid: data['uid'],
        youTubeUrl: data['youTubeUrl'],
        isGem: data['isGem']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'backgroundUrl': backgroundUrl,
      'bio': bio,
      'category': category,
      'email': email,
      'facebookUrl': facebookUrl,
      'fcmToken': fcmToken,
      'iTunesUrl': iTunesUrl,
      'id': id,
      'instagramUrl': instagramUrl,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'soundCloudUrl': soundCloudUrl,
      'spotifyUrl': spotifyUrl,
      'subCategory': subCategory,
      'time': time,
      'twitterUrl': twitterUrl,
      'uid': uid,
      'youTubeUrl': youTubeUrl,
      'isGem': isGem
    };
  }
}
