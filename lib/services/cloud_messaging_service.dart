import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_getx/services/local_notification_service.dart';

class CloudMessagingService {
  CloudMessagingService._privateConstructor();

  static final CloudMessagingService _instance =
      CloudMessagingService._privateConstructor();

  static CloudMessagingService get instance => _instance;

  /* ========================================================================================================*/

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void configure() {
    debugPrint('CONFIGGGGGUREDDDDDDDD');

    _handleOnMessage();
    _handleUserInteraction();

    if (Platform.isIOS) {
      _setForeGroundNotificationsIOS();
      _setNotificationPermissionsIOS();
    }
  }

  void _handleOnMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Notification title is :: ${message.notification!.title}');
      }

      AndroidNotification? android = message.notification?.android;

      /* show local notification */
      LocalNotificationsService.instance.showNotification(message, android);
    });
  }

  Future<void> _handleUserInteraction() async {
    // from terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage, isFromTerminatedState: true);
    }
    // from background state
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message,
      {bool isFromTerminatedState = false}) {
    /* show local notification */
    debugPrint('handle message is called');
    var dataBody = jsonDecode(message.data['data_body']);
    if (message.data['type'] == 'chat') {
      Future.delayed(Duration(seconds: isFromTerminatedState ? 3 : 0))
          .then((value) {});
    } else if (message.data['type'] == 'event') {
      Future.delayed(Duration(seconds: isFromTerminatedState ? 3 : 0))
          .then((value) {});
    }
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> deleteToken() async {
    _firebaseMessaging.deleteToken();
  }

  void _setForeGroundNotificationsIOS() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  void _setNotificationPermissionsIOS() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }
}
