import 'package:bottom_navigation_bar/account.dart';
import 'package:bottom_navigation_bar/home.dart';
import 'package:bottom_navigation_bar/search.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    AccountScreen(),
  ];

  Stack _buildScreens() {
    List<Widget> children = [];
    _pages.asMap().forEach((index, value) {
      children.add(
        Offstage(
          offstage: _currentIndex != index,
          child: TickerMode(
            enabled: _currentIndex == index,
            child: value,
          ),
        ),
      );
    });

    return Stack(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Bottom Nav Bar"),
        ),
        body: Center(
          child: _buildScreens(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              title: Text("Account"),
            )
          ],
        ),
      ),
    );
  }
}
