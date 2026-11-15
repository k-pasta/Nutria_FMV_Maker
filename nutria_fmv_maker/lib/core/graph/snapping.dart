// Grid and width snapping used while moving and resizing nodes.
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';

/// Default spacing of the snapping grid (matches the canvas dot pattern).
const kDefaultGridSize = 50.0;

/// How close to [kDefaultNodeWidth] a resize must get to snap to it.
const kWidthSnapDistance = 20.0;

/// Snaps [position] to a grid of [gridSize], shifted by [gridOffset] so that a
/// node's visible corner (not its padded bounding box) lands on the grid dots.
Position snapToGrid(
  Position position, {
  double gridSize = kDefaultGridSize,
  double gridOffset = 0,
}) {
  double snap(double v) =>
      ((v - gridOffset) / gridSize).round() * gridSize + gridOffset;
  return Position(snap(position.x), snap(position.y));
}

/// The width a node gets when the user drags its edge to [intendedWidth]:
/// clamped to the allowed range, and pulled to [kDefaultNodeWidth] when close.
double snapNodeWidth(double intendedWidth) {
  if ((intendedWidth - kDefaultNodeWidth).abs() <= kWidthSnapDistance) {
    return kDefaultNodeWidth;
  }
  return intendedWidth.clamp(kMinNodeWidth, kMaxNodeWidth);
}
