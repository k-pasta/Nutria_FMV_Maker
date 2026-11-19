// Editor state of the Screens view: which view is shown, the selected
// element, and dragging elements with snapping.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'screens_provider.g.dart';

/// The big area of the window: the story graph or the screen designer.
enum EditorView { graph, screens }

@Riverpod(keepAlive: true)
class EditorViewNotifier extends _$EditorViewNotifier {
  @override
  EditorView build() => EditorView.graph;

  void show(EditorView view) => state = view;
}

/// The selected element of the menu screen, or `null`.
@Riverpod(keepAlive: true)
class SelectedScreenElement extends _$SelectedScreenElement {
  @override
  String? build() {
    ref.watch(documentProvider.select((s) => s.generation));
    return null;
  }

  void select(String? id) => state = id;
}

/// The lines a dragged element snapped to (fractions), for drawing guides.
typedef ScreenGuides = ({double? x, double? y});

/// Dragging an element on the stage: one undo step per drag, snapping to
/// the middle and to other elements.
@Riverpod(keepAlive: true)
class ScreenDragNotifier extends _$ScreenDragNotifier {
  @override
  ScreenGuides? build() => null;

  String? _id;
  double _x = 0;
  double _y = 0;

  DocumentNotifier get _document => ref.read(documentProvider.notifier);

  void begin(String id) {
    final element = ref
        .read(documentProvider)
        .document
        .menuScreen
        .elements
        .where((e) => e.id == id)
        .firstOrNull;
    if (element == null) return;
    ref.read(selectedScreenElementProvider.notifier).select(id);
    _id = id;
    _x = element.x;
    _y = element.y;
    _document.beginTransaction('Move element');
    state = (x: null, y: null);
  }

  /// Moves by ([dx], [dy]), as fractions of the screen.
  void update(double dx, double dy) {
    final id = _id;
    if (id == null) return;
    _x += dx;
    _y += dy;
    final others = ref
        .read(documentProvider)
        .document
        .menuScreen
        .elements
        .where((e) => e.id != id);
    final snapped = snapScreenPoint(_x, _y, others: others);
    _document.apply(
      'Move element',
      (d) => d.moveScreenElement(id, snapped.x, snapped.y),
    );
    state = (x: snapped.guideX, y: snapped.guideY);
  }

  void end() {
    if (_id == null) return;
    _id = null;
    state = null;
    _document.commit();
  }
}
