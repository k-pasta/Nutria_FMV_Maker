import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';

import 'harness.dart';

void main() {
  late Harness h;
  DocumentNotifier doc() => h.container.read(documentProvider.notifier);
  bool dirty() => h.container.read(isDirtyProvider);

  setUp(() async => h = await Harness.create());

  test('an opened project is clean; edits make it dirty; undo cleans it', () {
    expect(dirty(), isFalse);
    doc().apply('Move', (d) => d.moveNodes({'B': Position.zero}));
    expect(dirty(), isTrue);
    expect(h.container.read(historyStatusProvider).undoLabel, 'Move');
    doc().undo();
    expect(dirty(), isFalse);
  });

  test('save writes to the open path and clears the dirty flag', () async {
    doc().apply('Move', (d) => d.moveNodes({'B': Position.zero}));
    expect(await doc().save(), FileOutcome.done);
    expect(h.files.files['story.nfmv']!.node('B').position, Position.zero);
    expect(dirty(), isFalse);
  });

  test(
    'save as: cancelled leaves everything; chosen path is remembered',
    () async {
      expect(await doc().saveAs(), FileOutcome.cancelled);
      expect(h.container.read(projectFileNameProvider), 'story.nfmv');

      h.files.nextSavePath = r'C:\stories\copy.nfmv';
      expect(await doc().saveAs(), FileOutcome.done);
      expect(h.container.read(projectFileNameProvider), 'copy.nfmv');
    },
  );

  test('opening another project resets history and selection', () async {
    h.container.read(selectionProvider.notifier).selectOnly('B');
    doc().apply('Move', (d) => d.moveNodes({'B': Position.zero}));

    h.files.files['other.nfmv'] = h.document.removeNodes(['D']);
    h.files.nextOpenPath = 'other.nfmv';
    expect(await doc().open(), FileOutcome.done);

    expect(h.document.nodes.containsKey('D'), isFalse);
    expect(h.container.read(historyStatusProvider).canUndo, isFalse);
    expect(h.container.read(selectionProvider).selected, isEmpty);
  });

  test('export returns problems along with the outcome', () async {
    h.files.nextSavePath = 'out.fmv';
    final result = await doc().export();
    expect(result.outcome, FileOutcome.done);
    expect(
      result.issues.map((i) => i.type),
      contains(ExportIssueType.unconnectedChoice),
    );
  });
}
