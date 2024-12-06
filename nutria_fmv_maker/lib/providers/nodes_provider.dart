import 'package:flutter/material.dart';
import '../models/node_data.dart';

class NodesProvider extends ChangeNotifier {
  final List<NodeData> _nodes = [
    SimpleNodeData(
      id: 'aaa',
      position: Offset(10, 20),
      extra: "",
    ),
    SimpleNodeData(
      id: 'bbb',
      position: Offset(150, 250),
      extra: "",
    ),
    SimpleNodeData(
      id: 'ccc',
      position: Offset(150, 20),
      extra: "",
    ),
  ];
  String? activeNodeId;

  get nodes => _nodes;

  void addNode(NodeData node) {
    _nodes.add(node);
    activeNodeId = node.id;
    notifyListeners();
  }

void updateNodePosition(String id, Offset newPosition) {
  // Find the index of the node by its id
  final nodeIndex = _nodes.indexWhere((n) => n.id == id);

  if (nodeIndex == -1) {
    throw Exception("Node not found");
  }

  // Update the node's position
  final node = _nodes[nodeIndex];
  node.position = newPosition;

  // If the node is not already at the bottom of the list, move it
  if (nodeIndex != _nodes.length - 1) {

    // Remove the node and add it to the bottom of the list
    _nodes.removeAt(nodeIndex);
    _nodes.add(node);
  }
    print(nodes[0].id + nodes[1].id + nodes[2].id);
  // Notify listeners after making changes
  notifyListeners();
}

  // void updateNodePosition(String id, Offset newPosition) {


  //   final node = _nodes.firstWhere((n) => n.id == id,
  //       orElse: () => throw Exception("Node not found"));
  //   activeNodeId = id;
    
  //   node.position = newPosition;
  //   notifyListeners();
  // }

  void removeNode(String id) {
    _nodes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
