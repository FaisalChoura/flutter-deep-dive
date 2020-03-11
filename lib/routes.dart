import 'package:deep_dive/minis/minis.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (context) => HomeScreen(),
  '/forms': (context) => FormsMini(),
};
