class UndoableAction {
  final void Function() undo;
  final void Function() redo;
  final String actionName;
  UndoableAction(
      {required this.undo, required this.redo, required this.actionName});
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
///
/// String nodeId, int outputIndex
class NoodleDragIntent {
  final String nodeId;
  final int index;
  final bool isOutput;

  NoodleDragIntent.output(this.nodeId, this.index) : isOutput = true;
  NoodleDragIntent.input(this.nodeId)
      : index = 0,
        isOutput = false;
}

enum PossibleOutcome { output, input, node, empty }

/// Represents the outcome of a drag action involving a noodle (connection) in the UI.
///
/// This class is used to capture the details of a drag event, specifically
/// whether the drag ended at an output or input node, and the associated node ID
/// and output index.
///
///
/// String? nodeId, int? outputIndex
class NoodleDragOutcome {
  final String nodeId;
  final int index;
  final PossibleOutcome outcome;

  NoodleDragOutcome.node(this.nodeId)
      : index = 0,
        outcome = PossibleOutcome.node;
  NoodleDragOutcome.output(this.nodeId, this.index)
      : outcome = PossibleOutcome.output;
  NoodleDragOutcome.input(this.nodeId)
      : index = 0,
        outcome = PossibleOutcome.input;
  NoodleDragOutcome.empty()
      : nodeId = '',
        index = 0,
        outcome = PossibleOutcome.empty;
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
