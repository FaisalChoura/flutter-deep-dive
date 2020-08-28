import 'package:date_time_field/new_task_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Date Field"),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: NewTaskForm(),
          ),
        ),
      ),
    );
  }
}
