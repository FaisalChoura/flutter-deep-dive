import 'package:flutter/material.dart';

class Counter extends ChangeNotifier {
  int count;
  Counter([this.count = 0]);

  void increment() {
    count++;
    notifyListeners();
  }
}
