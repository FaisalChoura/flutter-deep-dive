import 'package:flutter_riverpod/all.dart';

class Todo {
  num id;
  String title;
  bool completed;
  Todo({this.id, this.title, this.completed = false});
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo> todos]) : super(todos ?? []);

  void add(String title) {
    // state[state.length] = new Todo(id: state.length + 1, title: title);
    state = [...state, new Todo(id: state.length + 1, title: title)];
  }

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

  void remove(num id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
