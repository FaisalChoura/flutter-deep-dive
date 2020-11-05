import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_state_management/models/loading_processor.dart';

// 1
final loadingProvider = StreamProvider.autoDispose<int>((ref) async* {
  final loadingProcessor = LoadingProcessor();
  // 2
  ref.onDispose(() => loadingProcessor.controller.sink.close());
  // 3
  await for (final value in loadingProcessor.stream) {
    if (value == 100) {
      loadingProcessor.controller.sink.close();
    }
    // 4
    yield value;
  }
});

class LoadingWidget extends ConsumerWidget {
  LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // 5
    AsyncValue<int> loading = watch(loadingProvider);
    // 6
    return loading.when(
      // 7
      data: (percent) {
        return Text("loading is $percent");
      },
      // 8
      loading: () => const CircularProgressIndicator(),
      // 9
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
