import 'dart:async';
import 'dart:convert' show Encoding, json;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class FCMNotification {
  Future<void> sendNotificationToUser(
      {@required String fcmToken,
      @required String title,
      @required String body});
  Future<void> sendNotificationToGroup(
      {@required String group, @required String title, @required String body});
  Future<void> unsubscribeFromTopic({@required String topic});
  Future<void> subscribeToTopic({@required String topic});
}

class FCMNotificationImplementation extends FCMNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final String _endpoint = 'https://fcm.googleapis.com/fcm/send';
  final String _contentType = 'application/json';
  final String _authorization =
      'key=AAAAnKdrp_c:APA91bGohr6igqi8ZGY8JnlXqiULzFEK4MHBSOHRedG3EecwyXQyqclSM2rEzglZUeeO5wonUCo8aD4XvEZJHqKZR7ZIyryLWiC_RAEZwd32lXXJAjlqvChHYQEuk9xTMFk0ZVRCpVTq';

  Future<http.Response> _sendNotification(
      String to, String title, String body) async {
    final dynamic data = json.encode(
      {
        'to': to,
        'priority': 'high',
        'notification': {'title': title, 'body': body},
        'content_available': true
      },
    );
    return http.post(
      _endpoint,
      body: data,
      headers: {'Content-Type': _contentType, 'Authorization': _authorization},
    );
  }

  @override
  Future<void> unsubscribeFromTopic({@required String topic}) {
    return _firebaseMessaging.subscribeToTopic(topic);
  }

  @override
  Future<void> subscribeToTopic({@required String topic}) {
    return _firebaseMessaging.subscribeToTopic(topic);
  }

  @override
  Future<void> sendNotificationToUser(
      {@required String fcmToken,
      @required String title,
      @required String body}) {
    return _sendNotification(fcmToken, title, body);
  }

  @override
  Future<void> sendNotificationToGroup(
      {@required String group, @required String title, @required String body}) {
    return _sendNotification('/topics/' + group, title, body);
  }
}
