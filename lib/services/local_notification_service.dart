import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  LocalNotificationsService._privateConstructor();

  static final LocalNotificationsService _instance =
      LocalNotificationsService._privateConstructor();

  // Singleton instance across the app
  static LocalNotificationsService get instance => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  init() {
    debugPrint('INITIALIZEDDDD');
    _createChannel();
    _initSetting();
  }

  /* ===================================== Show notification ===================================== */
  void showNotification(
      RemoteMessage remoteMessage, AndroidNotification? android) {
    RemoteNotification? notification = remoteMessage.notification;
    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              _channel.description,
              icon: android.smallIcon,
              // other properties...
            ),
          ),
          payload: jsonEncode(remoteMessage.data));
    }
  }

  /* ===================================== On select notification ===================================== */
  Future _selectNotification(String? payload) async {
    debugPrint(payload);
    var data = jsonDecode(payload!);
    debugPrint('type is :: ${data['type']}');
    var dataBody = jsonDecode(data['data_body']);
  }

  /* ===================================== Remove notification ===================================== */
  Future removeNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /* ============================= Initialize Settings for android and ios ============================= */
  void _initSetting() async {
    // Android setting
    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon');
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    // IOS setting
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    // Init setting
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _selectNotification);
  }

  /* ===================== Notification channel to override the default behaviour ===================== */
  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  void _createChannel() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /* ===================================== For Older IOS versions ===================================== */
  Future _onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }
}
