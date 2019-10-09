import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/common/spinner.dart';
import 'dart:collection';
import 'package:hiddengems_flutter/models/conversation.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/message.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagesPage extends StatefulWidget {
  @override
  State createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Conversation> _conversations = List<Conversation>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int convoCharLimit = 25;
  final GetIt getIt = GetIt.I;
  final CollectionReference _conversationsDB =
      Firestore.instance.collection('Conversations');
  User _currentUser;
  User _oppositeUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    _currentUser = await getIt<Auth>().getCurrentUser();

    //Call Once
    //Get conversations this user is apart of.
    // QuerySnapshot querySnapshot = await _conversationsDB
    //     .where(_currentUser.id, isEqualTo: true)
    //     .getDocuments();
    // List<DocumentSnapshot> documents = querySnapshot.documents;
    // for (int i = 0; i < documents.length; i++) {
    //   var convoData = documents[i].data;
    //   var userData = convoData['users'];
    //   List<String> userIds = List<String>();

    //   //Build list of users ids and user names.
    //   userData.forEach(
    //     (userId, userName) {
    //       userIds.add(userId);
    //     },
    //   );

    //   if (_currentUser.id == userIds[0]) {
    //     _oppositeUser = await getIt<Auth>().getUser(id: userIds[1]);
    //   } else {
    //     _oppositeUser = await getIt<Auth>().getUser(id: userIds[0]);
    //   }

    //   _conversations.add(
    //     Conversation(
    //       title: _oppositeUser.name,
    //       lastMessage: convoData['lastMessage'],
    //       imageUrl: _oppositeUser.photoUrl,
    //       sendeeId: userIds[0],
    //       senderId: userIds[1],
    //       time: convoData['time'].toDate(),
    //       read: convoData['${_currentUser.id}_read'],
    //     ),
    //   );
    // }
    // setState(() {
    //   _isLoading = false;
    // });

    //Listen
    _conversationsDB.where(_currentUser.id, isEqualTo: true).snapshots().listen(
      (convoSnapshot) async {
        _conversations.clear();

        List<DocumentSnapshot> convoDocs = convoSnapshot.documents;
        for (int i = 0; i < convoDocs.length; i++) {
          var convoData = convoDocs[i].data;
          var userData = convoData['users'];
          List<String> userIds = List<String>();

          //Build list of users ids and user names.
          userData.forEach(
            (userId, userName) {
              userIds.add(userId);
            },
          );

          if (_currentUser.id == userIds[0]) {
            _oppositeUser = await getIt<Auth>().getUser(id: userIds[1]);
          } else {
            _oppositeUser = await getIt<Auth>().getUser(id: userIds[0]);
          }

          _conversations.add(
            Conversation(
              title: _oppositeUser.name,
              lastMessage: convoData['lastMessage'],
              imageUrl: _oppositeUser.photoUrl,
              sendeeId: userIds[0],
              senderId: userIds[1],
              time: convoData['time'].toDate(),
              read: convoData['${_currentUser.id}_read'],
            ),
          );
        }

        //Sort conversations by most recent.
        _conversations.sort(
          (a, b) => b.time.compareTo(
            a.time,
          ),
        );

        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Messages (${_conversations.where((c) => c.read == false).length})'),
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
                sender: _currentUser,
                sendee: _oppositeUser,
                title: conversation.title);
          },
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            backgroundImage: NetworkImage(conversation.imageUrl),
          ),
          trailing: Text(
            timeago.format(
              conversation.time,
            ),
          ),
          title: Row(
            children: <Widget>[
              conversation.read
                  ? Container()
                  : Icon(
                      MdiIcons.circle,
                      size: 10,
                      color: Colors.lightBlue,
                    ),
              conversation.read
                  ? Container()
                  : SizedBox(
                      width: 10,
                    ),
              Text(
                conversation.title,
                style: TextStyle(
                    fontWeight: conversation.read
                        ? FontWeight.normal
                        : FontWeight.bold),
              )
            ],
          ),
          subtitle: Text(conversation.lastMessage, maxLines: 1),
        ),
        Divider()
      ],
    );
  }
}
