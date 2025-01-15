import 'package:flutter/material.dart';

class DynamicPositioningExample extends StatefulWidget {
  @override
  _DynamicPositioningExampleState createState() =>
      _DynamicPositioningExampleState();
}

class _DynamicPositioningExampleState extends State<DynamicPositioningExample> {
  final GlobalKey _key = GlobalKey();
  Offset _widgetPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getWidgetPosition());
  }

  void _getWidgetPosition() {
    // Get the position of the widget after the build process
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _widgetPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Positioning Example')),
      body: Stack(
        children: [
          Positioned(
            left: 50,
            top: 100,
            child: Container(
              key: _key,
              width: 100,
              height: 100,
              color: Colors.blue,
              child: Center(child: Text('Base Widget')),
            ),
          ),
          if (_widgetPosition != Offset.zero)
            Positioned(
              left: _widgetPosition.dx + 120,
              top: _widgetPosition.dy,
              child: Container(
                width: 100,
                height: 50,
                color: Colors.red,
                child: Center(child: Text('Dynamic Widget')),
              ),
            ),
        ],
      ),
    );
  }
}