import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/todo_model.dart';

enum FilterStatus { all, completed, incomplete }

class TodoProvider extends ChangeNotifier {
  late Box<ToDo> _todoBox;
  FilterStatus _filter = FilterStatus.all;

  TodoProvider() {
    _init();
  }

  Future<void> _init() async {
    _todoBox = Hive.box<ToDo>('todos');
    notifyListeners();
  }

  List<ToDo> get todos {
    final allTodos = _todoBox.values.toList();
    switch (_filter) {
      case FilterStatus.completed:
        return allTodos.where((todo) => todo.isDone).toList();
      case FilterStatus.incomplete:
        return allTodos.where((todo) => !todo.isDone).toList();
      case FilterStatus.all:
        return allTodos;
    }
  }

  FilterStatus get filter => _filter;

  void setFilter(FilterStatus filter) {
    _filter = filter;
    notifyListeners();
  }

  void addTodo(ToDo todo) {
    _todoBox.put(todo.id, todo);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final todo = _todoBox.get(id);
    if (todo != null) {
      todo.isDone = !todo.isDone;
      todo.save();
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todoBox.delete(id);
    notifyListeners();
  }

  void editTodo(String id, String newTitle) {
    final todo = _todoBox.get(id);
    if (todo != null) {
      todo.title = newTitle;
      todo.save();
      notifyListeners();
    }
  }
}
