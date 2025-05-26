// digunakan untuk membuat struktur data todo

import 'package:hive/hive.dart';
part 'todo_model.g.dart'; // Hive akan generate file ini

@HiveType(typeId: 0)
class ToDo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isDone;

  ToDo({required this.id, required this.title, this.isDone = false});

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(id: json['id'], title: json['title'], isDone: json['isDone']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isDone': isDone};
  }
}
