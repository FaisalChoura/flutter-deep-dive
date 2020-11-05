import 'dart:async';

class LoadingProcessor {
  LoadingProcessor() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (controller.isClosed) {
        timer.cancel();
      } else {
        controller.sink.add(loading);
        loading += 10;
      }
    });
  }
  final controller = StreamController<int>();
  var loading = 0;
  Stream<int> get stream => controller.stream;
}
