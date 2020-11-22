import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

class LifecycleManager extends StatefulWidget {
  final Widget child;
  LifecycleManager({Key key, this.child}) : super(key: key);

  @override
  _LifecycleManagerState createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager>
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

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      SecureApplicationProvider.of(context).lock();
    }
  }
}
