import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_getx/models/todo_model.dart';

class TodoController extends GetxController {
  var todos = RxList<TodoModel>();
  TodoModel? selectedTodo;
  int selectedIndex = 0;

  @override
  void onInit() {
    List? storedTodos = GetStorage().read<List>('todos');
    if (storedTodos != null) {
      todos = storedTodos.map((e) => TodoModel.fromJson(e)).toList().obs;
    }
    ever(todos, (_) {
      GetStorage().write('todos', todos.toList());
    });
    super.onInit();
  }
}
