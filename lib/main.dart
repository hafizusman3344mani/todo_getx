import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_getx/screens/home_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.orange,
      statusBarIconBrightness: Brightness.light,
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(foregroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.orange,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              Color(0xffffffff),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
          elevation: 4.0,
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
