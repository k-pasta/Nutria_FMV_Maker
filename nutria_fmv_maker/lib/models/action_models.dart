class Action {
  final void Function() doAction;
  final String actionName;
  Action({required this.doAction, required this.actionName});
}

class UndoableAction extends Action {
  final void Function() undoAction;
  UndoableAction({
    required this.undoAction,
    required Function() doAction,
    required String actionName,
  }) : super(
          doAction: doAction,
          actionName: actionName,
        );
}

class LogicalPosition {
  final String nodeId;
  final int index;
  final LogicalPositionType type;

  LogicalPosition.node(this.nodeId)
      : index = 0,
        type = LogicalPositionType.node;
  LogicalPosition.output(this.nodeId, this.index)
      : type = LogicalPositionType.output;
  LogicalPosition.input(this.nodeId)
      : index = 0,
        type = LogicalPositionType.input;
  LogicalPosition.empty()
      : nodeId = '',
        index = 0,
        type = LogicalPositionType.empty;
}

extension LogicalPositionExtensions on LogicalPosition {
  bool get isInput => type == LogicalPositionType.input;
  bool get isOutput => type == LogicalPositionType.output;
  bool get isNode => type == LogicalPositionType.node;
  bool get isEmpty => type == LogicalPositionType.empty;
}

enum LogicalPositionType { output, input, node, empty }

// /// Represents the intent of a drag action involving a noodle (connection) in the UI.
// ///
// /// This class is used to capture the details of a drag event, specifically
// /// whether the drag started at an output or input node, and the associated node ID
// /// and output index.
// ///
// ///
// /// String nodeId, int outputIndex
// class NoodleDragIntent {
//   final String nodeId;
//   final int index;
//   final bool isOutput;

//   NoodleDragIntent.output(this.nodeId, this.index) : isOutput = true;
//   NoodleDragIntent.input(this.nodeId)
//       : index = 0,
//         isOutput = false;
// }


// /// Represents the outcome of a drag action involving a noodle (connection) in the UI.
// ///
// /// This class is used to capture the details of a drag event, specifically
// /// whether the drag ended at an output or input node, and the associated node ID
// /// and output index.
// ///
// ///
// /// String? nodeId, int? outputIndex
// class NoodleDragOutcome {
//   final String nodeId;
//   final int index;
//   final LogicalPositionType outcome;

//   NoodleDragOutcome.node(this.nodeId)
//       : index = 0,
//         outcome = LogicalPositionType.node;
//   NoodleDragOutcome.output(this.nodeId, this.index)
//       : outcome = LogicalPositionType.output;
//   NoodleDragOutcome.input(this.nodeId)
//       : index = 0,
//         outcome = LogicalPositionType.input;
//   NoodleDragOutcome.empty()
//       : nodeId = '',
//         index = 0,
//         outcome = LogicalPositionType.empty;
// }

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
