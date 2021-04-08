import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_management/examples/stream_provider.dart';

import 'examples/change_notifier_provider.dart';
import 'examples/future_provider.dart';
import 'examples/provider.dart';
import 'examples/state_notifier_provider.dart';
import 'examples/state_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: RiverpodExamples(),
    );
  }
}

class RiverpodExamples extends StatelessWidget {
  const RiverpodExamples({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod examples'),
      ),
      body: Center(
        child: ListView(
          children: [
            HelloWorld(),
            SizedBox(
              height: 30,
            ),
            SelectedButton(),
            SizedBox(
              height: 30,
            ),
            CounterWidget(),
            SizedBox(
              height: 30,
            ),
            TodoWidget(),
            SizedBox(
              height: 30,
            ),
            LoadingWidget(),
            SizedBox(
              height: 30,
            ),
            HttpRequestWidget(),
          ],
        ),
      ),
    );
  }
}
