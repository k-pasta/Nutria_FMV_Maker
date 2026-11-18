import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField;
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';

import 'app_tester.dart';
import 'harness.dart';

void main() {
  Future<void> ctrl(WidgetTester tester, LogicalKeyboardKey key) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(key);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
  }

  testWidgets('Space and Ctrl+arrows control the previewed video',
      (tester) async {
    final player = FakePlayer();
    final c = await pumpApp(tester, player: player);
    bool playing() => player.status.value.playing;

    // Nothing loaded: nothing happens.
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(playing(), isFalse);

    final video = c.read(graphEditorProvider).importFiles(['C:/v/a.mp4']).single;
    c.read(videoPreviewProvider.notifier).showVideo(video);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(playing(), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(playing(), isFalse);

    await ctrl(tester, LogicalKeyboardKey.arrowRight);
    await ctrl(tester, LogicalKeyboardKey.arrowRight);
    await ctrl(tester, LogicalKeyboardKey.arrowLeft);
    expect(player.status.value.position, const Duration(seconds: 5));

    await ctrl(tester, LogicalKeyboardKey.arrowDown);
    await ctrl(tester, LogicalKeyboardKey.arrowDown);
    expect(player.status.value.volume, 80);
    await ctrl(tester, LogicalKeyboardKey.arrowUp);
    await ctrl(tester, LogicalKeyboardKey.arrowUp);
    await ctrl(tester, LogicalKeyboardKey.arrowUp);
    expect(player.status.value.volume, 100, reason: 'capped at 100%');
  });

  testWidgets('typing a space or "f" in a field triggers no shortcut',
      (tester) async {
    final player = FakePlayer();
    final c = await pumpApp(tester, player: player);
    final editor = c.read(graphEditorProvider);
    final video = editor.importFiles(['C:/v/a.mp4']).single;
    editor.addVideoNode(Position.zero,
        videoId: video, type: DefaultNodeType.branchedVideo);
    c.read(videoPreviewProvider.notifier).showVideo(video);
    await tester.pumpAndSettle();

    await tester.tap(find.ancestor(
        of: find.text('Option 1'), matching: find.byType(TextField)).first);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.pumpAndSettle();
    expect(player.status.value.playing, isFalse);
  });

  testWidgets('every icon-only button has a tooltip', (tester) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final video = editor.importFiles(['C:/v/a.mp4']).single;
    // A node without a video shows the "choose a video" button.
    editor.addVideoNode(Position.zero, type: DefaultNodeType.branchedVideo);
    c.read(videoPreviewProvider.notifier).showVideo(video);
    await tester.pumpAndSettle();

    final buttons = tester
        .widgetList<NutriaButton>(find.byType(NutriaButton))
        .where((b) => b.icon != null)
        .toList();
    expect(buttons.length, greaterThan(4));
    for (final button in buttons) {
      expect(button.tooltip, isNotNull, reason: '${button.icon}');
    }
  });
}
