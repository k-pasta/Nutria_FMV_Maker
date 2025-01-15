import 'package:flutter/material.dart';
import '../models/node_data.dart';

class NodesProvider extends ChangeNotifier {
  final List<NodeData> _nodes = [
    VideoNodeData(
      id: 'aaa',
      position: const Offset(0, 0),
      videoDataId: 'a',
      isExpanded: false,
      outputs: <VideoOutput>[
        VideoOutput(outputText: 'First text'),
        VideoOutput(outputText: 'First text'),
        VideoOutput(outputText: 'First text'),
        VideoOutput(outputText: 'First text'),
      ],
    ),
    VideoNodeData(
      id: 'bbb',
      position: const Offset(150, 250),
      videoDataId: 'a',
    ),
    VideoNodeData(
      id: 'ccc',
      position: const Offset(150, 20),
      videoDataId: 'a',
    ),
    VideoNodeData(
      id: 'ddd',
      position: const Offset(150, 20),
      videoDataId: 'a',
    ),
  ];
  get nodes => _nodes;

  void updateOutputPosition(String id, int outputIndex, Offset newPosition) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }
    final node = _nodes[nodeIndex];
    if (node is VideoNodeData) {
      if (outputIndex < node.outputs.length) {
        node.outputs[outputIndex].outputOffsetFromTopLeft = newPosition;

        notifyListeners();
      }
    }
    // print ('here');
  }


  getNodeById(String id) {
    return _nodes.firstWhere((n) => n.id == id,
        orElse: () => throw Exception("Node not found"));
  }

    // T getNodeById<T extends NodeData>(String id) {
  //   return _nodes.firstWhere((n) => n.id == id && n is T,
  //       orElse: () => throw Exception("Node not found")) as T;
  // }

  final List<VideoData> _videos = [
    VideoData(id: 'a', videoDataPath: 'test/test.test.test'),
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

  int getEffectiveOutputs(String id) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }
    final node = _nodes[nodeIndex];
    if (node is VideoNodeData) {
      if (node.outputs.length > 2) {
        return node.outputs.length;
      }
    } else {
      throw Exception("Node is not VideoNode");
    }
    return 2; // Default return value
  }

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
    if (node is BaseNodeData) {
      node.isExpanded = !node.isExpanded;
      notifyListeners();
    }
  }

  void setSwatch(String id, int swatch) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }
    final node = _nodes[nodeIndex];
    if (node is BaseNodeData) {
      node.swatch = swatch;
      notifyListeners();
    }
  }

  void updateText(String id, String currentText) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }
    final node = _nodes[nodeIndex];
    if (node is VideoNodeData) {
      // node.swatch = swatch;
      //     notifyListeners();
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
