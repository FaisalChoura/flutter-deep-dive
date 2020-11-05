import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_management/models/counter.dart';

final counterProvider = ChangeNotifierProvider<Counter>((ref) => new Counter());

class CounterWidget extends ConsumerWidget {
  const CounterWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // 2
    final count = watch(counterProvider).count;
    return Column(
      children: [
        Text(count.toString()),
        RaisedButton(
          // 3
          onPressed: () {
            context.read(counterProvider).increment();
          },
          child: Text('+'),
        )
      ],
    );
  }
}
