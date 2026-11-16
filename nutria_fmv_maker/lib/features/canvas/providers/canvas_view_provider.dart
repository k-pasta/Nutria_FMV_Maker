// The canvas viewport: pan and zoom over a very large virtual surface.
import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
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

/// Free space kept around nodes when the view is framed on them.
const kFrameMargin = 60.0;

/// How long the view takes to glide to framed nodes.
const kFrameAnimation = Duration(milliseconds: 250);

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
    _stopAnimation();
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
    _stopAnimation();
    value = Matrix4.identity()
      ..translateByDouble(delta.dx, delta.dy, 0, 1)
      ..multiply(value);
  }

  /// Converts a viewport point to a node position (relative to the canvas
  /// center).
  Offset toCanvasPosition(Offset viewportPoint) =>
      toScene(viewportPoint) - kCanvasCenter;

  /// The node position in the middle of the viewport.
  Offset get center => toCanvasPosition(viewportSize.center(Offset.zero));

  /// Shows [point] (node coordinates) in the middle of the viewport at
  /// [scale] (default: the current zoom).
  void centerOn(Offset point, {double? scale}) {
    _stopAnimation();
    value = _viewOf(point, scale ?? this.scale);
  }

  /// Fits [rect] (node coordinates) into the viewport with [kFrameMargin]
  /// around it, zooming out as far as needed but never in past 100%. With
  /// [animate], the view glides there; any pan or zoom stops it.
  void frame(Rect rect, {bool animate = false}) {
    final room = Size(
      math.max(1, viewportSize.width - kFrameMargin * 2),
      math.max(1, viewportSize.height - kFrameMargin * 2),
    );
    final fit = math.min(room.width / math.max(1, rect.width),
        room.height / math.max(1, rect.height));
    final target = fit.clamp(kMinZoom, 1.0);
    if (!animate) return centerOn(rect.center, scale: target);
    _animate(rect.center, target);
  }

  /// The pan/zoom that shows node position [point] in the viewport's middle.
  Matrix4 _viewOf(Offset point, double scale) {
    final scene = point + kCanvasCenter;
    final middle = viewportSize.center(Offset.zero);
    return Matrix4.identity()
      ..translateByDouble(
          middle.dx - scene.dx * scale, middle.dy - scene.dy * scale, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);
  }

  Ticker? _ticker;

  /// Glides the middle of the view to [point] and the zoom to [scale]. The
  /// zoom changes geometrically, so zooming far in or out feels even.
  void _animate(Offset point, double scale) {
    _stopAnimation();
    final fromPoint = center;
    final fromScale = this.scale;
    _ticker = Ticker((elapsed) {
      final t = (elapsed.inMicroseconds / kFrameAnimation.inMicroseconds)
          .clamp(0.0, 1.0);
      final e = Curves.easeOutCubic.transform(t);
      value = _viewOf(Offset.lerp(fromPoint, point, e)!,
          fromScale * math.pow(scale / fromScale, e));
      if (t == 1) _stopAnimation();
    }, debugLabel: 'canvas framing')
      ..start();
  }

  void _stopAnimation() {
    _ticker?.dispose();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopAnimation();
    super.dispose();
  }
}

/// The single canvas view of the app.
@Riverpod(keepAlive: true)
CanvasViewController canvasView(Ref ref) {
  final controller = CanvasViewController();
  ref.onDispose(controller.dispose);
  return controller;
}
