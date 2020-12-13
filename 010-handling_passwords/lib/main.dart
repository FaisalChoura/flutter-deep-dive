import 'package:flutter/material.dart';
import 'package:handling_passwords/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _setPasswordCtlr = TextEditingController();
  TextEditingController _checkPasswordCtlr = TextEditingController();
  bool validPass = false;

  @override
  Widget build(BuildContext context) {
    Auth auth = new Auth();

    return Scaffold(
      appBar: AppBar(title: Text('Password Management')),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: TextField(
                    controller: _setPasswordCtlr,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Set Password',
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    onPressed: () {
                      String password = _setPasswordCtlr.text;
                      auth.setPassword('user1', password);
                    },
                    child: Text('Save'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: TextField(
                    controller: _checkPasswordCtlr,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Password',
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    onPressed: () {
                      String password = _checkPasswordCtlr.text;
                      auth.checkPassword('user1', password).then((value) => {
                            setState(() {
                              validPass = value;
                            })
                          });
                    },
                    child: Text('Check'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 100,
            ),
            validPass ? Text('True') : Text('False')
          ],
        ),
      ),
    );
  }
}
