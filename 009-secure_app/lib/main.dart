import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

import 'life_cycle_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) {
          return SecureItemList();
        });
      case "/new":
        return MaterialPageRoute(builder: (context) {
          return NewSecureItem();
        });
      default:
      // Some widget here
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure application',
      onGenerateRoute: _generateRoute,
      builder: (context, child) {
        return SecureApplication(
          // 1
          nativeRemoveDelay: 500,
          // 2
          onNeedUnlock: (secure) async {
            // Some security code here
          },
          // 3
          onAuthenticationFailed: () async {
            print('auth failed');
          },
          // 4
          onAuthenticationSucceed: () async {
            print('auth success');
          },
          child: Builder(
            builder: (context) {
              SecureApplicationProvider.of(context).secure();
              return SecureGate(
                // 1
                blurr: 20,
                // 2
                opacity: 0.5,
                // 3
                lockedBuilder: (context, secureNotifier) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('LOGIN'),
                        onPressed: () =>
                            // 4
                            secureNotifier.authSuccess(unlock: true),
                      ),
                      RaisedButton(
                        child: Text('FAIL AUTHENTICATION'),
                        onPressed: () =>
                            // 5
                            secureNotifier.authFailed(unlock: false),
                      ),
                    ],
                  ),
                ),
                child: LifecycleManager(
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SecureItemList extends StatelessWidget {
  const SecureItemList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secure Application"),
      ),
      body: Center(
        child: RaisedButton(
          // This will not work for now (try when we add onGenerateRoute)
          onPressed: () => Navigator.of(context).pushNamed("/new"),
          child: Text("New Secure Item"),
        ),
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
