import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_management/models/address.dart';

// 1
final addressProvider = FutureProvider<String>((ref) async {
  return Address().getAddress();
});

class HttpRequestWidget extends ConsumerWidget {
  HttpRequestWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<String> address = watch(addressProvider);
    // 2
    return address.when(
      data: (data) {
        return Text(data.toString());
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
