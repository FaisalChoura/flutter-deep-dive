import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_management/models/loading_processor.dart';

final loadingProvider = StreamProvider.autoDispose<int>((ref) async* {
  final loadingProgressor = LoadingProcessor();

  ref.onDispose(() => loadingProgressor.controller.sink.close());

  await for (final value in loadingProgressor.stream) {
    if (value == 100) {
      loadingProgressor.controller.sink.close();
    }
    yield value;
  }
});

class LoadingWidget extends ConsumerWidget {
  LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<int> loading = watch(loadingProvider);
    return loading.when(
      data: (percent) {
        return Text("loading is $percent");
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
