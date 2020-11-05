import 'package:flutter/material.dart';

class Counter extends ChangeNotifier {
  int count;
  // 1
  Counter([this.count = 0]);

  // 2
  void increment() {
    count++;
    notifyListeners();
  }
}
