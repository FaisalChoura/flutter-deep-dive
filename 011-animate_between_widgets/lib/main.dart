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
  AnimatedSquare({Key key, this.appBarKey}) : super(key: key);

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
      yPosition = offset.dy - appBar.size.height + targetWidget.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
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
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 100),
                left: xPosition,
                top: yPosition,
                child: Container(
                  height: 10,
                  width: 10,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
