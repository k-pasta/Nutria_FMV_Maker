import 'package:flutter/material.dart';

class SimpleClass extends StatefulWidget {
  const SimpleClass({super.key});

  @override
  State<SimpleClass> createState() => _SimpleClassState();
}

class _SimpleClassState extends State<SimpleClass> {
  double _top = 0;
  double _left = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: _top,
          left: _left,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _top = _top + details.delta.dy;
                _left = _left + details.delta.dx;
              });
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
