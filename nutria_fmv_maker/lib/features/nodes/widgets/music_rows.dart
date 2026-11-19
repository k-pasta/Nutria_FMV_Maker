// The music settings of video nodes and the main menu music row.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/music.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_search_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// A fade length as the rows show it, e.g. "0.5 s".
String fadeLabel(int ms) =>
    '${(ms / 1000).toStringAsFixed(ms % 1000 == 0 ? 0 : (ms % 100 == 0 ? 1 : 2))} s';

String _musicEndLabel(FmvMusicEnd end, AppLocalizations t) => switch (end) {
  FmvMusicEnd.trackEnds => t.musicEndTrack,
  FmvMusicEnd.choicesAppear => t.musicEndChoices,
  FmvMusicEnd.videoEnds => t.musicEndVideo,
  FmvMusicEnd.laterNodeChanges => t.musicEndLater,
};

/// The next ([direction] 1) or previous of [values] after [current].
T _step<T>(List<T> values, T current, int direction) {
  final i = values.indexOf(current);
  final next = (i == -1 ? 0 : i + direction) % values.length;
  return values[next < 0 ? next + values.length : next];
}

/// The file name of imported file [id] ("?" if it's gone).
String _name(WidgetRef ref, String id) =>
    ref.watch(videoAssetProvider(id).select((a) => a?.fileName)) ?? '?';

/// A music setting row: a searchable list of the imported audio files,
/// with (x) to remove the track and, on right-click, playing it in the
/// preview.
Widget _trackRow(
  BuildContext context,
  WidgetRef ref, {
  required String label,
  required String? audioId,
  required ValueChanged<String> onPicked,
  required VoidCallback onRemoved,
}) {
  final t = AppLocalizations.of(context);
  final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
  final audio = [
    for (final m in ref.watch(mediaAssetsProvider))
      if (m.kind == MediaKind.audio) m,
  ];
  return NutriaSettingRow(
    label: label,
    value: '',
    onReset: audioId == null ? null : onRemoved,
    resetTooltip: t.musicRemove,
    field: NutriaSearchMenu(
      label: audioId == null ? t.musicNone : _name(ref, audioId),
      isPlaceholder: audioId == null,
      options: [for (final m in audio) m.fileName],
      searchHint: t.logicSearchVariables,
      emptyText: t.musicNoAudio,
      onSelected: (i) => onPicked(audio[i].id),
      onOpenChanged: menuOpen,
    ),
    options: audioId == null
        ? null
        : [
            NutriaContextMenuItem(
              icon: Icons.play_arrow,
              label: t.musicPlayPreview,
              onSelected: () =>
                  ref.read(videoPreviewProvider.notifier).showMedia(audioId),
            ),
          ],
    onOptionsOpenChanged: menuOpen,
  );
}

/// The music rows of a video node's settings: its music, picked from the
/// imported audio, and (once picked) when it ends, loop, fade out and
/// pausing; and for branched nodes the pause music.
List<Widget> musicRows(BuildContext context, WidgetRef ref, Node node) {
  final t = AppLocalizations.of(context);
  final theme = context.appTheme;
  final editor = ref.read(graphEditorProvider);
  final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
  String yesNo(bool v) => v ? t.essentialsYes : t.essentialsNo;

  List<NutriaContextMenuItem> options<T>(
    List<T> values,
    T current,
    String Function(T) label,
    ValueChanged<T> onSelected,
  ) => [
    for (final v in values)
      NutriaContextMenuItem(
        icon: v == current ? Icons.check : Icons.circle_outlined,
        label: label(v),
        onSelected: () => onSelected(v),
      ),
  ];

  final cue = node.musicOrNull;
  final rows = <Widget>[
    _trackRow(
      context,
      ref,
      label: t.musicTrack,
      audioId: cue?.audioId,
      onPicked: (audioId) => editor.setMusic(node.id, audioId),
      onRemoved: () => editor.removeMusic(node.id),
    ),
  ];
  if (cue != null) {
    void edit(MusicCue Function(MusicCue c) change) =>
        editor.editMusic(node.id, change);
    if (cue.loop && cue.end == FmvMusicEnd.trackEnds) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.dTextfieldPadding),
          child: NutriaText(
            text: t.musicLoopNeverEnds,
            state: NutriaTextState.inactive,
            maxLines: 3,
          ),
        ),
      );
    }
    rows.addAll([
      NutriaSettingRow(
        label: t.musicEndsWhen,
        value: _musicEndLabel(cue.end, t),
        onPrevious: () =>
            edit((c) => c.copyWith(end: _step(FmvMusicEnd.values, c.end, -1))),
        onNext: () =>
            edit((c) => c.copyWith(end: _step(FmvMusicEnd.values, c.end, 1))),
        options: options(
          FmvMusicEnd.values,
          cue.end,
          (e) => _musicEndLabel(e, t),
          (e) => edit((c) => c.copyWith(end: e)),
        ),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.musicLoop,
        value: yesNo(cue.loop),
        onTap: () => edit((c) => c.copyWith(loop: !c.loop)),
      ),
      NutriaSettingRow(
        label: t.musicFadeOut,
        value: fadeLabel(cue.fadeOutMs),
        onPrevious: () => edit(
          (c) => c.copyWith(fadeOutMs: _step(kMusicFadeSteps, c.fadeOutMs, -1)),
        ),
        onNext: () => edit(
          (c) => c.copyWith(fadeOutMs: _step(kMusicFadeSteps, c.fadeOutMs, 1)),
        ),
        options: options(
          kMusicFadeSteps,
          cue.fadeOutMs,
          fadeLabel,
          (ms) => edit((c) => c.copyWith(fadeOutMs: ms)),
        ),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.musicPauseWithVideo,
        value: yesNo(cue.pauseWithVideo),
        onTap: () => edit((c) => c.copyWith(pauseWithVideo: !c.pauseWithVideo)),
      ),
    ]);
  }
  if (node is BranchedVideoNode) {
    rows.add(
      _trackRow(
        context,
        ref,
        label: t.musicPause,
        audioId: node.pauseMusicId,
        onPicked: (audioId) => editor.setPauseMusic(node.id, audioId),
        onRemoved: () => editor.setPauseMusic(node.id, null),
      ),
    );
  }
  if (node case BranchedVideoNode(pauseMusicId: _?)) {
    rows.addAll([
      NutriaSettingRow(
        label: t.musicPauseFadeOut,
        value: fadeLabel(node.pauseMusicFadeOutMs),
        onPrevious: () => editor.setPauseMusicFadeOut(
          node.id,
          _step(kMusicFadeSteps, node.pauseMusicFadeOutMs, -1),
        ),
        onNext: () => editor.setPauseMusicFadeOut(
          node.id,
          _step(kMusicFadeSteps, node.pauseMusicFadeOutMs, 1),
        ),
        options: options(
          kMusicFadeSteps,
          node.pauseMusicFadeOutMs,
          fadeLabel,
          (ms) => editor.setPauseMusicFadeOut(node.id, ms),
        ),
        onOptionsOpenChanged: menuOpen,
      ),
    ]);
  }
  return rows;
}

/// The main menu music on the origin node, picked from the imported audio.
class MenuMusicRow extends ConsumerWidget {
  const MenuMusicRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);
    final id = ref.watch(
      projectDocumentProvider.select((d) => d.origin.menuMusicId),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.appTheme.dPanelPadding,
        0,
        context.appTheme.dPanelPadding,
        context.appTheme.dPanelPadding,
      ),
      child: _trackRow(
        context,
        ref,
        label: t.musicMenu,
        audioId: id,
        onPicked: editor.setMenuMusic,
        onRemoved: () => editor.setMenuMusic(null),
      ),
    );
  }
}
