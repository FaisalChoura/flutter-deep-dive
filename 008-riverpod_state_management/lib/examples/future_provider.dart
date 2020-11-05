import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_management/models/address.dart';

final addressProvider = FutureProvider<String>((ref) async {
  return Address().getAddress();
});

class HttpRequestWidget extends ConsumerWidget {
  HttpRequestWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<String> address = watch(addressProvider);
    return address.when(
      data: (data) {
        return Text(data.toString());
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
