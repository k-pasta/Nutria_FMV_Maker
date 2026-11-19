import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart'
    show AspectRatio, CustomPaint, EditableText;
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screens_side_panel.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screens_view.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_color_picker.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

import '../core/fixtures.dart';
import 'app_tester.dart';

List<ScreenElementKind> _kinds(ScreenDesign s) => [
  for (final e in s.elements) e.kind,
];

void main() {
  test('points snap to the middle and to other elements', () {
    const other = ScreenElement(
      id: 'o',
      kind: ScreenElementKind.quit,
      x: 0.3,
      y: 0.8,
    );
    final s = snapScreenPoint(0.495, 0.795, others: [other]);
    expect((s.x, s.y, s.guideX, s.guideY), (0.5, 0.8, 0.5, 0.8));
    final free = snapScreenPoint(0.42, 0.66, others: [other]);
    expect((free.x, free.guideX), (0.42, null));
  });

  test('a new project has every screen, laid out, with what it needs', () {
    final doc = ProjectDocument.empty();
    expect([for (final s in doc.screens) s.kind], [
      ScreenKind.menu,
      ScreenKind.choice,
      ScreenKind.endChoice,
      ScreenKind.pause,
      // The classic menu has Settings and Load, so these come along.
      ScreenKind.settings,
      ScreenKind.saves,
    ]);
    for (final screen in doc.screens) {
      expect(
        _kinds(screen),
        containsAll(kRequiredScreenElements[screen.kind]!),
        reason: '${screen.kind}',
      );
    }
    expect(
      doc.screenOf(ScreenKind.endChoice).elements
          .firstWhere((e) => e.kind == ScreenElementKind.choices)
          .layout,
      FmvChoiceLayout.columns,
      reason: 'answers waiting at the end split the screen',
    );
    expect(ProjectDocument.empty(), doc, reason: 'always the same');
  });

  test('required elements stay; buttons bring their screens', () {
    var doc = const ProjectDocument(
      nodes: {
        kOriginNodeId: Node.origin(id: kOriginNodeId, position: Position.zero),
      },
    ).withRequiredScreens();
    // Without layouts' buttons... the classic menu has Settings and Load.
    final menu = doc.screenOf(ScreenKind.menu);
    final start = menu.elements.firstWhere(
      (e) => e.kind == ScreenElementKind.start,
    );
    expect(doc.removeScreenElement(start.id), same(doc), reason: 'required');
    final title = menu.elements.first;
    expect(doc.canRemoveScreenElement(title.id), isTrue);

    // Remove every Settings button: the screen stays but isn't exported.
    for (final s in doc.screens) {
      for (final e in s.elements) {
        if (e.kind == ScreenElementKind.settings) {
          doc = doc.removeScreenElement(e.id);
        }
      }
    }
    expect(doc.hasSettingsScreen, isFalse);
    expect(exportFmv(doc).project.settingsScreen.isEmpty, isTrue);
    doc = doc.addScreenElement('menu', 'x', ScreenElementKind.settings);
    expect(doc.hasSettingsScreen, isTrue);
    expect(exportFmv(doc).project.settingsScreen.isEmpty, isFalse);
  });

  test('a new saves screen appears with the first Load button', () {
    var doc = ProjectDocument.empty();
    doc = doc.copyWith(
      screens: [
        for (final s in doc.screens)
          if (s.kind != ScreenKind.saves)
            s.copyWith(
              elements: [
                for (final e in s.elements)
                  if (e.kind != ScreenElementKind.load &&
                      e.kind != ScreenElementKind.save)
                    e,
              ],
            ),
      ],
    );
    expect(doc.screensOf(ScreenKind.saves), isEmpty);
    doc = doc.addScreenElement('pause', 'l', ScreenElementKind.save);
    expect(doc.screensOf(ScreenKind.saves), hasLength(1));
  });

  test('layouts, styles and export', () {
    var doc = ProjectDocument.empty().applyScreenPreset(
      'menu',
      ScreenPreset.centeredMenu,
      sequentialIds('e'),
    );
    expect(_kinds(doc.screenOf(ScreenKind.menu)), [
      ScreenElementKind.title,
      ScreenElementKind.start,
      ScreenElementKind.load,
      ScreenElementKind.quit,
    ]);
    expect(
      doc.applyScreenPreset('menu', ScreenPreset.pieChoices, sequentialIds('p')),
      same(doc),
      reason: 'a layout for another kind of screen',
    );
    doc = doc.editScreenStyle(
      'button',
      (s) => s.copyWith(textColor: 0xFFFF0000, blur: 0.01),
    );
    final start = doc.screenOf(ScreenKind.menu).elements[1];
    expect(doc.styleOf(start).textColor, 0xFFFF0000);

    final exported = exportFmv(doc).project;
    expect(exported.menuScreen.elements[1].kind, 'start');
    expect(exported.menuScreen.elements[1].style.textColor, 0xFFFF0000);
    expect(exported.menuScreen.elements[1].style.blur, 0.01);
    expect(exported.menuScreen.elements[1].style.fontFamily, 'inter');
    expect(exported.choiceScreen.elements, isNotEmpty);
    expect(NfmvCodec.decode(NfmvCodec.encode(doc)), doc);
  });

  test('answer screens: picked per node, exported by id, deleted safely', () {
    var doc = storyFixture().withRequiredScreens();
    final ids = sequentialIds('s');
    doc = doc.addScreen(ScreenKind.choice, 'big', 'Big answers', ids);
    final branched = doc.nodes.values.whereType<BranchedVideoNode>().first;
    doc = doc.updateNode(
      branched.id,
      (n) => (n as BranchedVideoNode).copyWith(
        overrides: const VideoSettingsOverride(choiceScreenId: 'big'),
      ),
    );
    var project = exportFmv(doc).project;
    final node = project.nodes.values.firstWhere((n) => n.screen != null);
    expect(node.screen, 'big');
    expect(project.screens.keys, ['big']);
    expect(project.choiceScreenOf(node), same(project.screens['big']));

    // Waiting at the end: the node's pause choice screen.
    doc = doc.editDefaults(0, (s) => s.copyWith(pauseOnEnd: true));
    project = exportFmv(doc).project;
    expect(
      project.nodes.values.where((n) => n.screen == 'endChoice'),
      isNotEmpty,
    );
    expect(project.screens.keys, contains('endChoice'));

    // Deleting the screen sends its nodes back to the first one.
    expect(doc.canRemoveScreen('choice'), isFalse);
    doc = doc.removeScreen('big');
    expect(doc.screenById('big'), isNull);
    expect(
      (doc.nodes[branched.id]! as BranchedVideoNode).overrides.choiceScreenId,
      isNull,
    );
  });

  test('version 4 files: designed screens are kept, the rest laid out', () {
    final json =
        jsonDecode(NfmvCodec.encode(ProjectDocument.empty()))
            as Map<String, dynamic>;
    json
      ..remove('screens')
      ..['formatVersion'] = 4
      ..['menuScreen'] = {
        'elements': [
          {'id': 'q', 'kind': 'quit', 'x': 0.1, 'y': 0.9},
        ],
      }
      ..['choiceScreen'] = {'elements': <Object>[]};
    final doc = NfmvCodec.decode(jsonEncode(json));
    final menu = doc.screenOf(ScreenKind.menu);
    expect(menu.elements.first.id, 'q');
    expect(
      _kinds(menu),
      contains(ScreenElementKind.start),
      reason: 'a menu needs a Start button',
    );
    expect(
      _kinds(doc.screenOf(ScreenKind.choice)),
      containsAll(kRequiredScreenElements[ScreenKind.choice]!),
      reason: 'never designed: the default layout',
    );
  });

  testWidgets('the switch button opens the designer; the right panel picks '
      'the screen; a tray button dragged onto the stage lands there', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    await tester.tap(find.byTooltip('Screen Designer (Ctrl+2)'));
    await tester.pumpAndSettle();
    expect(c.read(editorViewProvider), EditorView.screens);
    expect(find.byTooltip('Story Graph (Ctrl+1)'), findsOneWidget);

    Finder inPanel(String text) => find.descendant(
      of: find.byType(ScreensSidePanel),
      matching: find.text(text),
    );
    await tester.tap(inPanel('Choice Screen'));
    await tester.pumpAndSettle();
    expect(c.read(selectedScreenProvider), 'choice');
    expect(
      find.text('+ Answers'),
      findsNothing,
      reason: 'every choice screen has them',
    );

    await tester.tap(inPanel('Main Menu'));
    await tester.pumpAndSettle();
    final stage = tester.getRect(
      find.descendant(
        of: find.byType(ScreensView),
        matching: find.byType(AspectRatio),
      ),
    );
    final target = stage.topLeft + Offset(stage.width / 4, stage.height / 4);
    final from = tester.getCenter(find.text('+ Credits'));
    final gesture = await tester.startGesture(
      from,
      kind: PointerDeviceKind.mouse,
    );
    for (var i = 1; i <= 10; i++) {
      await gesture.moveTo(Offset.lerp(from, target, i / 10)!);
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    final added = c
        .read(projectDocumentProvider)
        .screenOf(ScreenKind.menu)
        .elements
        .last;
    expect(added.kind, ScreenElementKind.credits);
    // The drop point is the feedback's top left, close to a quarter in.
    expect(added.x, closeTo(0.25, 0.08));
    expect(added.y, closeTo(0.25, 0.08));

    // A layout asks first.
    await tester.tap(find.text('Centered'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Replace'));
    await tester.pumpAndSettle();
    expect(
      c.read(projectDocumentProvider).screenOf(ScreenKind.menu).elements,
      hasLength(4),
    );
  });

  testWidgets('new answer screens are added and renamed in the right panel', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c.read(editorViewProvider.notifier).show(EditorView.screens);
    await tester.pumpAndSettle();
    await tester.tap(find.text('+ New Pause Choice Screen'));
    await tester.pumpAndSettle();
    final screen = c.read(designedScreenProvider);
    expect(screen.kind, ScreenKind.endChoice);
    expect(screen.name, 'Pause Choice Screen 2');

    await tester.tap(find.text('Pause Choice Screen 2'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Pause Choice Screen 2'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).last, 'Crossroads');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(c.read(designedScreenProvider).name, 'Crossroads');
    expect(find.text('Crossroads'), findsWidgets);
  });

  testWidgets('the answers layout is picked from icons', (tester) async {
    final c = await pumpApp(tester);
    c.read(editorViewProvider.notifier).show(EditorView.screens);
    c.read(panelLayoutProvider.notifier).showSection(LeftPanelSection.screen);
    c.read(selectedScreenProvider.notifier).select('choice');
    final choices = c
        .read(designedScreenProvider)
        .elements
        .firstWhere((e) => e.kind == ScreenElementKind.choices);
    c.read(selectedScreenElementProvider.notifier).select(choices.id);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Full screen, as a pie'));
    await tester.pumpAndSettle();
    expect(
      c.read(projectDocumentProvider).screenElement(choices.id)!.layout,
      FmvChoiceLayout.radial,
    );
  });

  test('hex color codes', () {
    expect(colorHex(0xFFFF4E6A), 'FF4E6A');
    expect(parseColorHex('#00ff80'), 0xFF00FF80);
    expect(parseColorHex('12345'), isNull);
  });

  testWidgets('the full color picker changes a style; a drag is one undo '
      'step', (tester) async {
    final c = await pumpApp(tester);
    c.read(editorViewProvider.notifier).show(EditorView.screens);
    c.read(panelLayoutProvider.notifier).showSection(LeftPanelSection.screen);
    c.read(graphEditorProvider).addScreenElement(ScreenElementKind.credits);
    await tester.pumpAndSettle();
    final before = c.read(projectDocumentProvider).styles;

    await tester.tap(find.byTooltip('Pick a Color').first);
    await tester.pumpAndSettle();
    final picker = find.byType(NutriaColorPicker);
    expect(picker, findsOneWidget);
    final square = tester.getRect(
      find.descendant(of: picker, matching: find.byType(CustomPaint)).first,
    );
    final gesture = await tester.startGesture(
      square.center,
      kind: PointerDeviceKind.mouse,
    );
    for (var i = 1; i <= 5; i++) {
      await gesture.moveTo(square.center + Offset(i * 8.0, i * 4.0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    final button = c
        .read(projectDocumentProvider)
        .styles
        .firstWhere((s) => s.id == 'button');
    expect(button.textColor, isNot(0xFFFFFFFF));

    c.read(documentProvider.notifier).undo();
    expect(c.read(projectDocumentProvider).styles, before);
  });

  testWidgets('Ctrl+2 opens the designer; elements are added, dragged with '
      'snapping, and deleted', (tester) async {
    final c = await pumpApp(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.byType(ScreensView), findsOneWidget);
    final count = c
        .read(projectDocumentProvider)
        .screenOf(ScreenKind.menu)
        .elements
        .length;

    await tester.tap(find.text('+ Credits'));
    await tester.pumpAndSettle();
    final credits = find.descendant(
      of: find.byType(ScreensView),
      matching: find.text('Credits'),
    );
    expect(credits, findsOneWidget);

    // Dragging a little off the middle snaps back to it.
    final from = tester.getCenter(credits);
    final gesture = await tester.startGesture(
      from,
      kind: PointerDeviceKind.mouse,
    );
    for (var i = 1; i <= 5; i++) {
      await gesture.moveTo(from + Offset(1.5 * i, -20.0 * i));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    final element = c
        .read(projectDocumentProvider)
        .screenOf(ScreenKind.menu)
        .elements
        .last;
    expect(element.kind, ScreenElementKind.credits);
    expect(element.x, 0.5);

    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pumpAndSettle();
    expect(
      c.read(projectDocumentProvider).screenOf(ScreenKind.menu).elements,
      hasLength(count),
    );
  });
}
