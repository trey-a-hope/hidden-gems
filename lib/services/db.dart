import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/like.dart';
import 'package:hiddengems_flutter/models/user.dart';

abstract class DB {
  //Like
  Future<void> createLike({@required String gemID, @required Like like});
  Future<void> deleteLike({@required String gemID, @required String userID});
  Future<List<Like>> retrieveLikes({@required String gemID});

  //User
  Future<void> createUser({@required User user});
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
  Future<void> createUser({User user}) async {
    try {
      DocumentReference docRef = await _usersDB.add(
        user.toMap(),
      );
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

  @override
  Future<void> createLike({String gemID, Like like}) async {
    try {
      CollectionReference likesColRef =
          _usersDB.document(gemID).collection('Likes');
      DocumentReference docRef = await likesColRef.add(
        like.toMap(),
      );
      await likesColRef
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
  Future<void> deleteLike({String gemID, String userID}) async {
    try {
      CollectionReference likesColRef =
          _usersDB.document(gemID).collection('Likes');

      QuerySnapshot querySnapshot =
          await likesColRef.where('userID', isEqualTo: userID).getDocuments();
      if (querySnapshot.documents.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.documents.first;
        likesColRef.document(doc.documentID).delete();
      }
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<Like>> retrieveLikes({String gemID}) async {
    try {
      CollectionReference likesColRef =
          _usersDB.document(gemID).collection('Likes');
      QuerySnapshot querySnapshot = await likesColRef.getDocuments();
      List<DocumentSnapshot> docs = querySnapshot.documents;
      List<Like> likes = List<Like>();
      for (int i = 0; i < docs.length; i++) {
        likes.add(
          Like.extractDocument(docs[i]),
        );
      }
      return likes;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  // @override
  // Future<bool> hasLikedGem({String gemID, String userID}) async {
  //   try {
  //     CollectionReference likesColRef =
  //         _usersDB.document(gemID).collection('Likes');
  //     QuerySnapshot querySnapshot =
  //         await likesColRef.where('userID', isEqualTo: userID).getDocuments();
  //     return querySnapshot.documents.isNotEmpty;
  //   } catch (e) {
  //     throw Exception(
  //       e.toString(),
  //     );
  //   }
  // }
}
