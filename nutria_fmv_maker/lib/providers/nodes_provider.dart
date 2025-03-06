import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/action_models.dart';
import 'package:nutria_fmv_maker/models/noodle_data.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:path/path.dart' as p;
import 'package:tuple/tuple.dart';
import '../models/app_theme.dart';
import '../models/node_data.dart';
import 'dart:math';

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
        Output(outputData: 'First text', targetNodeId: 'aaa'),
        Output(outputData: ''),
        Output(outputData: ''),
        Output(outputData: ''),
        Output(outputData: ''),
      ],
    ),
    // VideoNodeData(
    //   id: 'x',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xa',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xjaa',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xaha',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xfaa',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xada',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xasa',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xaaa',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xapa',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xaoa',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xiaa',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xaua',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xaya',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xata',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
    // VideoNodeData(
    //   id: 'xara',
    //   position: const Offset(150, 20),
    //   videoDataId: 'a',
    //   outputs: <Output>[
    //     Output(outputData: 'First text'),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //     Output(outputData: ''),
    //   ],
    // ),
  ];

  // Getter for nodes (returns an immutable list)
  List<NodeData> get nodes => List.unmodifiable(_nodes);

  List<String> get iDs =>
      List.unmodifiable(_nodes.map((node) => node.id).toList());

  List<Offset> get positions =>
      List.unmodifiable(_nodes.map((node) => node.position).toList());

  List<Output> get outputs => List.unmodifiable(
      _nodes.whereType<BaseNodeData>().expand((node) => node.outputs).toList());

//tuple for the noodle drawer to listen to
  Tuple2<List<Offset>, List<Output>> get positionsAndOutputs {
    return Tuple2(positions, outputs);
  }

  List<NodeData> get selectedNodes =>
      _nodes.where((node) => node.isSelected).toList();

  List<NoodleData> noodlesStartAndEndPoints(AppTheme currentTheme) {
    List<NoodleData> noodles = [];

    for (var node in _nodes) {
      if (node is BaseNodeData) {
        for (var i = 0; i < node.outputs.length; i++) {
          var output = node.outputs[i];
          if (output.targetNodeId != null) {
            try {
              final targetNode =
                  getNodeById<BaseNodeData>(output.targetNodeId!);
              //TODO update code for other nodes
              noodles.add(NoodleData(
                      startPosition:
                          node.position + node.outputPosition(currentTheme, i),
                      endPosition: targetNode.position +
                          targetNode.inputPosition(currentTheme))
                  //   {
                  //   node.position + node.outputPosition(currentTheme, i):
                  //       targetNode.position + targetNode.inputPosition(currentTheme)
                  // }
                  );
            } catch (e) {
              // Handle the case where the target node is not found
              print('Target node not found: ${output.targetNodeId}');
            }
          }
        }
      }
    }

    return noodles;
  }

// Getter for videos (returns an immutable list)
  final List<VideoData> _videos = [
    VideoData(
        id: 'a',
        videoDataPath: 'c:/Users/cgbook/Desktop/Eykolo_anoigma_roughcut_4.mp4',
        thumbnailPath: 'C:/Users/cgbook/Desktop/cats.jpg'),
    VideoData(id: 'b', videoDataPath: ''),
  ];
  List<VideoData> get videos => List.unmodifiable(_videos);

// Function to get VideoData by its ID
  VideoData getVideoDataById(String videoDataId) {
    return _videos.firstWhere(
      (video) => video.id == videoDataId,
      orElse: () => throw Exception("VideoData not found"),
    );
  }

  // NoodleDragIntent get currentDragIntent => _currentDragIntent!;

  // NoodleDragIntent? _toClearIfNothing;
  LogicalPosition _currentDragIntent = LogicalPosition.empty();

  LogicalPosition _currentDragOutcome = LogicalPosition.empty();

  LogicalPosition _currentPotentialConnection = LogicalPosition.empty();

  // String? activeNodeId; //should make a getter

  NoodleData? _currentNoodle;

  NoodleData? get currentNoodle {
    return _currentNoodle;
  }

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
      nodeData =
          nodeData.copyWith(outputs: [...nodeData.outputs, const Output()]);
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
    if (!((nodeData.outputs.last.outputData ?? '') == '') &&
        !nodeData.hasMaxedOutOutputs) {
      nodeData =
          nodeData.copyWith(outputs: [...nodeData.outputs, const Output()]);
      print('from here');
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
      print('Added new output');
    }
    if (outputIndex == 9) {
      nodeData = nodeData.copyWith(hasMaxedOutOutputs: true);
      notifyListeners();
    }
    // Create a new list of outputs with the updated text
    List<Output> newOutputs = nodeData.outputs;
    newOutputs[outputIndex] = newOutputs[outputIndex].copyWith(outputData: () {
      return text;
    });
    // Update the node with the new outputs
    _nodes[nodeIndex] = nodeData.copyWith(outputs: newOutputs);

    // Print the outputs for debugging
    for (int i = 0; i < newOutputs.length; i++) {
      // print('Index: $i, Output: ${newOutputs[i].outputData.toString()}');
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

  void resetHoveredAndTargeted() {
    for (var node in _nodes) {
      if (node is BaseNodeData) {
        int index = getNodeIndexById(node.id);
        _nodes[index] = node.copyWith(
          isBeingHovered: false,
          input: node.input.copyWith(isBeingTargeted: false),
          outputs: node.outputs
              .map((output) => output.copyWith(isBeingTargeted: false))
              .toList(),
        );
      }
    }
  }

  void resetDragged() {
    for (var node in _nodes) {
      if (node is BaseNodeData) {
        int index = getNodeIndexById(node.id);
        _nodes[index] = node.copyWith(
          input: node.input.copyWith(isBeingDragged: false),
          outputs: node.outputs
              .map((output) => output.copyWith(isBeingDragged: false))
              .toList(),
        );
      }
    }
  }

  bool get isDraggingNoodle {
    if (_currentDragIntent.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // void setCurrentNodeIdUnderCursor(String? nodeId) {
  //   // _currentNodeIdUnderCursor = nodeId;
  //   notifyListeners();
  // }

  void setCurrentUnderCursor(LogicalPosition hoveredLogicalPosition) {
    _currentDragOutcome = hoveredLogicalPosition;

    // Check if the user is dragging an output
    if (_currentDragIntent.isInput || _currentDragIntent.isOutput) {
      // Reset the 'isBeingHovered' state for all nodes
      resetHoveredAndTargeted();

      //check if over a node and not itself
      if (!_currentDragOutcome.isEmpty &&
          _currentDragOutcome.nodeId != _currentDragIntent.nodeId) {
        int targetNodeIndex = getNodeIndexById(_currentDragOutcome.nodeId);
        BaseNodeData targetNodeData = getNodeById(_currentDragOutcome.nodeId);

        // Case 1 : if starting from output and targeting input or node
        if (_currentDragIntent.isOutput &&
            (_currentDragOutcome.isNode || _currentDragOutcome.isInput)) {
          //set the target node as hovered and input knot as targeted
          _nodes[targetNodeIndex] = targetNodeData.copyWith(
              isBeingHovered: true, input: const Input(isBeingTargeted: true));
          //set potential connection
          _currentPotentialConnection =
              LogicalPosition.input(targetNodeData.id);

          // Case 2 : if starting from input and targeting node
        } else if (_currentDragIntent.isInput && _currentDragOutcome.isNode) {
          // For each knot in the target node
          for (int i = 0; i < targetNodeData.outputs.length - 1; i++) {
            // If available knots exist
            if (targetNodeData.outputs[i].targetNodeId == null) {
              //target the first one and set node as being hovered
              _nodes[targetNodeIndex] = targetNodeData.copyWith(
                isBeingHovered: true,
                outputs: [
                  for (int j = 0;
                      j < targetNodeData.outputs.length;
                      j++) //subtracting 1 to exclude unexposed output (final)
                    if (i == j)
                      targetNodeData.outputs[j].copyWith(isBeingTargeted: true)
                    else
                      targetNodeData.outputs[j]
                ],
              );
              //set potential connection
              _currentPotentialConnection =
                  LogicalPosition.output(targetNodeData.id, i);
              break;
            }
          }

          // Case 3 : if starting from input and targeting output
        } else if (_currentDragIntent.isInput && _currentDragOutcome.isOutput) {
          //target regardless of empty or not
          _nodes[targetNodeIndex] = targetNodeData.copyWith(
            isBeingHovered: true,
            outputs: [
              for (int i = 0; i < targetNodeData.outputs.length; i++)
                if (_currentDragOutcome.index == i)
                  targetNodeData.outputs[i].copyWith(isBeingTargeted: true)
                else
                  targetNodeData.outputs[i]
            ],
          );
          //set potential connection
          _currentPotentialConnection = LogicalPosition.output(
              targetNodeData.id, _currentDragOutcome.index);
        }
      } else if (_currentDragOutcome.isEmpty) {
        //delete potential connection
        _currentPotentialConnection = LogicalPosition.empty();
      }
    } else if (_currentDragIntent.isVideoFile) {
      if (_currentDragOutcome.isEmpty) {
        print('possibly creating');
      }
      if (_currentDragOutcome.isNode) {
        int targetNodeIndex = getNodeIndexById(_currentDragOutcome.nodeId);
        BaseNodeData targetNodeData = getNodeById(_currentDragOutcome.nodeId);

        print('possibly swapping');
      }
    }

    notifyListeners();
  }

  void beginDragging(LogicalPosition knotToConnect) {
    // Set Drag intent
    _currentDragIntent = knotToConnect;

    if (_currentDragIntent.isInput || _currentDragIntent.isOutput) {
      // Get intended node's data
      int draggedNodeIndex = getNodeIndexById(_currentDragIntent.nodeId);
      BaseNodeData draggedNodeData = getNodeById(_currentDragIntent.nodeId);

      // Set intended node's knot state as isBeingDragged (to render thick)
      _nodes[draggedNodeIndex] = draggedNodeData.copyWith(
          input: _currentDragIntent.type == LogicalPositionType.input
              ? const Input(isBeingDragged: true)
              : draggedNodeData.input,
          outputs: _currentDragIntent.type == LogicalPositionType.output
              ? [
                  for (int i = 0; i < draggedNodeData.outputs.length; i++)
                    if (_currentDragIntent.index == i)
                      draggedNodeData.outputs[i].copyWith(isBeingDragged: true)
                    else
                      draggedNodeData.outputs[i]
                ]
              : draggedNodeData.outputs);
      notifyListeners();
    }
  }

  void beginNoodle({
    required LogicalPosition currentLogicalPosition,
    required LogicalPosition currentLogicalStartPosition,
    required AppTheme currentTheme,
    required Offset hitPosition,
  }) {
    BaseNodeData currentNodeData = getNodeById(currentLogicalPosition.nodeId);
    BaseNodeData startNodeData =
        getNodeById(currentLogicalStartPosition.nodeId);

    Offset start = Offset.zero;
    Offset end = Offset.zero;
    bool startLocked = false;
    bool endLocked = false;

    Offset currentLockedPosition = startNodeData.position;
    // UiStaticProperties.topLeftToMiddle +
    // const Offset(UiStaticProperties.knotSizeLarge * sqrt2 / 2,
    //     UiStaticProperties.knotSizeLarge * sqrt2 / 2);

    Offset currentFreePosition = currentNodeData.position +
        // UiStaticProperties.topLeftToMiddle +
        hitPosition;
    // -
    // const Offset(UiStaticProperties.knotSizeLarge * sqrt2 / 2,
    //     UiStaticProperties.knotSizeLarge * sqrt2 / 2);

    if (currentLogicalStartPosition.isOutput) {
      startLocked = true;

      start = currentLockedPosition +
          currentNodeData.outputPosition(
              currentTheme, currentLogicalPosition.index);

      end = currentFreePosition +
          currentNodeData.outputPosition(
              currentTheme, currentLogicalPosition.index) -
          const Offset(UiStaticProperties.knotSizeLarge * sqrt2 / 2,
              UiStaticProperties.knotSizeLarge * sqrt2 / 2);
    } else if (currentLogicalStartPosition.isInput) {
      endLocked = true;
      Offset knotPosition = currentLogicalPosition.isInput
          ? currentNodeData.inputPosition(currentTheme)
          : currentNodeData.outputPosition(
              currentTheme, currentLogicalPosition.index);
      start = currentFreePosition +
          knotPosition -
          const Offset(UiStaticProperties.knotSizeLarge * sqrt2 / 2,
              UiStaticProperties.knotSizeLarge * sqrt2 / 2);

      end = currentLockedPosition + startNodeData.inputPosition(currentTheme);
    }

    _currentNoodle = NoodleData(
      startPosition: start,
      endPosition: end,
      startLocked: startLocked,
      endLocked: endLocked,
    );
  }

  void setDraggedNoodle(Offset position, Offset delta) {
    // if (_currentPotentialConnection.isEmpty) {
    if (_currentDragIntent.isInput) {
      _currentNoodle = _currentNoodle!
          .copyWith(startPosition: _currentNoodle!.startPosition + delta);
    } else if (_currentDragIntent.isOutput) {
      _currentNoodle = _currentNoodle!
          .copyWith(endPosition: _currentNoodle!.endPosition + delta);
    }
    // }
    notifyListeners();
  }

  void endDragging() {

if (_currentDragIntent.isInput || _currentDragIntent.isOutput) {
  //reset the dragged noodle position
    _currentNoodle = null;

    // Reset the 'isBeingHovered' state for all nodes
    resetHoveredAndTargeted();
    // Reset the dragged node's
    resetDragged();
    // Attempt to connect nodes based on current Drag intent and Drag output
    attemptConnection();
} else if (_currentDragIntent.isVideoFile) {
if(_currentDragOutcome.isEmpty){
  // addNode(VideoNodeData(position: position, id: 'a', videoDataId: _currentDragIntent.videoFileId));
}
}
  

    //  Reset the drag intent. No need to reset the output. this gets set each time a user hovers a node or knot
    _currentDragIntent = LogicalPosition.empty();
    _currentPotentialConnection = LogicalPosition.empty();
    // _toClearIfNothing = null;
    notifyListeners();
  }

  void attemptConnection() {
    if (!_currentPotentialConnection.isEmpty) {
      if (_currentPotentialConnection.isInput && _currentDragIntent.isOutput) {
        int toSetNodeIndex = getNodeIndexById(_currentDragIntent.nodeId);
        BaseNodeData toSetNodeData = getNodeById(_currentDragIntent.nodeId);

        _nodes[toSetNodeIndex] = toSetNodeData.copyWith(outputs: [
          for (int i = 0; i < toSetNodeData.outputs.length; i++)
            if (_currentDragIntent.index == i)
              toSetNodeData.outputs[i].copyWith(targetNodeId: () {
                return _currentPotentialConnection.nodeId;
              })
            else
              toSetNodeData.outputs[i]
        ]);
      } else if (_currentPotentialConnection.isOutput &&
          _currentDragIntent.isInput) {
        int toSetNodeIndex =
            getNodeIndexById(_currentPotentialConnection.nodeId);
        BaseNodeData toSetNodeData =
            getNodeById(_currentPotentialConnection.nodeId);

        _nodes[toSetNodeIndex] = toSetNodeData.copyWith(outputs: [
          for (int i = 0; i < toSetNodeData.outputs.length; i++)
            if (_currentPotentialConnection.index == i)
              toSetNodeData.outputs[i].copyWith(targetNodeId: () {
                return _currentDragIntent.nodeId;
              })
            else
              toSetNodeData.outputs[i]
        ]);
        //also clear if changing from output to output
      }
    } else if (_currentPotentialConnection.isEmpty) {
      if (_currentDragIntent.isOutput) {
      } else if (_currentDragIntent.isInput) {}
    }
  }

  void clearOutput(LogicalPosition toclear) {
    int toSetNodeIndex = getNodeIndexById(toclear.nodeId);
    BaseNodeData toSetNodeData = getNodeById(toclear.nodeId);

    _nodes[toSetNodeIndex] = toSetNodeData.copyWith(outputs: [
      for (int i = 0; i < toSetNodeData.outputs.length; i++)
        if (toclear.index == i)
          toSetNodeData.outputs[i].copyWith(targetNodeId: () => null)
        else
          toSetNodeData.outputs[i]
    ]);
  }

  void setOutput(
      int indexOfNodeToEdit, int indexOfOutputToEdit, String? targetId) {}

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

  // Add a new node to the provider
  void addNode(NodeData node) {
    _nodes.add(node);
    notifyListeners();
  }
}
