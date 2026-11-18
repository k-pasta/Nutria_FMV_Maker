// Where nodes are on the canvas, including their laid-out height, for box
// selection and framing the view.
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'node_bounds.g.dart';

/// Height assumed for a node that hasn't been laid out yet.
const kUnmeasuredNodeHeight = 200.0;

/// The laid-out size of every node, written by the node widgets as they lay
/// out. A plain registry rather than state: nothing rebuilds when it changes;
/// it's read on demand (box selection, framing).
class NodeBounds {
  final Map<String, Size> _sizes = {};

  /// Records the size of node [id]'s padded box (see `NodeFrame`).
  void report(String id, Size size) => _sizes[id] = size;

  void forget(String id) => _sizes.remove(id);

  /// The visible card of [node] (without the knot padding), in node
  /// coordinates (relative to the canvas center). An attached comment is
  /// placed on top of its [host] (see [attachedCommentRect]).
  Rect rectOf(Node node, {Node? host}) {
    final size = _sizes[node.id];
    if (node is CommentNode && host != null) {
      // Attached comments have no padding above or below (see
      // `CommentFrame`).
      return attachedCommentRect(
        rectOf(host),
        size?.height ?? kUnmeasuredNodeHeight,
      );
    }
    final width = size == null ? node.width : size.width - kNodePadding * 2;
    final height = size == null
        ? kUnmeasuredNodeHeight
        : size.height - kNodePadding * 2;
    return Rect.fromLTWH(
      node.position.x + kNodePadding,
      node.position.y + kNodePadding,
      width,
      height,
    );
  }

  /// The smallest rect around the nodes [ids] of [doc] (all of them if
  /// [ids] is null), or `null` if there are none.
  Rect? boundsOf(ProjectDocument doc, {Iterable<String>? ids}) {
    Rect? bounds;
    for (final id in ids ?? doc.nodes.keys) {
      final node = doc.nodes[id];
      if (node == null) continue;
      final rect = rectOf(node, host: doc.hostOf(node));
      bounds = bounds?.expandToInclude(rect) ?? rect;
    }
    return bounds;
  }
}

/// Where a comment [height] tall sits on a node whose card is [hostCard]:
/// right above it, [kCommentGap] away, as wide as the card.
Rect attachedCommentRect(Rect hostCard, double height) => Rect.fromLTWH(
  hostCard.left,
  hostCard.top - kCommentGap - height,
  hostCard.width,
  height,
);

/// Space between an attached comment and its node, in canvas units (the
/// same as between a node and its settings panel).
const kCommentGap = 5.0;

/// The node a comment is attached to.
extension CommentHosts on ProjectDocument {
  Node? hostOf(Node node) =>
      node is CommentNode ? nodes[node.attachedTo] : null;
}

/// The app's node size registry.
@Riverpod(keepAlive: true)
NodeBounds nodeBounds(Ref ref) => NodeBounds();

/// Reports its child's size to [bounds] under [id] after every layout.
class NodeSizeReporter extends SingleChildRenderObjectWidget {
  const NodeSizeReporter({
    super.key,
    required this.id,
    required this.bounds,
    super.child,
  });

  final String id;
  final NodeBounds bounds;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderNodeSizeReporter(id, bounds);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderNodeSizeReporter renderObject,
  ) {
    renderObject
      ..id = id
      ..bounds = bounds;
  }
}

/// See [NodeSizeReporter]. Sizes of removed nodes are left in the registry:
/// lookups always start from the document's nodes, so they are never used.
class RenderNodeSizeReporter extends RenderProxyBox {
  RenderNodeSizeReporter(this.id, this.bounds);

  String id;
  NodeBounds bounds;

  @override
  void performLayout() {
    super.performLayout();
    bounds.report(id, size);
  }
}
