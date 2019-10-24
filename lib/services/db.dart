import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class DB {
    Future<void> createUser({@required Map<String, dynamic> data});

  Future<void> updateUser(
      {@required String userId, @required Map<String, dynamic> data});}

class DBImplementation extends DB {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<void> updateUser(
      {@required String userId, @required Map<String, dynamic> data}) async {
    try {
      await _usersDB.document(userId).updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

    @override
  Future<void> createUser({Map<String, dynamic> data}) async {
    try {
      DocumentReference docRef = await _usersDB.add(data);
      await _usersDB
          .document(docRef.documentID)
          .updateData({'id': docRef.documentID});
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
