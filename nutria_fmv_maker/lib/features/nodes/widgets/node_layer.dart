// All nodes, placed on the canvas in drawing order.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';
import 'package:nutria_fmv_maker/features/nodes/node_registry.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/node_frame.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';

/// Rebuilds only when nodes are added, removed or reordered; each node
/// rebuilds on its own when it changes.
class NodeLayer extends ConsumerWidget {
  const NodeLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(nodePaintOrderProvider);
    return Positioned.fill(
      child: Stack(clipBehavior: Clip.none, children: [
        for (final id in ids) _NodeView(key: ValueKey(id), id: id),
      ]),
    );
  }
}

/// Places one node. Moving it only rebuilds this [Positioned]: the content
/// is the same widget instance every time, so Flutter skips rebuilding it,
/// and its [RepaintBoundary] lets the moved node be drawn from its last
/// picture instead of repainting every node.
class _NodeView extends ConsumerStatefulWidget {
  const _NodeView({super.key, required this.id});

  final String id;

  @override
  ConsumerState<_NodeView> createState() => _NodeViewState();
}

class _NodeViewState extends ConsumerState<_NodeView> {
  late final Widget _content =
      RepaintBoundary(child: _NodeContent(id: widget.id));

  @override
  Widget build(BuildContext context) {
    final position =
        ref.watch(nodeProvider(widget.id).select((n) => n?.position));
    if (position == null) return const SizedBox.shrink();
    return Positioned(
      left: kCanvasCenter.dx + position.x,
      top: kCanvasCenter.dy + position.y,
      child: _content,
    );
  }
}

/// Everything about a node except where it is.
class _NodeContent extends ConsumerWidget {
  const _NodeContent({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = ref.watch(nodeContentProvider(id));
    if (node == null) return const SizedBox.shrink();
    return NodeSizeReporter(
      id: id,
      bounds: ref.watch(nodeBoundsProvider),
      child: NodeFrame(
        node: node,
        body: nodeBodyOf(node),
        expansion: nodeExpansionOf(node),
      ),
    );
  }
}
