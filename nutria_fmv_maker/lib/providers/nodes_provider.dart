import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/knot_data.dart';
import '../models/node_data.dart';

class NodesProvider extends ChangeNotifier {
  final List<NodeData> _nodes = [
    SimpleNodeData(id: 'aaa', position: const Offset(0, 0), extra: "", knots: [
      KnotData(knotID: 'aaa1', isInput: true, positionFromTop: const Offset(0, 10)),
      KnotData(knotID: 'aaa2', isInput: true, positionFromTop: const Offset(0, 60)),
      KnotData(knotID: 'aaa3', isInput: true, positionFromTop: const Offset(0, 110)),
    ]),
    SimpleNodeData(
      id: 'bbb',
      position: const Offset(150, 250),
      extra: "",
    ),
    SimpleNodeData(
      id: 'ccc',
      position: const Offset(150, 20),
      extra: "",
    ),
    VideoNodeData(position: Offset(0, 0), id: 'id', videoDataPath: 'videoDataPath')
  ];

  String? activeNodeId;

  get nodes => _nodes;

// void drawNoodle(String id, Offset mousePosition) {
//   final KnotData = _nodes.firstWhere((n) => n.id == id,
//         orElse: () => throw Exception("Node not found"));

//     node.position = newPosition;
//     notifyListeners();

// }

  void addNode(NodeData node) {
    _nodes.add(node);
    activeNodeId = node.id;
    notifyListeners();
  }

  void setActiveNode(String id) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }
    activeNodeId = id;
    // Update the node's position
    final node = _nodes[nodeIndex];

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

  void onNoodlesUpdate() {}

  void updateNodePosition(String id, Offset newPosition) {
    final NodeData node = _nodes.firstWhere((n) => n.id == id,
        orElse: () => throw Exception("Node not found"));

    node.position = newPosition;
    print(newPosition);
    notifyListeners();
  }

  void removeNode(String id) {
    _nodes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
