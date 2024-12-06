import 'package:flutter/material.dart';

abstract class NodeData {
Offset position;
final String id;
NodeData({required this.position, required this.id});
}

class SimpleNodeData extends NodeData{

SimpleNodeData({required Offset position, required String id, required String extra})
:super(position: position, id:id);
}

class VideoNodeData extends NodeData{

VideoNodeData({required Offset position, required String id, required String videoDataPath})
:super(position: position, id:id);
}