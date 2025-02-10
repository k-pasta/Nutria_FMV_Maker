import 'package:flutter/material.dart';

class StackUpdateTest extends StatefulWidget {
  const StackUpdateTest({super.key});

  @override
  State<StackUpdateTest> createState() => _StackUpdateTestState();
}

class _StackUpdateTestState extends State<StackUpdateTest> {
  List<Widget> stackChildren = [
    ColoredBoxWidget(
        key: ValueKey(1), color: Colors.red, text: 'Red Box'),
    ColoredBoxWidget(
        key: ValueKey(2), color: Colors.blue, text: 'Blue Box'),
  ];

  List<Color> colors = const [Colors.red, Colors.blue];

  void shuffleStack() {
    print('Shuffle Stack');
    setState(() {
      if (stackChildren.isNotEmpty) {
      final last = stackChildren.removeLast();
      stackChildren.insert(0, last);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
                  ColoredBoxWidget(
                      key: ValueKey(3),
                      color: Colors.yellow,
                      text: 'Yellow Box'),
                  ...stackChildren,
                ],
          ),
        ),
        ElevatedButton(
          onPressed: shuffleStack,
          child: const Text('Shuffle Stack'),
        ),
      ],
    );
  }
}

class ColoredBoxWidget extends StatefulWidget {
  final Color color;
  final String text;

  const ColoredBoxWidget({super.key, required this.color, required this.text});

  @override
  State<ColoredBoxWidget> createState() => _ColoredBoxWidgetState();
}

class _ColoredBoxWidgetState extends State<ColoredBoxWidget> {
  @override
  void initState() {
    super.initState();
    debugPrint('${widget.text} - initState');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('${widget.text} - build');
    return Positioned(
      left: 50,
      top: widget.text == 'Red Box' ? 50 : 150, // Different starting positions
      child: Container(
        width: 100,
        height: 150,
        color: widget.color,
        alignment: Alignment.center,
        child: Text(widget.text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
