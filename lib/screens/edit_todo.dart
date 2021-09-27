import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_getx/controllers/todo_controller.dart';

class EditTodoScreen extends StatelessWidget {
  final TodoController todoController = Get.find<TodoController>();
  @override
  Widget build(BuildContext context) {
    final TextEditingController todoTextController = TextEditingController(
      text: todoController.selectedTodo!.title,
    );
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: todoTextController,
                  decoration: InputDecoration(
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
                      todoController.selectedTodo!.title =
                          todoTextController.text;
                      todoController.todos[todoController.selectedIndex] =
                          todoController.selectedTodo!;
                      Get.back();
                      Get.snackbar(
                        'Updated!',
                        'Task updated successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        margin: EdgeInsets.only(bottom: 6, left: 16, right: 16),
                      );
                    },
                    child: Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text('Cancel'),
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
