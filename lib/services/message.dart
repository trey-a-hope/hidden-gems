import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiddengems_flutter/pages/messages/message_page.dart';

abstract class Message {
  void openMessageThread(
      {@required BuildContext context,
      @required String senderId,
      @required String sendeeId});
}

class MessageImplementation extends Message {
  final CollectionReference _conversationsDB =
      Firestore.instance.collection('Conversations');

  void openMessageThread(
      {@required BuildContext context,
      @required String senderId,
      @required String sendeeId}) async {
    try {
      //Return conversation documents that have both user ids set to true.
      Query query = _conversationsDB;
      query = query.where(senderId, isEqualTo: true);
      query = query.where(sendeeId, isEqualTo: true);
      //Grab first and only document.
      QuerySnapshot result = await query.snapshots().first;
      //If convo exits, change from null to the id. Otherwise, keep it null.
      String convoId;
      if (result.documents.isNotEmpty) {
        DocumentSnapshot conversationDoc = result.documents.first;
        convoId = conversationDoc.documentID;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagePage(
              userAId: senderId, userBId: sendeeId, conversationId: convoId),
        ),
      );
    } catch (e) {
      throw Exception('Could not open thread.');
    }
  }
}
