import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'dart:collection';

import 'package:hiddengems_flutter/models/conversation.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/pages/messages/message_page.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/message.dart';
import 'package:hiddengems_flutter/services/modal.dart';

class MessagesPage extends StatefulWidget {
  @override
  State createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Conversation> _conversations = List<Conversation>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int convoCharLimit = 60;
  User _currentUser;
  final GetIt getIt = GetIt.I;
  bool _isLoading = true;
  final CollectionReference _conversationsDB =
      Firestore.instance.collection('Conversations');

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    _currentUser = await getIt<Auth>().getCurrentUser();

    //Get conversations this user is apart of.
    _conversationsDB.where(_currentUser.id, isEqualTo: true).snapshots().listen(
      (convoSnapshot) async {
        _conversations.clear();

        List<DocumentSnapshot> convoDocs = convoSnapshot.documents;
        for (int i = 0; i < convoDocs.length; i++) {
          Conversation conversation = Conversation();

          LinkedHashMap userNamesMap = convoDocs[i].data['users'];
          List<String> userIds = List<String>();
          List<String> userNames = List<String>();

          //Build list of users ids and user names.
          userNamesMap.forEach(
            (userId, userName) {
              userIds.add(userId);
              if (userId != _currentUser.id) {
                userNames.add(userName);
              }
            },
          );

          conversation.lastMessage = convoDocs[i]['lastMessage'];
          conversation.sendeeId = userIds[0];
          conversation.senderId = userIds[1];

          User oppositeUser;
          if (_currentUser.id == conversation.sendeeId) {
            oppositeUser =
                await getIt<Auth>().getUser(id: conversation.senderId);
          } else {
            oppositeUser =
                await getIt<Auth>().getUser(id: conversation.sendeeId);
          }

          conversation.imageUrl = oppositeUser.photoUrl;
          conversation.title = oppositeUser.name;

          _conversations.add(conversation);
        }
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Messages'),
      ),
      body: _isLoading
          ? Spinner()
          : _conversations.isEmpty
              ? Center(
                  child: Text('No Messsages At The Moment'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _conversations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildConversation(_conversations[index]);
                  },
                ),
    );
  }

  Widget _buildConversation(Conversation conversation) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            getIt<Message>().openMessageThread(
                context: context,
                senderId: conversation.senderId,
                sendeeId: conversation.sendeeId);
          },
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            backgroundImage: NetworkImage(conversation.imageUrl),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          title: Text(conversation.title),
          subtitle: Text(conversation.lastMessage.length > convoCharLimit
              ? conversation.lastMessage.substring(0, convoCharLimit) + '...'
              : conversation.lastMessage),
        ),
        Divider()
      ],
    );
  }
}
