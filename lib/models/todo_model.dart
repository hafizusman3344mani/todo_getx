class TodoModel {
  String title;
  bool done;
  String time;
  TodoModel({required this.title, required this.time, this.done = false});

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      TodoModel(title: json['title'], done: json['done'], time: json['time']);

  Map<String, dynamic> toJson() => {'title': title, 'done': done, 'time': time};
}
