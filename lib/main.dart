import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_getx/screens/home_screen.dart';
import 'package:todo_getx/services/cloud_messaging_service.dart';
import 'package:todo_getx/services/local_notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('BACKGROUND MESSAGE RECEIVE');
  debugPrint("c message: ${message.messageId}");
}

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
  await AndroidAlarmManager.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CloudMessagingService.instance.configure();
    LocalNotificationsService.instance.init();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.orange,
      statusBarIconBrightness: Brightness.light,
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: const TextTheme(
          button: TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(foregroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.orange,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              const Color(0xffffffff),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          elevation: 4.0,
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
