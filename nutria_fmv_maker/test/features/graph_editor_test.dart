import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';

import 'harness.dart';

void main() {
  late Harness h;
  GraphEditor editor() => h.container.read(graphEditorProvider);
  int undoSteps() =>
      h.container.read(documentProvider).timeline.undoStack.length;

  setUp(() async => h = await Harness.create());

  test('new nodes use the preferred node type', () async {
    final branched = editor().addVideoNode(Position.zero);
    expect(h.document.node(branched), isA<BranchedVideoNode>());

    h = await Harness.create(
        preferences:
            const Preferences(defaultNodeType: DefaultNodeType.simpleVideo));
    final simple = editor().addVideoNode(Position.zero, videoId: 'v1');
    expect(h.document.node(simple), isA<SimpleVideoNode>());
  });

  test('deleting the selection skips the origin and clears the selection', () {
    final selection = h.container.read(selectionProvider.notifier)
      ..selectOnly('B')
      ..add('origin');
    editor().removeSelection();
    expect(h.document.nodes.keys, isNot(contains('B')));
    expect(h.document.nodes.keys, contains('origin'));
    expect(h.container.read(selectionProvider).selected, isEmpty);
    selection.clear();
  });

  test('typing with one merge key is one undo step', () {
    for (final text in ['Y', 'Ye', 'Yes!']) {
      editor().setChoiceText('A', 0, text, mergeKey: 'focus-1');
    }
    expect(undoSteps(), 1);
    editor().setChoiceText('A', 0, 'No', mergeKey: 'focus-2');
    expect(undoSteps(), 2);
  });

  test('importing videos is one step and reuses existing files', () {
    final ids = editor().importFiles([r'C:\videos\a.mp4', r'C:\new\x.mp4']);
    expect(ids.first, 'v1');
    expect(h.document.media, hasLength(4));
    expect(undoSteps(), 1);
  });

  test('overrides start from the project value and are merged for playback',
      () {
    editor().enableOverride('B', VideoSettingType.pauseOnEnd);
    expect(h.document.node('B').overridesOrNull?.pauseOnEnd, isFalse);
    editor().editOverrides('B', (o) => o.copyWith(pauseOnEnd: true));
    expect(h.container.read(effectiveSettingsProvider('B')).pauseOnEnd, isTrue);
    editor().disableOverride('B', VideoSettingType.pauseOnEnd);
    expect(h.container.read(effectiveSettingsProvider('B')).pauseOnEnd, isFalse);
  });

  group('preview follows the document', () {
    test('dropping another video on the previewed node switches the video', () {
      h.container.read(nodeGestureProvider.notifier)
        ..tap('B', additive: false)
        ..dropVideo('B', 'v1');
      expect(h.player.opened.last, r'C:\videos\a.mp4');
      expect(h.container.read(videoPreviewProvider)?.mediaId, 'v1');
    });

    test('deleting the previewed node clears the preview', () {
      h.container.read(nodeGestureProvider.notifier).tap('B', additive: false);
      editor().removeSelection();
      expect(h.container.read(videoPreviewProvider), isNull);
      expect(h.player.stops, 1);
    });
  });
}
