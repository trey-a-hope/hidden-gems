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
  void openMessageThread(
      {@required BuildContext context,
      @required String senderId,
      @required String sendeeId}) async {
    try {
      final CollectionReference conversationRef =
          Firestore.instance.collection('Conversations');
      Query query = conversationRef;
      query = query.where(senderId, isEqualTo: true);
      query = query.where(sendeeId, isEqualTo: true);
      QuerySnapshot result = await query.snapshots().first;
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
      // getIt<Modal>().showInSnackBar(
      //   scaffoldKey: _scaffoldKey,
      //   message: e.toString(),
      // );
    }
  }
}
