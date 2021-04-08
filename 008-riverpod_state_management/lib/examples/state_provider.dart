import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1
final selectedButtonProvider = StateProvider<String>((ref) => '');
// 2
final isRedProvider = Provider<bool>((ref) {
  final color = ref.watch(selectedButtonProvider);
  return color.state == 'red';
});

class SelectedButton extends ConsumerWidget {
  const SelectedButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // 3
    final selectedButton = watch(selectedButtonProvider).state;
    // 4
    final isRed = watch(isRedProvider);

    return Column(
      children: [
        Text(selectedButton),
        TextButton(
          // 5
          onPressed: () => context.read(selectedButtonProvider).state = 'red',
          child: Text('Red'),
        ),
        TextButton(
          // 5
          onPressed: () => context.read(selectedButtonProvider).state = 'blue',
          child: Text('Blue'),
        ),
        // 6
        isRed ? Text('Color is red') : Text('Color is not red')
      ],
    );
  }
}
