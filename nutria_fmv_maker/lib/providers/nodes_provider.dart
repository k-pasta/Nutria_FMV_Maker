import 'package:flutter/material.dart';
import '../models/node_data.dart';

class NodesProvider extends ChangeNotifier {
  final List<NodeData> _nodes = [
    VideoNodeData(
      id: 'aaa',
      position: const Offset(0, 0),
      videoDataId: 'a',
      isExpanded: false,
    ),
    // VideoNodeData(
    //   id: 'bbb',
    //   position: const Offset(150, 250),
    //   videoDataId: 'a',
    // ),
    // VideoNodeData(
    //   id: 'ccc',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    // ),
  ];
  get nodes => _nodes;

  final List<VideoData> _videos = [
    VideoData(id: 'a', videoDataPath: ''),
    VideoData(id: 'b', videoDataPath: '')
  ];

  get videos => _videos;

  String? activeNodeId;
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

void expandToggle(String id) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }
    final node = _nodes[nodeIndex];
    if(node is BaseNodeData){
    node.isExpanded = !node.isExpanded;
        notifyListeners();
    }
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
    // print(nodes[0].id + nodes[1].id + nodes[2].id);
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
