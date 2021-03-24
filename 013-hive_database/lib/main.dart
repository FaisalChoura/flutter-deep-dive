import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database/todo.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Todo>(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Box<Todo> todosBox = Hive.box<Todo>("todos");

  addTodo() {
    todosBox.add(new Todo(title: "New Todo", completed: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () => addTodo())
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: todosBox.listenable(),
        builder: (BuildContext context, Box<Todo> box, Widget widget) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (BuildContext context, int index) {
              Todo todo = todosBox.get(index);

              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.completed.toString()),
                onTap: () {
                  todo.completed = !todo.completed;
                  box.putAt(index, todo);
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    box.deleteAt(index);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
