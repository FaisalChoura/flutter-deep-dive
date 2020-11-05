import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hellowWorldProvider = Provider((ref) => "Hello world"); // 1
// 2

class HelloWorld extends ConsumerWidget {
  const HelloWorld({Key key}) : super(key: key);
  // 3
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String text = watch(hellowWorldProvider); // 4
    return Text(text);
  }
}
