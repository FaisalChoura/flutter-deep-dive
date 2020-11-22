import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SecureApplication(
        nativeRemoveDelay: 500,
        onNeedUnlock: (secure) async {
          print(secure);
          return null;
        },
        onAuthenticationFailed: () async {
          print('auth failed');
        },
        onAuthenticationSucceed: () async {
          print('auth success');
        },
        child: SecureGate(
          blurr: 5,
          child: Builder(
            builder: (context) {
              var valueNotifier = SecureApplicationProvider.of(context);
              valueNotifier.secure();
              return SecureItemList();
            },
          ),
        ),
      ),
    );
  }
}

class SecureItemList extends StatelessWidget {
  const SecureItemList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secure Item List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your protected things',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return NewSecureItem();
        })),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class NewSecureItem extends StatelessWidget {
  const NewSecureItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Item"),
      ),
      body: Center(
        child: Text('New Secure Item'),
      ),
    );
  }
}
