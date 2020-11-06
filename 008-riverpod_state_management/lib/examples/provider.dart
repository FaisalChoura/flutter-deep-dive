import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1
final hellowWorldProvider = Provider<String>((ref) => "Hello world");

// 2
class HelloWorld extends ConsumerWidget {
  const HelloWorld({Key key}) : super(key: key);

  @override
  // 3
  Widget build(BuildContext context, ScopedReader watch) {
    // 4
    String text = watch(hellowWorldProvider);
    return Text(text);
  }
}
