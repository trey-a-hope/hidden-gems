import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/protocols.dart';

class Like extends ObjectMethods {
  String id;
  String userID;

  Like({@required String id, @required String userID}) {
    this.id = id;
    this.userID = userID;
  }

  static Like extractDocument(DocumentSnapshot ds) {
    return Like(
      id: ds.data['id'],
      userID: ds.data['userID'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID
    };
  }
}
