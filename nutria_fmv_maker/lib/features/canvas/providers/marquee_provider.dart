// Box selection: dragging on empty canvas selects the nodes the box touches.
import 'dart:ui';

import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'marquee_provider.g.dart';

/// The selection box being dragged, in node coordinates (relative to the
/// canvas center), or `null`.
@Riverpod(keepAlive: true)
class MarqueeNotifier extends _$MarqueeNotifier {
  Offset _start = Offset.zero;
  Set<String> _base = const {};

  @override
  Rect? build() => null;

  /// Starts a box at [point]. With [additive] (Ctrl), the nodes already
  /// selected stay selected; otherwise the box replaces the selection.
  void begin(Offset point, {required bool additive}) {
    _start = point;
    _base = additive ? ref.read(selectionProvider).selected : const {};
    state = Rect.fromPoints(point, point);
    _select();
  }

  /// Drags the box's free corner to [point].
  void update(Offset point) {
    if (state == null) return;
    state = Rect.fromPoints(_start, point);
    _select();
  }

  void end() => state = null;

  void _select() {
    final box = state;
    if (box == null) return;
    final doc = ref.read(documentProvider).document;
    final bounds = ref.read(nodeBoundsProvider);
    ref.read(selectionProvider.notifier).setSelected({
      ..._base,
      for (final node in doc.nodes.values)
        if (bounds.rectOf(node).overlaps(box)) node.id,
    });
  }
}
