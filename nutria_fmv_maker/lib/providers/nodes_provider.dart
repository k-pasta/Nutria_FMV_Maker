import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import '../models/node_data.dart';

class NodesProvider extends ChangeNotifier {
  // Immutable list of nodes
  final List<NodeData> _nodes = [
    VideoNodeData(
      id: 'aaa',
      position: const Offset(0, 0),
      videoDataId: 'a',
      isExpanded: false,
      outputs: <Output>[
        Output(outputData: 'First text'),
        Output(outputData: 'First text'),
        Output(outputData: 'First text'),
        Output(outputData: 'First text'),
      ],
      nodeName: 'First nodeFirst nodeFirst nodeFirst nodeFirst nodeFirst node',
    ),
    VideoNodeData(
      id: 'bbb',
      position: const Offset(150, 250),
      videoDataId: 'a',
      outputs: <Output>[
        Output(outputData: 'First text'),
        Output(outputData: 'First text'),
      ],
    ),
    VideoNodeData(
      id: 'ccc',
      position: const Offset(150, 20),
      videoDataId: 'a',
      outputs: <Output>[
        Output(outputData: 'First text'),
      ],
    ),
    VideoNodeData(
      id: 'ddd',
      position: const Offset(150, 20),
      videoDataId: 'a',
      outputs: <Output>[
        Output(outputData: 'First text'),
        Output(outputData: ''),
        Output(outputData: ''),
        Output(outputData: ''),
        Output(outputData: ''),
      ],
    ),
  ];

  // Getter for nodes (returns an immutable list)
  List<NodeData> get nodes => List.unmodifiable(_nodes);

  List<NodeData> get selectedNodes =>
      _nodes.where((node) => node.isSelected).toList();

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
  T getNodeById<T extends NodeData>(String id) {
    final node = _nodes.firstWhere(
      (n) => n.id == id,
      orElse: () => throw Exception("Node not found"),
    );

    if (node is T) {
      return node;
    } else {
      throw Exception("Node is not of type ${T.runtimeType}");
    }
  }

  int getNodeIndexById(String id) {
    final index = _nodes.indexWhere((n) => n.id == id);
    if (index == -1) {
      throw Exception("Node not found");
    }
    return index;
  }

  // void updateNodeWidth(String id, double width) {
  //   final nodeIndex = _nodes.indexWhere((n) => n.id == id);

  //   if (nodeIndex == -1) {
  //     throw Exception("Node not found");
  //   }

  //   final node = _nodes[nodeIndex];
  //   if (node is BaseNodeData) {
  //     final updatedNode = node.copyWith(nodeWidth: width);
  //     _nodes[nodeIndex] = updatedNode;
  //     notifyListeners();
  //   } else {
  //     throw Exception("Node is not BaseNodeData");
  //   }
  // }

  void initializeOutputs(String id) {
    int index = getNodeIndexById(id);
    VideoNodeData nodeData = _nodes[index] as VideoNodeData;

    // Check if outputs are empty and initialize them
    // if (nodeData.outputs.isEmpty) {
    //   nodeData = nodeData.copyWith(outputs: [Output(), Output(), Output()]);
    // }
    // Ensure outputs have at least 3 items
    while (nodeData.outputs.length < 3) {
      nodeData = nodeData.copyWith(outputs: [...nodeData.outputs, Output()]);
    }
    // Ensure the last two outputs are not both empty recursively
    while (nodeData.outputs.length > 3 &&
        (nodeData.outputs[nodeData.outputs.length - 1].outputData ?? '') ==
            '' &&
        (nodeData.outputs[nodeData.outputs.length - 2].outputData ?? '') ==
            '') {
      nodeData = nodeData.copyWith(outputs: nodeData.outputs..removeLast());
    }
    // Add a new output if the last output has non-empty text
    if (!((nodeData.outputs.last.outputData ?? '') == '')) {
      nodeData = nodeData.copyWith(outputs: [...nodeData.outputs, Output()]);
    }
    // Replace the node in the list with the updated node
    _nodes[index] = nodeData;

    // Notify listeners to rebuild the UI
    // notifyListeners();
  }

  int getEffectiveOutputs(String id) {
    int index = getNodeIndexById(id);
    VideoNodeData nodeData = _nodes[index] as VideoNodeData;
    if (nodeData.outputs.isEmpty) {
      return 3;
    } else if (nodeData.outputs.length <= 2) {
      return 3;
    } else {
      return nodeData.outputs.length + 1;
    }
  }

  void setVideoNodeOutputText(
      {required String id, required String text, required int outputIndex}) {
    int nodeIndex = getNodeIndexById(id);
    VideoNodeData nodeData = _nodes[nodeIndex] as VideoNodeData;

    if (nodeData.outputs.length == outputIndex + 1) {
      nodeData = nodeData.copyWith(outputs: [...nodeData.outputs, Output()]);
    }
    List<Output> newOutputs = nodeData.outputs;
    newOutputs[outputIndex] =
        newOutputs[outputIndex].copyWith(outputData: text);
    _nodes[nodeIndex] = nodeData.copyWith(outputs: newOutputs);

    for (int i = 0; i < newOutputs.length; i++) {
      print('Index: $i, Output: ${newOutputs[i].outputData.toString()}');
    }

    if (text == '') {
      initializeOutputs(id);
    }
  }

  // Update output position for a specific node
  void updateOutputPosition(String id, int outputIndex, Offset newPosition) {
    int nodeIndex = getNodeIndexById(id);

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

//   // Add a new node to the provider
//   void addNode(NodeData node) {
//     _nodes.add(node);
//     activeNodeId = node.id;
//     notifyListeners();
//   }

  // Toggle the 'expanded' state of a node
  void expandToggle(String id) {
    int nodeIndex = getNodeIndexById(id);
    final node = _nodes[nodeIndex];

    if (node is BaseNodeData) {
      final updatedNode = node.copyWith(isExpanded: !node.isExpanded);
      _nodes[nodeIndex] = updatedNode;
      notifyListeners();
    }
  }

  // Set the 'swatch' property for a node
  void setSwatch(String id, int swatch) {
    int nodeIndex = getNodeIndexById(id);
    final node = _nodes[nodeIndex];

    if (node is BaseNodeData) {
      final updatedNode = node.copyWith(swatch: swatch);
      _nodes[nodeIndex] = updatedNode;
      notifyListeners();
    }
  }

  // Set the active node by its ID
  void setActiveNode(String id) {
    int nodeIndex = getNodeIndexById(id);
    final node = _nodes[nodeIndex];

    // If the node is not already at the bottom of the list, move it
    if (nodeIndex != _nodes.length - 1) {
      _nodes.removeAt(nodeIndex);
      _nodes.add(node);
      notifyListeners();
    }
  }

  // Update the position of a node. Out of use currently.
  // void updateNodePosition(String id, Offset newPosition) {
  //   int nodeIndex = getNodeIndexById(id);
  //   final node = _nodes[nodeIndex];

  //   final updatedNode = node.copyWith(position: newPosition);

  //   _nodes[nodeIndex] = updatedNode;
  //   notifyListeners();
  // }

  void offsetNodePosition(String id, Offset offset, {bool snapToGrid = false}) {
    int nodeIndex = getNodeIndexById(id);
    final node = _nodes[nodeIndex];

    //Grid offset to make nodes snap to the corners of the dot pattern
    final double gridOffset =
        -UiStaticProperties.nodePadding - UiStaticProperties.topLeftToMiddle.dx;
    // Hardcoded grid size (TODO expose)
    const double gridSize = 50;

    Offset? newPosition;
    // Update intended position freely, without snapping
    Offset newIntendedPosition = node.intendedPosition + offset;
    // If snapping is enabled, snap the new intended position to the grid
    if (snapToGrid) {
      newPosition = Offset(
        ((newIntendedPosition.dx - gridOffset) / gridSize).round() * gridSize +
            gridOffset,
        ((newIntendedPosition.dy - gridOffset) / gridSize).round() * gridSize +
            gridOffset,
      );
    } else {
      newPosition = newIntendedPosition;
    }

    // Create the updated node
    final updatedNode = node.copyWith(
        intendedPosition: newIntendedPosition, position: newPosition);

    //update the node list
    _nodes[nodeIndex] = updatedNode;

    // Only trigger UI changes if position changed
    if (newPosition != node.position) {
      notifyListeners();
    }
  }

  void resizeNode(String id, Offset delta, bool isLeftSide) {
    double _getWidthFromDrag(
        double newIntendedNodeWidth, double widthSnappingAreaSize) {
      if (newIntendedNodeWidth < UiStaticProperties.nodeMinWidth) {
        return UiStaticProperties.nodeMinWidth;
      }

      if (newIntendedNodeWidth > UiStaticProperties.nodeMaxWidth) {
        return UiStaticProperties.nodeMaxWidth;
      }

      if ((newIntendedNodeWidth - UiStaticProperties.nodeDefaultWidth).abs() <=
          widthSnappingAreaSize) {
        //TODO de-hardcode
        return UiStaticProperties.nodeDefaultWidth;
      }
      return newIntendedNodeWidth;
    }

    int nodeIndex = getNodeIndexById(id);
    BaseNodeData node = _nodes[nodeIndex] as BaseNodeData;

    double defaultWidthSnappingAreaSize = 20;
    double newIntendedNodeWidth = isLeftSide
        ? node.intendedNodeWidth - delta.dx
        : node.intendedNodeWidth + delta.dx;
    double newNodeWidth =
        _getWidthFromDrag(newIntendedNodeWidth, defaultWidthSnappingAreaSize);

    // Create the updated node
    final updatedNode = node.copyWith(
        intendedNodeWidth: newIntendedNodeWidth, nodeWidth: newNodeWidth);

    //update the node list
    _nodes[nodeIndex] = updatedNode;

    // Only trigger UI changes if width changed
    if (newNodeWidth != node.nodeWidth) {
      if (isLeftSide) {
        offsetNodePosition(id, Offset(node.nodeWidth - newNodeWidth, 0));
      }
      notifyListeners();
    }
  }

  void resetNodeIntendedValues(String id) {
    int nodeIndex = getNodeIndexById(id);
    final node = _nodes[nodeIndex] as BaseNodeData;
    BaseNodeData updatedNode = node.copyWith(
        intendedPosition: node.position,
        intendedNodeWidth: node
            .nodeWidth); //the values should normally reset by themselves as set in model

    _nodes[nodeIndex] = updatedNode;
  }

  void rebuildNode(String id) {
    int nodeIndex = getNodeIndexById(id);
    final node = _nodes[nodeIndex] as BaseNodeData;
    BaseNodeData updatedNode = node
        .copyWith(); //the values should normally reset by themselves as set in model

    _nodes[nodeIndex] = updatedNode;
    notifyListeners();
  }

  // Remove a node from the list
  void removeNode(String id) {
    _nodes.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
