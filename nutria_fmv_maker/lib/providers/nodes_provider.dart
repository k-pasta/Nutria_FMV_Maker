import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/action_models.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import '../custom_widgets/video_node.dart';
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
    VideoNodeData(
      id: 'x',
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
    VideoNodeData(
      id: 'xa',
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
    VideoNodeData(
      id: 'xjaa',
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
    VideoNodeData(
      id: 'xaha',
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
    VideoNodeData(
      id: 'xfaa',
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
    VideoNodeData(
      id: 'xada',
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
    VideoNodeData(
      id: 'xasa',
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
    VideoNodeData(
      id: 'xaaa',
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
    VideoNodeData(
      id: 'xapa',
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
    VideoNodeData(
      id: 'xaoa',
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
    VideoNodeData(
      id: 'xiaa',
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
    VideoNodeData(
      id: 'xaua',
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
    VideoNodeData(
      id: 'xaya',
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
    VideoNodeData(
      id: 'xata',
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
    VideoNodeData(
      id: 'xara',
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

  List<String> get iDs =>
      List.unmodifiable(_nodes.map((node) => node.id).toList());

  List<NodeData> get selectedNodes =>
      _nodes.where((node) => node.isSelected).toList();

// Getter for videos (returns an immutable list)
  final List<VideoData> _videos = [
    VideoData(id: 'a', videoDataPath: 'test/test.test.test'),
    VideoData(id: 'b', videoDataPath: ''),
  ];
  List<VideoData> get videos => List.unmodifiable(_videos);

  // String? _currentNodeIdUnderCursor = null;

  // String? get currentNodeIdUnderCursor => _currentNodeIdUnderCursor;

  bool _isUserDraggingOutput = false;

  NoodleDragIntent? _currentDragIntent = null;

  NoodleDragOutcome _currentDragOutcome = NoodleDragOutcome(null, null);

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
      nodeData = nodeData.copyWith(
          outputs: nodeData.outputs..removeLast()); //where i get error
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
    // Get the index of the node by its ID
    int nodeIndex = getNodeIndexById(id);
    // Cast the node to VideoNodeData
    VideoNodeData nodeData = _nodes[nodeIndex] as VideoNodeData;

    // If the output index is the last one, add a new empty output
    if (nodeData.outputs.length == outputIndex + 1 && outputIndex < 9) {
      nodeData = nodeData.copyWith(outputs: [...nodeData.outputs, Output()]);
    }
    if (outputIndex == 9) {
      nodeData = nodeData.copyWith(hasMaxedOutOutputs: true);
      notifyListeners();
    }
    // Create a new list of outputs with the updated text
    List<Output> newOutputs = nodeData.outputs;
    newOutputs[outputIndex] =
        newOutputs[outputIndex].copyWith(outputData: text);
    // Update the node with the new outputs
    _nodes[nodeIndex] = nodeData.copyWith(outputs: newOutputs);

    // Print the outputs for debugging
    for (int i = 0; i < newOutputs.length; i++) {
      print('Index: $i, Output: ${newOutputs[i].outputData.toString()}');
    }

    // If the text is empty, initialize the outputs
    if (text == '') {
      if (outputIndex == 9) {
        _nodes[nodeIndex] = nodeData.copyWith(hasMaxedOutOutputs: false);
        notifyListeners();
      }
      initializeOutputs(id);
    }
  }

  // Update output position for a specific node
  // void updateOutputPosition(String id, int outputIndex, Offset newPosition) {
  //   int nodeIndex = getNodeIndexById(id);

  //   final node = _nodes[nodeIndex];
  //   if (node is VideoNodeData) {
  //     if (outputIndex < node.outputs.length) {
  //       final updatedOutputs = List<Output>.from(node.outputs)
  //         ..[outputIndex] = node.outputs[outputIndex].copyWith(
  //           outputOffsetFromTopLeft: newPosition,
  //         );

  //       _nodes[nodeIndex] = node.copyWith(outputs: updatedOutputs);
  //       notifyListeners();
  //     }
  //   }
  // }

//   // Add a new node to the provider
//   void addNode(NodeData node) {
//     _nodes.add(node);
//     activeNodeId = node.id;
//     notifyListeners();
//   }

  void setCurrentUnderCursor({String? id, int? outputIndex}) {
    // if (_currentDragIntent != null && _currentDragIntent) {

    // }
    _currentDragOutcome = NoodleDragOutcome(id, outputIndex);
    // Check if the user is dragging an output
    if (_isUserDraggingOutput) {
      if (id != null) {
        int nodeIndex = getNodeIndexById(id);
        NodeData nodeData = _nodes[nodeIndex];
        // Reset the 'isBeingHovered' state for all nodes
        for (var node in _nodes) {
          if (node.isBeingHovered) {
            node = node.copyWith(isBeingHovered: false);
          }
        }
        // Set the 'isBeingHovered' state for the current node
        _nodes[nodeIndex] = nodeData.copyWith(isBeingHovered: true);
      }
      if (id == null) {
        // Reset the 'isBeingHovered' state for all nodes if no node is under the cursor
        for (var node in _nodes) {
          if (node.isBeingHovered) {
            int index = getNodeIndexById(node.id);
            _nodes[index] = node.copyWith(isBeingHovered: false);
          }
        }
      }
      notifyListeners();
    }
  }

  void beginDragging(NoodleDragIntent dragIntent) {
    _isUserDraggingOutput = true;
    _currentDragIntent = dragIntent;
  }

  void endDragging() {
    // Reset the 'isBeingHovered' state for all nodes
    for (var node in _nodes) {
      if (node.isBeingHovered) {
        int index = getNodeIndexById(node.id);
        _nodes[index] = node.copyWith(isBeingHovered: false);
      }
    }

    if (_currentDragOutcome.nodeId != null) {
      attemptConnection(_currentDragOutcome!);
    }
    else {
      print('No drag outcome');
    }

    _isUserDraggingOutput = false;
    _currentDragIntent = null;
    notifyListeners();
  }

  void attemptConnection(NoodleDragOutcome dragOutcome) {
    if (_currentDragIntent != null) {
      if (_currentDragIntent!.isOutput) {
        //if the drag ends at an input node
        if (dragOutcome.nodeId != null && dragOutcome.outputIndex == null) {
          BaseNodeData node = getNodeById(dragOutcome.nodeId!);
          dynamic newNode = node.copyWith(
            outputs: [
              for (int i = 0; i < node.outputs.length; i++)
                if (i == _currentDragIntent!.outputIndex)
                  node.outputs[i].copyWith(targetNodeId: dragOutcome.nodeId)
                else
                  node.outputs[i]
            ],
          );
          print('here');
        }

      } else if (!_currentDragIntent!.isOutput) {}
    }
  }

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
