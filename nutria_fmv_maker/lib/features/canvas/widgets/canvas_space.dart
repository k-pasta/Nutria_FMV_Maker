// Conversions between screen positions and canvas coordinates.
import 'package:flutter/widgets.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';

/// Marks the canvas surface so widgets inside or above it (knots, noodles,
/// drop targets) can convert positions to canvas coordinates, where (0, 0) is
/// the middle of the canvas. Unaffected by pan and zoom.
class CanvasSpace extends StatefulWidget {
  const CanvasSpace({super.key, required this.child});

  final Widget child;

  /// The nearest canvas, or `null` outside of one.
  static CanvasSpaceState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_CanvasSpaceScope>()?.state;

  @override
  State<CanvasSpace> createState() => CanvasSpaceState();
}

/// Converts between screen and canvas coordinates for the widgets below it.
class CanvasSpaceState extends State<CanvasSpace> {
  final _surfaceKey = GlobalKey();

  RenderBox? get _surface =>
      _surfaceKey.currentContext?.findRenderObject() as RenderBox?;

  /// A global (screen) position in canvas coordinates.
  Offset? fromGlobal(Offset global) {
    final surface = _surface;
    if (surface == null) return null;
    return surface.globalToLocal(global) - kCanvasCenter;
  }

  /// Where [point] (local to [box], which must be laid out inside the
  /// canvas) is in canvas coordinates.
  Offset? fromBox(RenderBox box, Offset point) {
    final surface = _surface;
    if (surface == null || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(point, ancestor: surface) - kCanvasCenter;
  }

  @override
  Widget build(BuildContext context) => _CanvasSpaceScope(
        state: this,
        child: KeyedSubtree(key: _surfaceKey, child: widget.child),
      );
}

class _CanvasSpaceScope extends InheritedWidget {
  const _CanvasSpaceScope({required this.state, required super.child});

  final CanvasSpaceState state;

  @override
  bool updateShouldNotify(_CanvasSpaceScope oldWidget) =>
      oldWidget.state != state;
}
