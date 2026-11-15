// The canvas viewport: pan and zoom over a very large virtual surface.
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'canvas_view_provider.g.dart';

/// Side length of the virtual canvas. Node positions are relative to its
/// center, so the canvas can be "infinite" in every direction.
const kCanvasSize = 2000000.0;

/// From the canvas' top-left corner to its center, where position (0, 0) is.
const kCanvasCenter = Offset(kCanvasSize / 2, kCanvasSize / 2);

/// Zoom change per scroll-wheel step.
const kZoomStep = 0.1;
const kMinZoom = 0.01;
const kMaxZoom = 300.0;

/// Pan distance of one arrow-key press, in screen pixels.
const kArrowPanStep = 100.0;

/// The `InteractiveViewer` transform plus the zoom/pan operations the app
/// performs on it. Listen to it (it's a [ChangeNotifier]) to repaint.
class CanvasViewController extends TransformationController {
  /// Starts with the canvas center at the viewport's top-left corner.
  CanvasViewController()
      : super(Matrix4.identity()
          ..translateByDouble(-kCanvasCenter.dx, -kCanvasCenter.dy, 0, 1));

  /// Size of the on-screen canvas. Keyboard zoom keeps its center fixed.
  Size get viewportSize => _viewportSize;
  Size _viewportSize = Size.zero;

  /// Called by the canvas widget after layout. The first time, the view is
  /// moved so that canvas position (0, 0) is in the middle of the screen.
  void setViewportSize(Size size) {
    final first = _viewportSize == Size.zero;
    _viewportSize = size;
    if (first && size != Size.zero) panBy(size.center(Offset.zero));
  }

  /// Current zoom factor (1 = 100%).
  double get scale => scaleOf(value);

  /// The zoom factor of a pan/zoom [matrix]. Not `getMaxScaleOnAxis`: zoom
  /// only scales x and y, so that would never report less than the z scale
  /// of 1.
  static double scaleOf(Matrix4 matrix) => matrix.storage[0];

  /// Zooms one step in or out, keeping [focalPoint] (viewport coordinates,
  /// e.g. the mouse position) fixed on screen.
  void zoomAt(Offset focalPoint, {required bool zoomIn}) {
    final current = scale;
    final next =
        (current * (zoomIn ? 1 + kZoomStep : 1 - kZoomStep)).clamp(kMinZoom, kMaxZoom);
    final factor = next / current;
    value = Matrix4.identity()
      ..translateByDouble(focalPoint.dx, focalPoint.dy, 0, 1)
      ..scaleByDouble(factor, factor, 1, 1)
      ..translateByDouble(-focalPoint.dx, -focalPoint.dy, 0, 1)
      ..multiply(value);
  }

  /// Zooms one step around the middle of the viewport (keyboard zoom).
  void zoomCentered({required bool zoomIn}) =>
      zoomAt(viewportSize.center(Offset.zero), zoomIn: zoomIn);

  /// Pans the view by [delta] in screen pixels.
  void panBy(Offset delta) {
    value = Matrix4.identity()
      ..translateByDouble(delta.dx, delta.dy, 0, 1)
      ..multiply(value);
  }

  /// Converts a viewport point to a node position (relative to the canvas
  /// center).
  Offset toCanvasPosition(Offset viewportPoint) =>
      toScene(viewportPoint) - kCanvasCenter;
}

/// The single canvas view of the app.
@Riverpod(keepAlive: true)
CanvasViewController canvasView(Ref ref) {
  final controller = CanvasViewController();
  ref.onDispose(controller.dispose);
  return controller;
}
