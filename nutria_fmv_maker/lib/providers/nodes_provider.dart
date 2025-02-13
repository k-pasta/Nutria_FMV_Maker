import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/action_models.dart';
import 'package:nutria_fmv_maker/static_data/input_output_offset_calculator.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';
import '../custom_widgets/video_node.dart';
import '../models/app_theme.dart';
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

  List<Map<Offset, Offset>> noodlesStartAndEndPoints(AppTheme currentTheme) {
    List<Map<Offset, Offset>> noodles = [];

    for (var node in _nodes) {
      if (node is BaseNodeData) {
        for (var i = 0; i < node.outputs.length; i++) {
          var output = node.outputs[i];
          if (output.targetNodeId != null) {
            try {
              final targetNode =
                  getNodeById<BaseNodeData>(output.targetNodeId!);
              if (node is VideoNodeData && targetNode is VideoNodeData) {
                //TODO update code for other nodes
                noodles.add({
                  node.position +
                      InputOutputOffsetCalculator.outputOffset(
                          node, currentTheme, i): targetNode.position +
                      InputOutputOffsetCalculator.inputOffset(
                          targetNode, currentTheme)
                });
              }
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
    VideoData(id: 'a', videoDataPath: 'test/test.test.test'),
    VideoData(id: 'b', videoDataPath: ''),
  ];
  List<VideoData> get videos => List.unmodifiable(_videos);

  NoodleDragIntent? _currentDragIntent;

  // NoodleDragIntent? _toClearIfNothing;

  NoodleDragOutcome _currentDragOutcome = NoodleDragOutcome.empty();

  NoodleDragOutcome? _currentPotentialConnection;

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
    if (_currentDragIntent != null) {
      return true;
    } else {
      return false;
    }
  }

  // void setCurrentNodeIdUnderCursor(String? nodeId) {
  //   // _currentNodeIdUnderCursor = nodeId;
  //   notifyListeners();
  // }

  void setCurrentUnderCursor(NoodleDragOutcome noodleDragOutcome) {
    _currentDragOutcome = noodleDragOutcome;

    // Check if the user is dragging an output
    if (_currentDragIntent != null) {
      // Reset the 'isBeingHovered' state for all nodes
      resetHoveredAndTargeted();

      //check if over a node and not itself
      if (_currentDragOutcome.outcome != PossibleOutcome.empty &&
          _currentDragOutcome.nodeId != _currentDragIntent!.nodeId) {
        int targetNodeIndex = getNodeIndexById(_currentDragOutcome.nodeId);
        BaseNodeData targetNodeData = getNodeById(_currentDragOutcome.nodeId);

        // Case 1 : if starting from output and targeting input or node
        if (_currentDragIntent!.isOutput &&
            (_currentDragOutcome.outcome == PossibleOutcome.node ||
                _currentDragOutcome.outcome == PossibleOutcome.input)) {
          //set the target node as hovered and input knot as targeted
          _nodes[targetNodeIndex] = targetNodeData.copyWith(
              isBeingHovered: true, input: const Input(isBeingTargeted: true));
          //set potential connection
          _currentPotentialConnection =
              NoodleDragOutcome.input(targetNodeData.id);

          // Case 2 : if starting from input and targeting node
        } else if (!_currentDragIntent!.isOutput &&
            _currentDragOutcome.outcome == PossibleOutcome.node) {
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
                  NoodleDragOutcome.output(targetNodeData.id, i);
              break;
            }
          }

          // Case 3 : if starting from input and targeting output
        } else if (!_currentDragIntent!.isOutput &&
            _currentDragOutcome.outcome == PossibleOutcome.output) {
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
          _currentPotentialConnection = NoodleDragOutcome.output(
              targetNodeData.id, _currentDragOutcome.index);
        }
      }
      if (_currentDragOutcome.outcome == PossibleOutcome.empty) {
        //delete potential connection
        _currentPotentialConnection = null;
      }
      notifyListeners();
    }
  }

  void beginDragging(NoodleDragIntent dragIntent) {
    // Set Drag intent
    _currentDragIntent = dragIntent;

    // _toClearIfNothing = toClearIfNothing;

    // Get intended node's data
    int draggedNodeIndex = getNodeIndexById(dragIntent.nodeId);
    BaseNodeData draggedNodeData = getNodeById(dragIntent.nodeId);
    // Set intended node's knot state as isBeingDragged (to render thick)
    _nodes[draggedNodeIndex] = draggedNodeData.copyWith(
        input: dragIntent.isOutput
            ? draggedNodeData.input
            : const Input(isBeingDragged: true),
        outputs: dragIntent.isOutput
            ? [
                for (int i = 0; i < draggedNodeData.outputs.length; i++)
                  if (_currentDragIntent!.index == i)
                    draggedNodeData.outputs[i].copyWith(isBeingDragged: true)
                  else
                    draggedNodeData.outputs[i]
              ]
            : draggedNodeData.outputs);
    notifyListeners();
  }

  void endDragging() {
    // Reset the 'isBeingHovered' state for all nodes
    resetHoveredAndTargeted();
    // Reset the dragged node's
    resetDragged();
    // Attempt to connect nodes based on current Drag intent and Drag output
    attemptConnection();

    //  Reset the drag intent. No need to reset the output. this gets set each time a user hovers a node or knot
    _currentDragIntent = null;
    _currentPotentialConnection = null;
    // _toClearIfNothing = null;
    notifyListeners();
  }

  void attemptConnection() {
    if (_currentPotentialConnection != null) {
      if (_currentPotentialConnection!.outcome == PossibleOutcome.input &&
          _currentDragIntent!.isOutput) {
        int toChangeNodeIndex = getNodeIndexById(_currentDragIntent!.nodeId);
        BaseNodeData toChangeNodeData = getNodeById(_currentDragIntent!.nodeId);

        _nodes[toChangeNodeIndex] = toChangeNodeData.copyWith(outputs: [
          for (int i = 0; i < toChangeNodeData.outputs.length; i++)
            if (_currentDragIntent!.index == i)
              toChangeNodeData.outputs[i].copyWith(targetNodeId: () {
                return _currentPotentialConnection!.nodeId;
              })
            else
              toChangeNodeData.outputs[i]
        ]);
      } else if (_currentPotentialConnection!.outcome ==
              PossibleOutcome.output &&
          !_currentDragIntent!.isOutput) {
        int toChangeNodeIndex =
            getNodeIndexById(_currentPotentialConnection!.nodeId);
        BaseNodeData toChangeNodeData =
            getNodeById(_currentPotentialConnection!.nodeId);

        _nodes[toChangeNodeIndex] = toChangeNodeData.copyWith(outputs: [
          for (int i = 0; i < toChangeNodeData.outputs.length; i++)
            if (_currentPotentialConnection!.index == i)
              toChangeNodeData.outputs[i].copyWith(targetNodeId: () {
                return _currentDragIntent!.nodeId;
              })
            else
              toChangeNodeData.outputs[i]
        ]);

//also clear if changing from output to output
      }
    } else if (_currentPotentialConnection == null) {
      // print('no potential connection');
      if (_currentDragIntent!.isOutput) {
        int toChangeNodeIndex = getNodeIndexById(_currentDragIntent!.nodeId);
        BaseNodeData toChangeNodeData = getNodeById(_currentDragIntent!.nodeId);

        _nodes[toChangeNodeIndex] = toChangeNodeData.copyWith(outputs: [
          for (int i = 0; i < toChangeNodeData.outputs.length; i++)
            if (_currentDragIntent!.index == i)
              toChangeNodeData.outputs[i].copyWith(targetNodeId: () => null)
            else
              toChangeNodeData.outputs[i]
        ]);
      } else if (!_currentDragIntent!.isOutput) {}
    }
  }

  void clearOutput(NoodleDragIntent toclear) {
    int toChangeNodeIndex = getNodeIndexById(toclear.nodeId);
    BaseNodeData toChangeNodeData = getNodeById(toclear.nodeId);

    _nodes[toChangeNodeIndex] = toChangeNodeData.copyWith(outputs: [
      for (int i = 0; i < toChangeNodeData.outputs.length; i++)
        if (toclear.index == i)
          toChangeNodeData.outputs[i].copyWith(targetNodeId: () => null)
        else
          toChangeNodeData.outputs[i]
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
}



//   // Add a new node to the provider
//   void addNode(NodeData node) {
//     _nodes.add(node);
//     activeNodeId = node.id;
//     notifyListeners();
//   }
