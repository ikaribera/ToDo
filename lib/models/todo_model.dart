// digunakan untuk membuat struktur data todo
class ToDo {
  final String id;
  String title;
  bool isDone;

  ToDo({required this.id, required this.title, this.isDone = false});

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(id: json['id'], title: json['title'], isDone: json['isDone']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isDone': isDone};
  }
}
