// Editor state of the Screens view: which view is shown, which screen and
// element are selected, the preview scenario, and dragging elements with
// snapping.
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
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

/// The id of the screen being designed (the main menu at first).
@Riverpod(keepAlive: true)
class SelectedScreen extends _$SelectedScreen {
  @override
  String build() => ScreenKind.menu.defaultId;

  void select(String id) {
    if (id == state) return;
    state = id;
    ref.read(selectedScreenElementProvider.notifier).select(null);
  }
}

/// The screen being designed: the selected one, or the main menu if it's
/// gone (deleted, or undone away).
@riverpod
ScreenDesign designedScreen(Ref ref) {
  final id = ref.watch(selectedScreenProvider);
  final doc = ref.watch(projectDocumentProvider);
  return doc.screenById(id) ?? doc.screenOf(ScreenKind.menu);
}

/// The style being edited when no element is selected (picked from the
/// style list), or `null`.
@Riverpod(keepAlive: true)
class SelectedScreenStyle extends _$SelectedScreenStyle {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

/// What the answer screens' preview shows: how many answers, whether they are
/// long, and whether there is a question. Not saved.
typedef ChoiceScenario = ({int answers, bool longText, bool question});

@Riverpod(keepAlive: true)
class ChoiceScenarioNotifier extends _$ChoiceScenarioNotifier {
  @override
  ChoiceScenario build() => (answers: 3, longText: false, question: true);

  /// Between 1 and [kMaxChoices].
  void setAnswers(int answers) => state = (
    answers: answers.clamp(1, kMaxChoices),
    longText: state.longText,
    question: state.question,
  );

  void toggleLongText() => state = (
    answers: state.answers,
    longText: !state.longText,
    question: state.question,
  );

  void toggleQuestion() => state = (
    answers: state.answers,
    longText: state.longText,
    question: !state.question,
  );
}

/// What the designer shows behind answer screens, where the Player shows
/// the video: nothing, the video player's frame (taken when the designer
/// opens), or an imported video looping without sound.
enum DesignerBackdrop { none, frame, video }

/// The backdrop, the video it plays, and the frame taken. Not saved.
typedef DesignerBackdropState = ({
  DesignerBackdrop kind,
  String? videoId,
  Uint8List? frame,
});

@Riverpod(keepAlive: true)
class DesignerBackdropNotifier extends _$DesignerBackdropNotifier {
  @override
  DesignerBackdropState build() =>
      (kind: DesignerBackdrop.none, videoId: null, frame: null);

  void show(DesignerBackdrop kind) =>
      state = (kind: kind, videoId: state.videoId, frame: state.frame);

  /// Plays imported video [id] behind the screen.
  void showVideo(String id) =>
      state = (kind: DesignerBackdrop.video, videoId: id, frame: state.frame);

  /// The video player's frame, taken as the designer opens; shown at once
  /// unless another backdrop was picked.
  void takeFrame(Uint8List? frame) {
    if (frame == null) return;
    state = (
      kind: state.kind == DesignerBackdrop.none
          ? DesignerBackdrop.frame
          : state.kind,
      videoId: state.videoId,
      frame: frame,
    );
  }
}

/// The selected element of the screen being designed, or `null`.
@Riverpod(keepAlive: true)
class SelectedScreenElement extends _$SelectedScreenElement {
  @override
  String? build() {
    ref.watch(documentProvider.select((s) => s.generation));
    return null;
  }

  void select(String? id) {
    state = id;
    if (id != null) ref.read(selectedScreenStyleProvider.notifier).select(null);
  }
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
    final element = ref.read(documentProvider).document.screenElement(id);
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
    final doc = ref.read(documentProvider).document;
    final others = [
      for (final e in doc.screenWithElement(id)!.elements)
        if (e.id != id) e,
    ];
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
