// All nodes, placed on the canvas in drawing order.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
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

class _NodeView extends ConsumerWidget {
  const _NodeView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final node = ref.watch(nodeProvider(id));
    if (node == null) return const SizedBox.shrink();
    return Positioned(
      left: kCanvasCenter.dx + node.position.x,
      top: kCanvasCenter.dy + node.position.y,
      child: NodeFrame(
        node: node,
        body: nodeBodyOf(node),
        expansion: nodeExpansionOf(node),
      ),
    );
  }
}
