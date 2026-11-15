// A node's connection point. Dragging it draws a noodle to another node.
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/canvas_space.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';

/// A rotated square on the node edge for an input or output [port]. It grows
/// while hovered, and while it's one end of the noodle being dragged.
class Knot extends ConsumerStatefulWidget {
  const Knot({super.key, required this.port});

  /// An output port, or [PortRef.input] for the node's input.
  final PortRef port;

  bool get isInput => port.port == PortRef.inputPortKey;

  @override
  ConsumerState<Knot> createState() => _KnotState();
}

class _KnotState extends ConsumerState<Knot> {
  bool _hovered = false;

  // Read once: the mouse-exit callback can fire while this widget is being
  // removed, when `ref` may no longer be used.
  late final ConnectionDragNotifier _drag =
      ref.read(connectionDragProvider.notifier);

  HoverTarget get _target => widget.isInput
      ? HoverTarget.input(widget.port.nodeId)
      : HoverTarget.output(widget.port);

  void _begin(DragStartDetails details) {
    final pointer =
        CanvasSpace.maybeOf(context)?.fromGlobal(details.globalPosition) ??
            Offset.zero;
    if (widget.isInput) {
      _drag.beginFromInput(widget.port.nodeId, pointer);
    } else {
      _drag.beginFromOutput(widget.port, pointer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final active = ref.watch(isKnotActiveProvider(widget.port));
    final dragging =
        ref.watch(connectionDragProvider.select((s) => s.anchor != null));
    final large = active || (_hovered && !dragging);
    final size = large ? kKnotSizeLarge : kKnotSizeSmall;
    return MouseRegion(
      cursor: SystemMouseCursors.precise,
      onEnter: (_) {
        setState(() => _hovered = true);
        _drag.hover(_target);
      },
      onExit: (_) {
        if (mounted) setState(() => _hovered = false);
        _drag.hover(const HoverTarget.none());
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _begin,
        // Local deltas are in canvas units: the knot is inside the canvas.
        onPanUpdate: (details) => _drag.updatePointer(details.delta),
        onPanEnd: (_) => _drag.end(),
        onPanCancel: _drag.end,
        child: SizedBox.square(
          dimension: kKnotHitSize,
          child: Center(
            child: AnimatedContainer(
              duration: kShortAnimation,
              width: size,
              height: size,
              transform: Matrix4.rotationZ(math.pi / 4),
              transformAlignment: Alignment.center,
              color: theme.cAccent,
            ),
          ),
        ),
      ),
    );
  }
}
