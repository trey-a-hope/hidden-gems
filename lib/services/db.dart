import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/user.dart';

abstract class DB {
  //Like


  //User
  Future<void> createUser({@required Map<String, dynamic> data});
  Future<void> deleteUser({@required String userID});
  Future<User> retrieveUser({@required String userID});
  Future<void> updateUser(
      {@required String userID, @required Map<String, dynamic> data});
}

class DBImplementation extends DB {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<void> updateUser(
      {@required String userID, @required Map<String, dynamic> data}) async {
    try {
      await _usersDB.document(userID).updateData(data);
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

  @override
  Future<void> deleteUser({String userID}) async {
    try {
      await _usersDB.document(userID).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<User> retrieveUser({String userID}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersDB.document(userID).get();
      return User.extractDocument(documentSnapshot);
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
