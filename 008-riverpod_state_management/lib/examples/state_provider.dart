import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedButtonProvider = StateProvider<String>((ref) => '');
final isRedProvider = Provider<bool>((ref) {
  final color = ref.watch(selectedButtonProvider);
  return color.state == 'red';
});

class SelectedButton extends ConsumerWidget {
  const SelectedButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final selectedButton = watch(selectedButtonProvider).state;
    final isRed = watch(isRedProvider);
    return Column(
      children: [
        Text(selectedButton),
        RaisedButton(
          onPressed: () => context.read(selectedButtonProvider).state = 'red',
          child: Text('Red'),
        ),
        RaisedButton(
          onPressed: () => context.read(selectedButtonProvider).state = 'blue',
          child: Text('Blue'),
        ),
        isRed ? Text('Color is red') : Text('Color is not red')
      ],
    );
  }
}
