import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_project/providers/todo_provider.dart';
import 'package:todo_project/screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider()..loadTodos(), // load on start
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
