import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  var androiInit =
      AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
  var iosInit = IOSInitializationSettings();
  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

  await localNotificationsPlugin.initialize(initSetting);
}

Future singleNotification(
    DateTime scheduledDate, String title, String body, int hashCode,
    {String? sound}) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin fltNotification;
  var androiInit =
      AndroidInitializationSettings("@mipmap/ic_launcher"); //for logo
  var iosInit = IOSInitializationSettings();
  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
  fltNotification = FlutterLocalNotificationsPlugin();
  fltNotification.initialize(initSetting);
  var androidDetails =
      AndroidNotificationDetails('1', 'channelName', 'channel Description');
  var iosDetails = IOSNotificationDetails();
  var generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      fltNotification.show(notification.hashCode, notification.title,
          notification.body, generalNotificationDetails);
    }
  });
}
