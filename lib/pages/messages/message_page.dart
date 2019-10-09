import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hiddengems_flutter/models/chat_message.dart';
import 'package:hiddengems_flutter/models/user.dart';
import 'package:hiddengems_flutter/services/notification.dart';

class MessagePage extends StatelessWidget {
  MessagePage(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationId,
      @required this.title});

  final User sender;
  final User sendee;
  final String conversationId;
  final String title;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: ChatScreen(
          sender: sender, sendee: sendee, conversationId: conversationId),
    );
  }
}

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationId});

  final User sender; //Myself
  final User sendee; //Person I'm talking to.
  final String conversationId;

  @override
  State createState() => ChatScreenState(
      sender: sender, sendee: sendee, conversationId: conversationId);
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatScreenState(
      {@required this.sender,
      @required this.sendee,
      @required this.conversationId});

  final User sender;
  final User sendee;
  final CollectionReference _conversationsRef =
      Firestore.instance.collection('Conversations');
  final List<ChatMessage> _messages = List<ChatMessage>();
  final TextEditingController _textController = TextEditingController();
  final GetIt getIt = GetIt.I;
  bool _isComposing = false;
  DocumentReference _thisConversationDoc;
  CollectionReference _messageRef;
  String conversationId;

  @override
  void initState() {
    super.initState();

    //Mark conversation as read as soon as user opens it.
    if (conversationId != null) {
      _conversationsRef.document(conversationId).updateData(
        {'${sender.id}_read': true},
      );
    }
    _load();
  }

  _load() async {
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
                    myUserId: sender.id,
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
    if (sender == null) {
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
                myUserId: sender.id,
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

      //For sender...
      convoData[sender.id] = true;
      usersData[sender.id] = sender.name;

      //For sendee...
      convoData[sendee.id] = true;
      usersData[sendee.id] = sendee.name;

      //Apply "array" of user ids to the convo data.
      convoData['users'] = usersData;

      _thisConversationDoc.setData(convoData);

      // _analytics.logEvent(name: 'Message_Sent');
    }

    //Save messagea data.
    String messageId = _messageRef.document().documentID;
    createChatMessage(
        _messageRef, messageId, text, sender.photoUrl, sender.name, sender.id);

    //Update message thread.
    _thisConversationDoc.updateData(
      {
        'lastMessage': text,
        'imageUrl': sender.photoUrl,
        'time': DateTime.now(),
        '${sender.id}_read': true,
        '${sendee.id}_read': false
      },
    );

    //Notifiy user of new message.
    getIt<FCMNotification>().sendNotificationToUser(
        fcmToken: sendee.fcmToken,
        title: 'New Message From ${sender.name}',
        body: text.length > 25 ? text.substring(0, 25) + '...' : text);

    _textController.clear();

    ChatMessage message = ChatMessage(
      id: messageId,
      name: sender.name,
      imageUrl: sender.photoUrl,
      text: text,
      time: DateTime.now(),
      userId: sendee.id,
      myUserId: sender.id,
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
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (String text) {
                    setState(
                      () {
                        _isComposing = text.length > 0;
                      },
                    );
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
                      ),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]),
                  ),
                )
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
