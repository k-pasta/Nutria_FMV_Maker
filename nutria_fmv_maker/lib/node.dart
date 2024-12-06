import 'package:flutter/material.dart';
import 'package:defer_pointer/defer_pointer.dart';
import './models/node_data.dart';
import './providers/nodes_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Node extends StatefulWidget {
  ///generic node type
  final NodeData nodeData;
  Node({super.key, required this.nodeData});

  @override
  State<Node> createState() => _NodeState();
}

class _NodeState extends State<Node> {
  Offset _dragPosition = Offset.zero;
  Color color =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  @override
  void initState() {
    super.initState();
    _dragPosition = widget.nodeData.position;
  }

  @override
  Widget build(BuildContext context) {
    // final nodesProvider = context.read<NodesProvider>();

    return Positioned(
      top: _dragPosition.dy,
      left: _dragPosition.dx,
      child: DeferPointer(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            setState(() {
              _dragPosition += details.delta;
            });
            Provider.of<NodesProvider>(context, listen: false)
                .updateNodePosition(widget.nodeData.id, _dragPosition);
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            child: Center(
              child: GestureDetector(
                  // behavior: HitTestBehavior.opaque,
                  // onScaleUpdate: (details) {
                  //   print('scaled');
                  // },

                  child: IconButton(onPressed: () {}, icon: Icon(Icons.abc))),
            ),
          ),
        ),
      ),
    );
  }
}
