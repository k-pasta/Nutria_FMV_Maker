// Node geometry: row heights and knot positions, shared by the node widgets
// (which size their rows with it) and the noodles (which attach to the knots).
import 'dart:math' as math;
import 'dart:ui';

import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// Side of a knot (a rotated square) while idle and while hovered or active.
const kKnotSizeSmall = 17.0;
const kKnotSizeLarge = 25.0;

/// The square a knot is hit-tested in: a large knot rotated 45 degrees.
const kKnotHitSize = kKnotSizeLarge * math.sqrt2;

/// The theme sizes node rows are built from.
class NodeMetrics {
  const NodeMetrics({
    required this.swatchHeight,
    required this.textHeight,
    required this.panelPadding,
    required this.rowHeight,
  });

  NodeMetrics.of(AppTheme theme)
      : this(
          swatchHeight: theme.dSwatchHeight,
          textHeight: theme.dTextHeight,
          panelPadding: theme.dPanelPadding,
          rowHeight: theme.dButtonHeight,
        );

  final double swatchHeight;
  final double textHeight;
  final double panelPadding;

  /// Height of buttons and one-line text fields.
  final double rowHeight;

  /// The colored strip on top; taller when the node has a name.
  double stripHeight(Node node) =>
      node.name == null ? swatchHeight : swatchHeight + textHeight;

  /// The video thumbnail (or origin preview). It keeps the 16:9 shape of a
  /// default-width node at every width, so resizing doesn't move knots.
  double get thumbnailHeight => kDefaultNodeWidth * 9 / 16;

  /// One row with [panelPadding] above and below (file name, buttons).
  double get paddedRowHeight => rowHeight + panelPadding * 2;

  /// Distance between the tops of two consecutive choice rows.
  double get choiceStride => rowHeight + panelPadding;
}

/// Where a node's knots are. All offsets are relative to the node's
/// position, i.e. the top-left corner of its padded box: the visible node
/// starts at ([kNodePadding], [kNodePadding]).
class NodeLayout {
  NodeLayout(this.node, this.metrics);

  final Node node;
  final NodeMetrics metrics;

  /// Bottom of the thumbnail, where the input knot sits.
  double get _thumbnailBottom =>
      kNodePadding + metrics.stripHeight(node) + metrics.thumbnailHeight;

  /// Top of the rows below the file name (choices, or the button row).
  double get _rowsTop => _thumbnailBottom + metrics.paddedRowHeight;

  /// How many choice rows a branched node shows: every choice, plus an empty
  /// one to type a new choice into (until the maximum is reached).
  static int choiceRowCount(BranchedVideoNode node) =>
      math.min(node.choices.length + 1, kMaxChoices);

  /// The input knot on the left edge, or `null` if the node has no input.
  Offset? get input =>
      hasInputPort(node) ? Offset(kNodePadding, _thumbnailBottom) : null;

  /// The knot of output [port] on the right edge, or `null` if [port] isn't
  /// one of the node's outputs.
  Offset? output(String port) {
    final right = kNodePadding + node.width;
    final rowCenter = metrics.panelPadding + metrics.rowHeight / 2;
    return switch (node) {
      OriginNode() =>
        port == kNextPortKey ? Offset(right, _thumbnailBottom) : null,
      SimpleVideoNode() =>
        port == kNextPortKey ? Offset(right, _rowsTop + rowCenter) : null,
      BranchedVideoNode(:final choices) => switch (
            choices.indexWhere((c) => c.id == port)) {
          -1 => null,
          final i =>
            Offset(right, _rowsTop + rowCenter + i * metrics.choiceStride),
        },
    };
  }

  /// Every knot of the node: its input first, then outputs top to bottom.
  List<({PortRef port, Offset offset})> get knots => [
        if (input case final offset?)
          (port: PortRef.input(node.id), offset: offset),
        for (final port in outputPortsOf(node))
          (port: PortRef(nodeId: node.id, port: port), offset: output(port)!),
      ];
}
