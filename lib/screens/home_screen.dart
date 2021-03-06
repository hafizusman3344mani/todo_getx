import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_getx/controllers/todo_controller.dart';
import 'package:todo_getx/screens/edit_todo.dart';
import 'package:todo_getx/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController todoController = Get.put(TodoController());
  bool isOn = false;
  int alarmId = 1;

  @override
  void initState() {
    AndroidAlarmManager.periodic(
        const Duration(seconds: 60), alarmId, sendNotification,
        exact: true, wakeup: true, rescheduleOnReboot: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
          actions: [
            Switch(
              value: isOn,
              onChanged: (value) {
                setState(() {
                  isOn = value;
                });
                if (isOn == true) {
                  AndroidAlarmManager.periodic(
                      const Duration(seconds: 60), alarmId, sendNotification);
                } else {
                  AndroidAlarmManager.cancel(alarmId);
                  debugPrint('Alarm Timer Canceled');
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(
              () => TodoScreen(),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Obx(() {
          return todoController.todos.isNotEmpty
              ? ListView.separated(
                  itemCount: todoController.todos.length,
                  separatorBuilder: (context, pos) => const Divider(),
                  itemBuilder: (context, index) {
                    DateTime todoTime =
                        DateTime.parse(todoController.todos[index].time);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd   KK:mm:a').format(todoTime);
                    return Dismissible(
                      direction: DismissDirection.startToEnd,
                      key: UniqueKey(),
                      background: Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                        ),
                      ),
                      onDismissed: (_) {
                        todoController.todos.removeAt(index);
                        Get.snackbar(
                          'Removed!',
                          'Task removed successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          margin: const EdgeInsets.only(
                              bottom: 6, left: 16, right: 16),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          todoController.todos[index].title,
                          style: todoController.todos[index].done
                              ? const TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough)
                              : const TextStyle(
                                  color: Colors.black,
                                ),
                        ),
                        subtitle: Text(formattedDate),
                        leading: Checkbox(
                          onChanged: (val) {
                            debugPrint('$val');
                            var todo = todoController.todos[index];
                            todo.done = val!;
                            todoController.todos[index] = todo;
                          },
                          value: todoController.todos[index].done,
                        ),
                        trailing: IconButton(
                          splashRadius: 25,
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            todoController.selectedIndex = index;
                            todoController.selectedTodo =
                                todoController.todos[index];
                            Get.to(
                              () => EditTodoScreen(),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("No Todo added."),
                );
        }),
      ),
    );
  }

  void sendNotification() {
    debugPrint('Alarm triggered');
    todoController.sendNotification();
  }
}
