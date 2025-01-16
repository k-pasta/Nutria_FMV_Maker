import 'package:flutter/material.dart';
import '../models/node_data.dart';

class NodesProvider extends ChangeNotifier {
  // Immutable list of nodes
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
      nodeName: 'First node',
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

  // Getter for nodes (returns an immutable list)
  List<NodeData> get nodes => List.unmodifiable(_nodes);

  // Getter for videos (returns an immutable list)
  final List<VideoData> _videos = [
    VideoData(id: 'a', videoDataPath: 'test/test.test.test'),
    VideoData(id: 'b', videoDataPath: ''),
  ];

  List<String> get iDs =>
      List.unmodifiable(_nodes.map((node) => node.id).toList());

  List<VideoData> get videos => List.unmodifiable(_videos);

  String? activeNodeId;

  // Get a node by its ID
  NodeData getNodeById(String id) {
    return _nodes.firstWhere(
      (n) => n.id == id,
      orElse: () => throw Exception("Node not found"),
    );
  }

  void updateNodeWidth(String id, double width) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }

    final node = _nodes[nodeIndex];
    if (node is BaseNodeData) {
      final updatedNode = node.copyWith(nodeWidth: width);
      _nodes[nodeIndex] = updatedNode;
      notifyListeners();
    } else {
      throw Exception("Node is not BaseNodeData");
    }
  }

  void initializeOutputs(String id) {
    int index = _nodes.indexWhere((n) => n.id == id);
    if (index == -1) throw Exception("Node not found");

    // Get the node and ensure it's a VideoNodeData instance
    VideoNodeData nodeData = _nodes[index] as VideoNodeData;

    // Check if outputs are empty and initialize them
    if (nodeData.outputs.isEmpty) {
      nodeData = nodeData
          .copyWith(outputs: [VideoOutput(), VideoOutput(), VideoOutput()]);
      print('no error');
    }

    // Ensure outputs have at least 3 items
    while (nodeData.outputs.length < 3) {
      nodeData =
          nodeData.copyWith(outputs: [...nodeData.outputs, VideoOutput()]);
    }

    // Add a new output if the last output has non-empty text
    if (!(nodeData.outputs.last as VideoOutput).outputText.isEmpty) {
      nodeData =
          nodeData.copyWith(outputs: [...nodeData.outputs, VideoOutput()]);
    }

    // Replace the node in the list with the updated node
    _nodes[index] = nodeData;

    // Notify listeners to rebuild the UI
    // notifyListeners();
  }

  // Update output position for a specific node
  void updateOutputPosition(String id, int outputIndex, Offset newPosition) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }

    final node = _nodes[nodeIndex];
    if (node is VideoNodeData) {
      if (outputIndex < node.outputs.length) {
        final updatedOutputs = List<Output>.from(node.outputs)
          ..[outputIndex] = node.outputs[outputIndex].copyWith(
            outputOffsetFromTopLeft: newPosition,
          );

        _nodes[nodeIndex] = node.copyWith(outputs: updatedOutputs);
        notifyListeners();
      }
    }
  }

  // notifyListeners();
  // print('initialized');

//   // Get the effective number of outputs for a node
  // int getEffectiveOutputs(String id) {
  //   final nodeIndex = _nodes.indexWhere((n) => n.id == id);

  //   if (nodeIndex == -1) {
  //     throw Exception("Node not found");
  //   }

  //   final node = _nodes[nodeIndex];
  //   if (node is VideoNodeData) {
  //     return node.outputs.length > 2 ? node.outputs.length : 2;
  //   } else {
  //     throw Exception("Node is not VideoNode");
  //   }
  // }

//   // Add a new node to the provider
//   void addNode(NodeData node) {
//     _nodes.add(node);
//     activeNodeId = node.id;
//     notifyListeners();
//   }

  // Toggle the 'expanded' state of a node
  void expandToggle(String id) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }

    final node = _nodes[nodeIndex];
    if (node is BaseNodeData) {
      final updatedNode = node.copyWith(isExpanded: !node.isExpanded);
      _nodes[nodeIndex] = updatedNode;
      notifyListeners();
      print('expanded');
    }
  }

  // Set the 'swatch' property for a node
  void setSwatch(String id, int swatch) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }

    final node = _nodes[nodeIndex];
    if (node is BaseNodeData) {
      final updatedNode = node.copyWith(swatch: swatch);
      _nodes[nodeIndex] = updatedNode;
      notifyListeners();
    }
  }

  // Set the active node by its ID
  void setActiveNode(String id) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }

    activeNodeId = id;

    final node = _nodes[nodeIndex];

    // If the node is not already at the bottom of the list, move it
    if (nodeIndex != _nodes.length - 1) {
      _nodes.removeAt(nodeIndex);
      _nodes.add(node);
    } else {
      return;
    }

    notifyListeners();
  }

  // Update the position of a node
  void updateNodePosition(String id, Offset newPosition) {
    final nodeIndex = _nodes.indexWhere((n) => n.id == id);

    if (nodeIndex == -1) {
      throw Exception("Node not found");
    }

    final node = _nodes[nodeIndex];
    final updatedNode = node.copyWith(position: newPosition);

    _nodes[nodeIndex] = updatedNode;
    notifyListeners();
  }

  // Remove a node from the list
  void removeNode(String id) {
    _nodes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
