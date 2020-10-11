import 'package:flutter/material.dart';

class AppSystemManager extends StatefulWidget {
  final Widget child;
  AppSystemManager({Key key, this.child}) : super(key: key);

  @override
  _AppSystemManagerState createState() => _AppSystemManagerState();
}

class _AppSystemManagerState extends State<AppSystemManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    // context is accesible from here.
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        break;
      default:
    }
  }

  void didChangeMetrics() {
    print('rotated');
  }

  void didHaveMemoryPressure() {
    print('this is called when the system is low on memory');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
