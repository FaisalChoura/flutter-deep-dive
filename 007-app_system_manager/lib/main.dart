import 'package:flutter/material.dart';

import 'app_system_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppSystemManager(
      child: MaterialApp(
        title: 'Application System Manager',
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App System Manager'),
      ),
      body: Container(
        child: Center(
          child: Text('Dummy'),
        ),
      ),
    );
  }
}
