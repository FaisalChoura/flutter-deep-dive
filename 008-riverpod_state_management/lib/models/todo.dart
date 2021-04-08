import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1
class Todo {
  num id;
  String title;
  bool completed;
  Todo({this.id, this.title, this.completed = false});
}

// 2
class TodoList extends StateNotifier<List<Todo>> {
  // 3
  TodoList([List<Todo> todos]) : super(todos ?? []);

  // 4
  void add(String title) {
    state = [...state, new Todo(id: state.length + 1, title: title)];
  }

  // 4
  void toggle(num id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            title: todo.title,
          )
        else
          todo,
    ];
  }

  // 4
  void edit(Todo updatedTodo) {
    state = [
      for (final todo in state)
        if (todo.id == updatedTodo.id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            title: updatedTodo.title,
          )
        else
          todo,
    ];
  }

  // 4
  void remove(num id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
