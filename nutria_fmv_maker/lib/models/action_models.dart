class UndoableAction {
  final void Function() undo;
  final void Function() redo;
  final String actionName;
  UndoableAction({required this.undo, required this.redo, required this.actionName});
}

class Action {
  final void Function() action;
  final String actionName;
  Action({required this.action, required this.actionName});
}

/// Represents the intent of a drag action involving a noodle (connection) in the UI.
///
/// This class is used to capture the details of a drag event, specifically
/// whether the drag started at an output or input node, and the associated node ID
/// and output index.
///
/// If the drag starts at an input knot, [outputIndex] will be `null`.
/// 
/// bool isOutput, String nodeId, int? outputIndex
class NoodleDragIntent {
  final bool isOutput;
  final String nodeId;
  final int? outputIndex;

  NoodleDragIntent.output(this.nodeId, this.outputIndex) : isOutput = true;
  NoodleDragIntent.input(this.nodeId)
      : outputIndex = null,
        isOutput = false;
}

/// Represents the outcome of a drag action involving a noodle (connection) in the UI.
///
/// This class is used to capture the details of a drag event, specifically
/// whether the drag ended at an output or input node, and the associated node ID
/// and output index.
///
/// If the drag ends at an input knot, [outputIndex] will be `null`.
/// 
/// String? nodeId, int? outputIndex
class NoodleDragOutcome {
  final String? nodeId;
  final int? outputIndex; //null if input

  NoodleDragOutcome(this.nodeId, this.outputIndex);
}

// UndoableAction moveNodeAction({
//   required NodesProvider nodesProvider,
//   required String nodeId,
//   required Offset newPosition,
//   required Offset oldPosition,
// }) {
//   return UndoableAction(
//     actionName: 'Move Node',
//     undo: () {
//       nodesProvider.setNodePosition(nodeId, oldPosition);
//     },
//     redo: () {
//       nodesProvider.setNodePosition(nodeId, newPosition);
//     },
//   );
// }