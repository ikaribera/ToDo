// digunakan untuk menampilkan daftar todo

import 'package:flutter/material.dart';
import '../models/todo_model.dart';

// Properti Constructor untuk membuat widget TodoTile
class TodoTile extends StatelessWidget {
  final ToDo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  // Constructor untuk TodoTile
  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat ListTile untuk menampilkan todo
    return ListTile(
      onTap: onToggle,
      onLongPress: onEdit,
      // Checkbox untuk menandai todo selesai
      leading: Checkbox(value: todo.isDone, onChanged: (_) => onToggle()),
      title: Text(
        // Menampilkan judul todo dengan garis coret jika selesai
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      // Tombol hapus untuk menghapus todo
      trailing: IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
    );
  }
}
