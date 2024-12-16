import 'package:flutter/material.dart';
import 'knot_data.dart';

abstract class NodeData {
Offset position;
final String id;
final List<KnotData> knots;
NodeData({required this.position, required this.id, this.knots = const []});
}

class SimpleNodeData extends NodeData{

SimpleNodeData({required super.position, required super.id, required String extra, super.knots});
}

class VideoNodeData extends NodeData{

VideoNodeData({required super.position, required super.id, required String videoDataPath});
}