import 'package:flutter/material.dart';
import 'knot_data.dart';

abstract class NodeData {
Offset position;
final String id;
final List<KnotData> knots;
NodeData({required this.position, required this.id, this.knots = const []});
}

class SimpleNodeData extends NodeData{

SimpleNodeData({required Offset position, required String id, required String extra, List<KnotData> knots = const []})
:super(position: position, id:id, knots:knots);
}

class VideoNodeData extends NodeData{

VideoNodeData({required Offset position, required String id, required String videoDataPath})
:super(position: position, id:id);
}