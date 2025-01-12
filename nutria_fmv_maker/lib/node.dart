import 'package:flutter/material.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:nutria_fmv_maker/knot.dart';
import './models/node_data.dart';
import './providers/nodes_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'static_data/ui_static_properties.dart';

class Node extends StatefulWidget {
  ///generic node type
  final NodeData nodeData;
  const Node({super.key, required this.nodeData});

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
      top: _dragPosition.dy - (UiStaticProperties.canvasSize / 2),
      left: _dragPosition.dx - (UiStaticProperties.canvasSize / 2),
      //       top: _dragPosition.dy,
      // left: _dragPosition.dx,
      // child: DeferPointer(

      child: Stack(children: [
        Positioned(
          top: 25,
          left: 25,
          child: GestureDetector(
            // behavior: HitTestBehavior.translucent,
            onPanUpdate: (details) {
              setState(() {
                _dragPosition += details.delta;
              });
              Provider.of<NodesProvider>(context, listen: false)
                  .updateNodePosition(widget.nodeData.id, _dragPosition);
            },
            onPanStart: (details) {
              Provider.of<NodesProvider>(context, listen: false)
                  .setActiveNode(widget.nodeData.id);
            },
            onTap: () {
              Provider.of<NodesProvider>(context, listen: false)
                  .setActiveNode(widget.nodeData.id);
            },
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
            ),
          ),
        ),

        IgnorePointer(
          child: SizedBox(
            height: 250,
            width: 250,
            child: Container(color: Colors.black26),
          ),
        ),
        
        // Positioned(
        //   left: 0,
        //   child: Column(
        //     children: [
        //       const SizedBox(
        //         height: 50,
        //       ),
        //       ...widget.nodeData.knots.map((knotData) {
        //         return Knot(knotData: knotData);
        //       })
        //     ],
        //   ),
        // ),
        GestureDetector(
          // behavior: HitTestBehavior.opaque,
          // onScaleUpdate: (details) {
          //   print('scaled');
          // },
          onPanUpdate: (details) => {},
          child: IconButton(
            onPressed: () {
              print('pressed $widget.nodeData.id');
            },
            icon: const Icon(Icons.abc),
          ),
        ),
      ]),
      // ),
      // ),
    );
  }
}
