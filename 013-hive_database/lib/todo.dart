import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0) // 1
class Todo {
  @HiveField(0) // 2
  String title;

  @HiveField(1) // 2
  bool completed;

  Todo({
    this.title,
    this.completed,
  });
}
