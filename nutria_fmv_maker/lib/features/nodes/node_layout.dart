// Node geometry: row heights and knot positions, shared by the node widgets
// (which size their rows with it) and the noodles (which attach to the knots).
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// Side of a knot (a rotated square) while idle and while hovered or active.
const kKnotSizeSmall = 17.0;
const kKnotSizeLarge = 25.0;

/// The square a knot is hit-tested in: a large knot rotated 45 degrees.
const kKnotHitSize = kKnotSizeLarge * math.sqrt2;

/// A video file name wraps onto at most this many lines, then ends in "…".
const kFileNameMaxLines = 3;

/// The sizes and text style node rows are built from.
class NodeMetrics {
  const NodeMetrics({
    required this.swatchHeight,
    required this.textHeight,
    required this.panelPadding,
    required this.rowHeight,
    this.fileNameStyle = const TextStyle(fontSize: 14, height: 1),
    this.noVideoText = 'No Video',
  });

  /// From the theme, the ambient text style and the current language.
  factory NodeMetrics.of(BuildContext context) {
    final theme = context.appTheme;
    return NodeMetrics(
      swatchHeight: theme.dSwatchHeight,
      textHeight: theme.dTextHeight,
      panelPadding: theme.dPanelPadding,
      rowHeight: theme.dButtonHeight,
      // Fully resolved, so measuring and drawing use the same font.
      fileNameStyle: DefaultTextStyle.of(context).style
          .merge(theme.filenameTextStyle)
          .copyWith(fontStyle: FontStyle.italic),
      noVideoText: AppLocalizations.of(context).nodeNoVideo,
    );
  }

  final double swatchHeight;
  final double textHeight;
  final double panelPadding;

  /// Height of buttons and one-line text fields.
  final double rowHeight;

  /// Video file names on nodes. Widgets draw them with exactly this style.
  final TextStyle fileNameStyle;

  /// Shown instead of a file name on nodes without a video.
  final String noVideoText;

  /// [name] with invisible break opportunities between all characters, so
  /// it wraps anywhere (file names rarely have spaces where needed).
  static String wrappable(String name) => name.split('').join('\u200B');

  /// Lays out a file name exactly as the node draws it.
  TextPainter fileNamePainter(String? fileName) => TextPainter(
    text: TextSpan(
      text: wrappable(fileName ?? noVideoText),
      style: fileNameStyle,
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: kFileNameMaxLines,
    ellipsis: '\u2026',
    textScaler: TextScaler.noScaling,
  );

  static final _heights = <(String?, String, double, TextStyle), double>{};

  /// Height of [fileName] (or [noVideoText]) wrapped in a node [nodeWidth]
  /// wide. Cached: noodles ask for every node on every frame of a drag.
  double fileNameHeight(String? fileName, double nodeWidth) {
    final width = math.max(0.0, nodeWidth - panelPadding * 2);
    final key = (fileName, noVideoText, width, fileNameStyle);
    final cached = _heights[key];
    if (cached != null) return cached;
    if (_heights.length > 2000) _heights.clear();
    final painter = fileNamePainter(fileName)..layout(maxWidth: width);
    final height = painter.height;
    painter.dispose();
    return _heights[key] = height;
  }

  /// The file name row: the wrapped name with [panelPadding] around it.
  double fileNameRowHeight(String? fileName, double nodeWidth) =>
      fileNameHeight(fileName, nodeWidth) + panelPadding * 2;

  /// The colored strip on top; taller when it shows a name. The origin
  /// always does ("Origin Node" when it has none of its own).
  /// Logic nodes always show one too (their title, after what they do).
  double stripHeight(Node node) =>
      node.name == null && node is! OriginNode && !node.isLogicNode
      ? swatchHeight
      : swatchHeight + textHeight;

  /// The video thumbnail (or origin preview). It keeps the 16:9 shape of a
  /// default-width node at every width, so resizing doesn't move knots.
  double get thumbnailHeight => kDefaultNodeWidth * 9 / 16;

  /// Distance between the tops of two consecutive choice rows.
  double get choiceStride => rowHeight + panelPadding;
}

/// Where a node's knots are. All offsets are relative to the node's
/// position, i.e. the top-left corner of its padded box: the visible node
/// starts at ([kNodePadding], [kNodePadding]).
class NodeLayout {
  NodeLayout(this.node, this.metrics, {this.fileName});

  final Node node;
  final NodeMetrics metrics;

  /// The file name of the node's video, or `null` if it has none.
  final String? fileName;

  /// Bottom of the thumbnail, where the input knot sits.
  double get _thumbnailBottom =>
      kNodePadding + metrics.stripHeight(node) + metrics.thumbnailHeight;

  /// Top of the rows below the file name (choices, or the button row).
  double get _rowsTop =>
      _thumbnailBottom + metrics.fileNameRowHeight(fileName, node.width);

  /// How many choice rows a branched node shows: every choice, plus an empty
  /// one to type a new choice into (until the maximum is reached).
  static int choiceRowCount(BranchedVideoNode node) =>
      math.min(node.choices.length + 1, kMaxChoices);

  /// Top of a logic node's first row.
  double get _logicTop =>
      kNodePadding + metrics.stripHeight(node) + metrics.panelPadding;

  /// The middle of row [i] of a logic node.
  double _logicRow(int i) =>
      _logicTop + i * metrics.choiceStride + metrics.rowHeight / 2;

  /// How many rows a compare node has above its True and False rows: one
  /// expression, or two per condition and the add/match row.
  static int compareTestRows(CompareNode node) =>
      node.expression != null ? 1 : node.conditions.length * 2 + 1;

  /// The input knot on the left edge, or `null` if the node has no input.
  /// Logic nodes have it level with their first row.
  Offset? get input => !hasInputPort(node)
      ? null
      : Offset(
          kNodePadding,
          node.isLogicNode ? _logicRow(0) : _thumbnailBottom,
        );

  /// The knot of output [port] on the right edge, or `null` if [port] isn't
  /// one of the node's outputs.
  Offset? output(String port) {
    final right = kNodePadding + node.width;
    final rowCenter = metrics.panelPadding + metrics.rowHeight / 2;
    return switch (node) {
      OriginNode() =>
        port == kNextPortKey ? Offset(right, _thumbnailBottom) : null,
      // Level with the input, so a chain of simple nodes reads as a line.
      SimpleVideoNode() =>
        port == kNextPortKey ? Offset(right, _thumbnailBottom) : null,
      // A question takes the first row; the choices follow it.
      CommentNode() => null,
      // Level with the variable row, like the input.
      ChangeVariableNode() =>
        port == kNextPortKey ? Offset(right, _logicRow(0)) : null,
      CompareNode() => switch (port) {
        kTruePortKey => Offset(
          right,
          _logicRow(compareTestRows(node as CompareNode)),
        ),
        kFalsePortKey => Offset(
          right,
          _logicRow(compareTestRows(node as CompareNode) + 1),
        ),
        _ => null,
      },
      BranchedVideoNode(:final choices, :final question) => switch (choices
          .indexWhere((c) => c.id == port)) {
        -1 => null,
        final i => Offset(
          right,
          _rowsTop +
              rowCenter +
              (i + (question == null ? 0 : 1)) * metrics.choiceStride,
        ),
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
