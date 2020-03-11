import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Deep Dive'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Forms'),
            onTap: () => Navigator.pushNamed(context, '/forms'),
          )
        ],
      ),
    );
  }
}
