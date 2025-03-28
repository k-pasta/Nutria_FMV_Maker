// Helper function to select a starting node from the list.
// Here, we assume the starting node is the first BaseNodeData encountered.
import '../models/node_data/node_data.dart';

BaseNodeData findStartingNode(List<NodeData> nodes) {
  return nodes.isNotEmpty ? nodes.last as BaseNodeData : throw Exception('Empty Node List');
}

// Helper function to locate a node by its id.
BaseNodeData findNodeById(List<BaseNodeData> nodes, String id) {
  return nodes.firstWhere(
    (node) => node.id == id,
    orElse: () => throw Exception('Node with id $id not found'),
  );
}

// The main traversal function.
// It accepts a list of BaseNodeData (or NodeData that extend BaseNodeData)
// and returns the list of BaseNodeData found via traversal.
List<BaseNodeData> traverseNodes(List<NodeData> nodes) {
  // Filter the list to include only BaseNodeData.
  List<BaseNodeData> baseNodes = nodes.whereType<BaseNodeData>().toList();

  List<BaseNodeData> result = [];
  Set<String> visited = {};

  BaseNodeData startNode = findStartingNode(baseNodes);

  // Using a queue for breadth-first traversal.
  List<BaseNodeData> queue = [startNode];

  while (queue.isNotEmpty) {
    BaseNodeData current = queue.removeAt(0);

    // Skip this node if it was already processed.
    if (visited.contains(current.id)) {
      continue;
    }

    // Mark the current node as visited and add to the result list.
    visited.add(current.id);
    result.add(current);

    // Process each output that has a non-null targetNodeId.
    for (var output in current.outputs) {
      if (output.targetNodeId != null) {
        BaseNodeData nextNode = findNodeById(baseNodes, output.targetNodeId!);
        if (!visited.contains(nextNode.id)) {
          queue.add(nextNode);
        }
      }
    }
  }

  return result;
}
