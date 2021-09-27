import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_getx/models/todo_model.dart';
import 'package:todo_getx/services/cloud_messaging_service.dart';

class TodoController extends GetxController {
  var todos = RxList<TodoModel>();
  TodoModel? selectedTodo;
  int selectedIndex = 0;
  String? token;

  @override
  void onInit() {
    List? storedTodos = GetStorage().read<List>('todos');
    if (storedTodos != null) {
      todos = storedTodos.map((e) => TodoModel.fromJson(e)).toList().obs;
    }
    ever(todos, (_) {
      GetStorage().write('todos', todos.toList());
    });
    getToken();
    super.onInit();
  }

  getToken() async {
    try {
      token = await CloudMessagingService.instance.getToken();
      debugPrint('token is $token');
    } catch (e) {
      debugPrint('error is $e');
    }
  }

  sendNotification() async {
    debugPrint('Alarm triggered');
    String serverKey =
        'AAAAKx8xmx0:APA91bEDVTXZ4XqYH4ZDwaWwPEKtnNLxny33W5bDWRHXderqzSQC4DKs2wFjROvvMAOkgXOgQ8Gdhl_XxT9skbVMSAa2JaYM3rtE3wU3K5g5HyWurTApdi5cgaoBUG9w-MoDI8SluTFz';
    var data = jsonEncode({
      'to': token,
      'notification': {
        'title': 'Usman',
        'body': ' This is some text',
      },
      /* passing my senderId/senderName so that other person can use it as receiver info while sending msg from notification */
      'data': {
        'type': 'chat',
        'data_body': {
          'chatId': "chatId.toString()",
          /* sender name for displaying */
          'senderName': "AuthController.userModel!.name!",
          /* for chat */
          'receiverId': "AuthController.userModel!.id!",
          'receiverName': "AuthController.userModel!.name!",
          'deviceId': "AuthController.userModel!.deviceId!",
        },
      }
    });

    try {
      await Dio().post(
        'https://fcm.googleapis.com/fcm/send',
        data: data,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'key=$serverKey',
          },
        ),
      );
      debugPrint('FCM request for device sent!');
    } catch (e) {
      debugPrint(e.toString());
    }

    if ("receiverDeviceId" == null) {
      debugPrint('Unable to send FCM message, no token exists.');
      return;
    }
  }
}
