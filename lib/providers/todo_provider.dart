import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';
import 'dart:convert';

enum FilterStatus { all, completed, incomplete }

class TodoProvider extends ChangeNotifier {
  List<ToDo> _todos = [];
  // List<ToDo> get todos => _todos;
  FilterStatus _filter = FilterStatus.all;

  List<ToDo> get todos {
    switch (_filter) {
      case FilterStatus.completed:
        return _todos.where((todo) => todo.isDone).toList();
      case FilterStatus.incomplete:
        return _todos.where((todo) => !todo.isDone).toList();
      case FilterStatus.all:
        return _todos;
    }
  }

  FilterStatus get filter => _filter;

  TodoProvider() {
    loadTodos(); // auto-load saat provider diinisialisasi
  }

  void setFilter(FilterStatus filter) {
    _filter = filter;
    notifyListeners();
  }

  void addTodo(ToDo todo) {
    _todos.add(todo);
    notifyListeners();
    saveTodos();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      notifyListeners();
      saveTodos();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
    saveTodos();
  }

  void editTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
    saveTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getString('todos');
    if (todosJson != null) {
      final List decoded = jsonDecode(todosJson);
      _todos = decoded.map((e) => ToDo.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_todos.map((e) => e.toJson()).toList());
    await prefs.setString('todos', encoded);
  }

  void updateTodo(String id, String newTitle) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].title = newTitle;
      notifyListeners();
      saveTodos();
    }
  }
}
