import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/protocols.dart';

class Conversation extends ObjectMethods {
  String title;
  String lastMessage;
  String imageUrl;
  String senderId;
  String sendeeId;
  DateTime time;
  bool read;

  Conversation(
      {@required String title,
      @required String lastMessage,
      @required String imageUrl,
      @required String senderId,
      @required String sendeeId,
      @required DateTime time,
      bool read}) {
    this.title = title;
    this.lastMessage = lastMessage;
    this.imageUrl = imageUrl;
    this.senderId = senderId;
    this.sendeeId = sendeeId;
    this.time = time;
    this.read = read;
  }

  static Conversation extractDocument(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data;
    return Conversation(
      title: data['title'],
      lastMessage: data['lastMessage'],
      imageUrl: data['imageUrl'],
      senderId: data['senderId'],
      sendeeId: data['sendeeId'],
      time: data['time'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'lastMessage': lastMessage,
      'imageUrl': imageUrl,
      'senderId': senderId,
      'sendeeId': sendeeId,
      'time': time
    };
  }
}
