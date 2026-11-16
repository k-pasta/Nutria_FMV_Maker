// Moving the view so a set of nodes is on screen.
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';

/// Frames the nodes [ids] of [doc] (all nodes if null) in [view]: they fit
/// on screen, at no more than 100% zoom. Does nothing if there are none.
void frameNodes(
  CanvasViewController view,
  ProjectDocument doc,
  NodeBounds bounds, {
  Iterable<String>? ids,
  bool animate = false,
}) {
  final rect = bounds.boundsOf(doc, ids: ids);
  if (rect != null) view.frame(rect, animate: animate);
}
