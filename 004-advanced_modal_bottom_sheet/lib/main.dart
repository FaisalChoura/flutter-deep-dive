import 'package:advanced_modal_bottom_sheet/new_task.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Flutter Modal Bottom Sheet',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced Modal Bottom Sheet"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("New Task"),
          onPressed: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0))),
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: NewTaskScreen()),
            );
          },
        ),
      ),
    );
  }
}
