import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo_model.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final TodoService _todoService = TodoService();
  final TextEditingController _controller = TextEditingController();
  final uuid = const Uuid();

  void _addTodo(String title) {
    if (title.isEmpty) return;
    final newTodo = ToDo(id: const Uuid().v4(), title: _controller.text);
    context.read<TodoProvider>().addTodo(newTodo);
    _controller.clear();
  }

  void _toggleTodo(String id) {
    final provider = context.read<TodoProvider>();
    provider.toggleTodo(id);
  }

  void _deleteTodo(String id) {
    final provider = context.read<TodoProvider>();
    provider.deleteTodo(id);
  }

  void _editTodoDialog(ToDo todo) {
    final TextEditingController editController = TextEditingController(
      text: todo.title,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit To-Do'),
            content: TextField(
              controller: editController,
              decoration: const InputDecoration(labelText: 'Judul baru'),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newTitle = editController.text.trim();
                  if (newTitle.isNotEmpty) {
                    context.read<TodoProvider>().updateTodo(todo.id, newTitle);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>().todos;
    Widget buildFilterButtons(BuildContext context) {
      final provider = context.watch<TodoProvider>();
      final filter = provider.filter;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilterChip(
            label: const Text("Semua"),
            selected: filter == FilterStatus.all,
            onSelected: (_) => provider.setFilter(FilterStatus.all),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text("Selesai"),
            selected: filter == FilterStatus.completed,
            onSelected: (_) => provider.setFilter(FilterStatus.completed),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text("Belum Selesai"),
            selected: filter == FilterStatus.incomplete,
            onSelected: (_) => provider.setFilter(FilterStatus.incomplete),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Tambah tugas...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _addTodo,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTodo(_controller.text),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          buildFilterButtons(context), // Filter buttons
          const SizedBox(height: 8),
          Expanded(
            child:
                todos.isEmpty
                    ? const Center(child: Text('Belum ada tugas nih!'))
                    : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return TodoTile(
                          todo: todo,
                          onToggle: () => _toggleTodo(todo.id),
                          onDelete: () => _deleteTodo(todo.id),
                          onEdit: () => _editTodoDialog(todo),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
