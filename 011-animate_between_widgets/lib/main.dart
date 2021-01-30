import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  GlobalKey appBarKey = LabeledGlobalKey('bar');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          key: appBarKey,
          title: Text('Animated Page'),
        ),
        body: AnimatedSquare(appBarKey: appBarKey),
      ),
    );
  }
}

class AnimatedSquare extends StatefulWidget {
  final GlobalKey appBarKey;

  AnimatedSquare({
    Key key,
    this.appBarKey,
  }) : super(key: key);

  @override
  _AnimatedSquareState createState() => _AnimatedSquareState();
}

class _AnimatedSquareState extends State<AnimatedSquare> {
  GlobalKey leftButtonKey = LabeledGlobalKey('left');
  GlobalKey rightButtonKey = LabeledGlobalKey('right');
  double xPosition, yPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1
      _squarePosition(leftButtonKey);
    });
  }

  _squarePosition(GlobalKey key) {
    RenderBox targetWidget = key.currentContext.findRenderObject(); // 1
    RenderBox appBar = widget.appBarKey.currentContext.findRenderObject(); // 1
    Offset offset = targetWidget.localToGlobal(Offset.zero); // 2
    setState(() {
      // 3
      xPosition = offset.dx;
      // We subtract the height of the appbar (skip this if you are not using an app bar)and add the height of the button in order to show the widget under the button
      yPosition = offset.dy - appBar.size.height + targetWidget.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            // 1
            children: [
              Container(
                height: 100,
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                      key: leftButtonKey,
                      child: Text('Left'),
                      onPressed: () => _squarePosition(leftButtonKey),
                    ),
                    RaisedButton(
                      key: rightButtonKey,
                      child: Text('Right'),
                      onPressed: () => _squarePosition(rightButtonKey),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                curve: Curves.decelerate, // 1
                duration: Duration(milliseconds: 100), // 2
                left: xPosition, // 3
                top: yPosition, // 3
                child: Container(
                  height: 10,
                  width: 10,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
