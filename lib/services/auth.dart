import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/user.dart';

abstract class Auth {
  Future<User> getCurrentUser();
  Future<User> getUser({@required String id});
  Future<void> signOut();
  Stream<FirebaseUser> onAuthStateChanged();
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password});

  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password});
  Future<List<String>> getGemLikes({@required String id});
  Future<List<User>> getGems({@required String category, @required int limit});
  Future<FirebaseUser> getFirebaseUser();
}

class AuthImplementation extends Auth {
  AuthImplementation();

  final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<User> getCurrentUser() async {
    try {
      FirebaseUser firebaseUser = await _auth.currentUser();
      QuerySnapshot querySnapshot = await _usersDB.where('uid', isEqualTo: firebaseUser.uid)
          .getDocuments();
      DocumentSnapshot documentSnapshot = querySnapshot.documents.first;
      return User.extractDocument(documentSnapshot);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> getUser({@required String id}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _usersDB.document(id).get();
      return User.extractDocument(documentSnapshot);
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> signOut() {
    try {
      return _auth.signOut();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Stream<FirebaseUser> onAuthStateChanged() {
    try {
      return _auth.onAuthStateChanged;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password}) {
    try {
      return _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          return authResult;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<String>> getGemLikes({@required String id}) async {
    try {
      QuerySnapshot querySnapshot = await _usersDB.document(id)
          .collection('likes')
          .getDocuments();
      List<DocumentSnapshot> likeDocs = querySnapshot.documents;

      List<String> likes = List<String>();
      for (int i = 0; i < likeDocs.length; i++) {
        String userId = likeDocs[i].data['userId'];
        likes.add(userId);
      }
      return likes;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<User>> getGems({@required String category, int limit}) async {
    try {
      QuerySnapshot querySnapshot;
      if (limit == null) {
        querySnapshot = await _usersDB.where('category', isEqualTo: category)
            .orderBy('time', descending: true)
            .getDocuments();
      } else {
        querySnapshot = await _usersDB.where('category', isEqualTo: category)
            .orderBy('time', descending: true)
            .limit(limit)
            .getDocuments();
      }

      List<User> gems = List<User>();
      for (DocumentSnapshot docSnapshot in querySnapshot.documents) {
        gems.add(User.extractDocument(docSnapshot));
      }
      return gems;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<FirebaseUser> getFirebaseUser() async {
    try {
      return await _auth.currentUser();
    } catch (e) {
      return null;
    }
  }
}
