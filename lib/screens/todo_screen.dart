import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_getx/controllers/todo_controller.dart';
import 'package:todo_getx/models/todo_model.dart';

class TodoScreen extends StatelessWidget {
  final TextEditingController todoTextController = TextEditingController();
  final TodoController todoController = Get.find<TodoController>();

  TodoScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: todoTextController,
                  decoration: const InputDecoration(
                    hintText: 'Enter you task here...',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      todoController.todos.add(
                        TodoModel(
                          title: todoTextController.text,
                          time: DateTime.now().toString(),
                        ),
                      );
                      Get.back();
                      Get.snackbar(
                        'Added!',
                        'Task added successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        margin: const EdgeInsets.only(
                            bottom: 6, left: 16, right: 16),
                      );
                    },
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
