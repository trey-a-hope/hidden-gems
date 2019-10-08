import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/models/chat_message.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/auth.dart';
import 'package:hiddengems_flutter/services/notification.dart';
import '../../constants.dart';

final CollectionReference _conversationsRef =
    Firestore.instance.collection('Conversations');
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final String timeFormat = 'h:mm a';
DocumentReference _thisConversationDoc;
CollectionReference _messageRef;

class MessagePage extends StatelessWidget {
  MessagePage({@required this.userAId, @required this.userBId, @required this.conversationId});

  final String userAId;
  final String userBId;
  final String conversationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Message'),
      ),
      body: ChatScreen(userAId: userAId, userBId: userBId, conversationId: conversationId)
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen({@required this.userAId, @required this.userBId, @required this.conversationId});

  final String userAId; //Myself
  final String userBId; //Person I'm talking to.
  final String conversationId;

  @override
  State createState() => ChatScreenState(userAId: userAId, userBId: userBId, conversationId: conversationId);
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatScreenState({@required this.userAId, @required this.userBId, @required this.conversationId});

  final String userAId;
  User _userA;
  final String userBId;
  User _userB;
  String conversationId;

  final List<ChatMessage> _messages = List<ChatMessage>();
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;
  final CollectionReference _usersDB = Firestore.instance.collection('Users');
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    _userA = await getIt<Auth>().getUser(id: userAId);
    _userB = await getIt<Auth>().getUser(id: userBId);

    setState(
      () {
        if (conversationId != null) {
          print(conversationId);

          _thisConversationDoc = _conversationsRef.document(conversationId);
          _messageRef = _thisConversationDoc.collection('messages');

          //List for incoming messages.
          _messageRef.snapshots().listen(
            (messageSnapshot) {
              //Sort messages by timestamp.
              messageSnapshot.documents.sort(
                (a, b) => a['timestamp'].compareTo(
                  b['timestamp'],
                ),
              );
              //
              messageSnapshot.documents.forEach(
                (messageDoc) {
                  //Build chat message.
                  ChatMessage message = ChatMessage(
                    id: messageDoc.documentID,
                    name: messageDoc['name'],
                    imageUrl: messageDoc['imageUrl'],
                    text: messageDoc['text'],
                    time: messageDoc['timestamp'].toDate(),
                    userId: messageDoc['userId'],
                    myUserId: _userA.id,
                    animationController: AnimationController(
                      duration: Duration(milliseconds: 700),
                      vsync: this,
                    ),
                  );

                  setState(
                    () {
                      //Add message if it is new.
                      if (_isNewMessage(message)) {
                        _messages.insert(0, message);
                      }
                    },
                  );

                  message.animationController.forward();
                },
              );
            },
          );
        } else {
          print('This is a message.');
        }
      },
    );
  }

  bool _isNewMessage(ChatMessage cm) {
    for (ChatMessage chatMessage in _messages) {
      if (chatMessage.id == cm.id) {
        return false;
      }
    }
    return true;
  }

  void _handleSubmitted(String text) {
    if (_userA == null) {
      return;
    }

    //If this is a new message...
    if (conversationId == null) {
      //Create thread.
      _thisConversationDoc = _conversationsRef.document();
      conversationId = _thisConversationDoc.documentID;
      //Set collection reference for messages on this thread.
      _messageRef = _thisConversationDoc.collection('messages');
      //List for incoming messages.
      _messageRef.snapshots().listen(
        (messageSnapshot) {
          messageSnapshot.documents.forEach(
            (messageDoc) {
              //Build chat message.
              ChatMessage message = ChatMessage(
                id: messageDoc.documentID,
                name: messageDoc['name'],
                imageUrl: messageDoc['imageUrl'],
                text: messageDoc['text'],
                time: messageDoc['timestamp'].toDate(),
                userId: messageDoc['userId'],
                myUserId: _userA.id,
                animationController: AnimationController(
                  duration: Duration(milliseconds: 700),
                  vsync: this,
                ),
              );

              setState(
                () {
                  //Add message is it is new.
                  if (_isNewMessage(message)) {
                    _messages.insert(0, message);
                  }
                },
              );
              message.animationController.forward();
            },
          );
        },
      );

      //Set user id's to true for this thread for searching purposes.
      //Also save each user's username to display as thread title.
      Map<String, dynamic> convoData = Map<String, dynamic>();
      Map<String, dynamic> usersData = Map<String, dynamic>();

      //For user A...
      convoData[_userA.id] = true;
      usersData[_userA.id] = _userA.name;

      //For user B...
      convoData[_userB.id] = true;
      usersData[_userB.id] = _userB.name;

      //Apply "array" of user emails to the convo data.
      convoData['users'] = usersData;

      //Apply the number of users to the convo data.
      convoData['userCount'] = 2;

      //Apply the last message to the convo data.
      convoData['lastMessage'] = text;

      //Apply the image url of the last person to message the group.
      convoData['imageUrl'] = _userA.photoUrl;

      _thisConversationDoc.setData(convoData);

      // _analytics.logEvent(name: 'Message_Sent');
    }

    //Save messagea data.
    String messageId = _messageRef.document().documentID;
    createChatMessage(_messageRef, messageId, text, _userA.photoUrl,
        _userA.name, _userA.id);

    //Update message thread.
    _thisConversationDoc.updateData(
        {'lastMessage': text, 'imageUrl': _userA.photoUrl});

    //Notifiy user of new message.
    getIt<FCMNotification>().sendNotificationToUser(
        fcmToken: _userB.fcmToken,
        title: 'New Message From ${_userA.name}',
        body: text.length > 25 ? text.substring(0, 25) + '...' : text);

    _textController.clear();

    ChatMessage message = ChatMessage(
      id: messageId,
      name: _userA.name,
      imageUrl: _userA.photoUrl,
      text: text,
      time: DateTime.now(),
      userId: _userB.id,
      myUserId: _userA.id,
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    setState(
      () {
        _isComposing = false;
        _messages.insert(0, message);
      },
    );

    message.animationController.forward();
  }

  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]),
                ),
              )
            : null); //new
  }

  createChatMessage(CollectionReference messageRef, String messageId,
      String text, String imageUrl, String userName, String userId) async {
    var data = {
      'text': text,
      'imageUrl': imageUrl,
      'name': userName,
      'userId': userId,
      'timestamp': DateTime.now()
    };

    await messageRef.document(messageId).setData(data);
  }
}
