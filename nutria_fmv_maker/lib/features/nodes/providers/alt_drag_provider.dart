// Alt on a node: show and drag its first free output.
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alt_drag_provider.g.dart';

/// Whether Alt is held, updated on every key press and release (so knots
/// react without the pointer moving).
@Riverpod(keepAlive: true)
class AltPressedNotifier extends _$AltPressedNotifier {
  @override
  bool build() {
    bool handler(KeyEvent _) {
      final pressed = HardwareKeyboard.instance.isAltPressed;
      if (pressed != state) state = pressed;
      return false; // Never consumes the key.
    }

    HardwareKeyboard.instance.addHandler(handler);
    ref.onDispose(() => HardwareKeyboard.instance.removeHandler(handler));
    return HardwareKeyboard.instance.isAltPressed;
  }
}

/// The knot shown enlarged while Alt is held over a node: the output an
/// Alt+drag would pull, or `null`.
@riverpod
PortRef? altPreviewPort(Ref ref) {
  if (!ref.watch(altPressedProvider)) return null;
  final hover = ref.watch(connectionDragProvider.select((s) => s.hover));
  if (hover is! HoverNode) return null;
  // Watch the document so the preview moves on once that output connects.
  final doc = ref.watch(projectDocumentProvider);
  final node = doc.nodes[hover.nodeId];
  if (node == null) return null;
  return firstFreeOutput(node, (port) => doc.edgeFrom(port) != null);
}
