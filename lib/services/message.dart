import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/pages/messages/message_page.dart';

abstract class Message {
  void openMessageThread(
      {@required BuildContext context,
      @required User sender,
      @required User sendee,
      @required String title});
}

class MessageImplementation extends Message {
  final CollectionReference _conversationsDB =
      Firestore.instance.collection('Conversations');

  void openMessageThread(
      {@required BuildContext context,
      @required User sender,
      @required User sendee,
      @required String title}) async {
    try {
      //Return conversation documents that have both user ids set to true.
      Query query = _conversationsDB;
      query = query.where(sender.id, isEqualTo: true);
      query = query.where(sendee.id, isEqualTo: true);
      //Grab first and only document.
      QuerySnapshot result = await query.snapshots().first;
      //If convo exits, change from null to the id. Otherwise, keep it null.
      String conversationId;
      if (result.documents.isNotEmpty) {
        DocumentSnapshot conversationDoc = result.documents.first;
        conversationId = conversationDoc.documentID;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagePage(
              sender: sender,
              sendee: sendee,
              conversationId: conversationId,
              title: title),
        ),
      );
    } catch (e) {
      throw Exception('Could not open thread.');
    }
  }
}
