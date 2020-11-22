import 'package:flutter/material.dart';
import 'package:secure_app/lifecycle_manager.dart';
import 'package:secure_application/secure_application.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/new":
        return MaterialPageRoute(
          builder: (context) {
            return NewSecureItem();
          },
          fullscreenDialog: true,
        );
      default:
        return MaterialPageRoute(builder: (context) {
          return SecureItemList();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: _generateRoute,
        builder: (context, child) {
          return SecureApplication(
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
              child: Builder(
                builder: (context) {
                  SecureApplicationProvider.of(context).secure();
                  return SecureScreen(child: child);
                },
              ));
        });
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
        onPressed: () => Navigator.of(context).pushNamed("/new"),
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

class SecureScreen extends StatelessWidget {
  final Widget child;
  const SecureScreen({this.child});

  @override
  Widget build(BuildContext context) {
    return SecureGate(
      blurr: 60,
      opacity: 0.8,
      lockedBuilder: (context, secureNotifier) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('LOGIN'),
            onPressed: () => secureNotifier.authSuccess(unlock: true),
          ),
          RaisedButton(
            child: Text('FAIL AUTHENTICATION'),
            onPressed: () => secureNotifier.authFailed(unlock: false),
          ),
        ],
      )),
      child: LifecycleManager(
        child: child,
      ),
    );
  }
}
