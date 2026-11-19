// The music settings of video nodes and the main menu music row.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/music.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/video_setting_steps.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_number_field.dart';
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
    ref.watch(mediaAssetProvider(id).select((a) => a?.fileName)) ?? '?';

/// A music setting row: a searchable list of the imported audio files,
/// with (x) ([onRemoved]) to remove the track and, on right-click, playing
/// it in the preview. With [onNone], the list starts with "None" (a node
/// overriding its defaults' music with silence); [isAccented] shows an
/// override.
Widget _trackRow(
  BuildContext context,
  WidgetRef ref, {
  required String label,
  required String? audioId,
  required ValueChanged<String> onPicked,
  required VoidCallback? onRemoved,
  VoidCallback? onNone,
  bool isAccented = false,
}) {
  final t = AppLocalizations.of(context);
  final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
  final audio = [
    for (final m in ref.watch(mediaAssetsProvider))
      if (m.kind == MediaKind.audio) m,
  ];
  final none = onNone == null ? 0 : 1;
  return NutriaSettingRow(
    label: label,
    value: '',
    isAccented: isAccented,
    onReset: onRemoved,
    resetTooltip: isAccented ? t.tooltipResetOverride : t.musicRemove,
    field: NutriaSearchMenu(
      label: audioId == null ? t.musicNone : _name(ref, audioId),
      isPlaceholder: audioId == null,
      isAccented: isAccented,
      options: [
        if (onNone != null) t.musicNone,
        for (final m in audio) m.fileName,
      ],
      searchHint: t.logicSearchVariables,
      emptyText: t.musicNoAudio,
      onSelected: (i) => i < none ? onNone!() : onPicked(audio[i - none].id),
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

/// The music rows of a video node's settings: like every setting, its
/// music and (for branched nodes) its pause music come from the defaults
/// unless the node overrides them.
List<Widget> musicRows(BuildContext context, WidgetRef ref, Node node) {
  final editor = ref.read(graphEditorProvider);
  final settings = ref.watch(effectiveSettingsProvider(node.id));
  final overridden = node.overridesOrNull?.activeTypes.toSet() ?? const {};
  void onChanged(
    VideoSettingType type,
    VideoSettings next, {
    Object? mergeKey,
  }) => editor.editOverrides(
    node.id,
    (o) => o.enable(type, next),
    mergeKey: mergeKey,
  );
  void onReset(VideoSettingType type) => editor.disableOverride(node.id, type);
  return [
    ...videoMusicRows(
      context,
      ref,
      settings: settings,
      overridden: overridden,
      onChanged: onChanged,
      onReset: onReset,
      fadeMergeKey: ('fade', node.id),
    ),
    if (node is BranchedVideoNode)
      ...pauseMusicRows(
        context,
        ref,
        settings: settings,
        overridden: overridden,
        onChanged: onChanged,
        onReset: onReset,
        fadeMergeKey: ('pause fade', node.id),
      ),
  ];
}

/// The music with a video: the track and, once there is one, when it ends,
/// loop, fade out and pausing; all one setting ([VideoSettingType.music]),
/// for a node's settings or a color's defaults. As in [pauseMusicRows], on
/// a node [onReset] removes the override and an overridden music is
/// accented; in the defaults the (x) removes the track.
List<Widget> videoMusicRows(
  BuildContext context,
  WidgetRef ref, {
  required VideoSettings settings,
  required void Function(
    VideoSettingType type,
    VideoSettings next, {
    Object? mergeKey,
  })
  onChanged,
  required Object fadeMergeKey,
  Set<VideoSettingType> overridden = const {},
  void Function(VideoSettingType type)? onReset,
}) {
  final t = AppLocalizations.of(context);
  final theme = context.appTheme;
  final editor = ref.read(graphEditorProvider);
  final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
  const type = VideoSettingType.music;
  final accented = overridden.contains(type);
  String yesNo(bool v) => v ? t.essentialsYes : t.essentialsNo;
  void edit(MusicCue Function(MusicCue c) change, {Object? mergeKey}) =>
      onChanged(
        type,
        settings.copyWith(music: change(settings.music)),
        mergeKey: mergeKey,
      );

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

  final cue = settings.musicOrNull;
  final rows = <Widget>[
    _trackRow(
      context,
      ref,
      label: t.musicTrack,
      audioId: cue?.audioId,
      isAccented: accented,
      onPicked: (audioId) => edit((c) => c.copyWith(audioId: audioId)),
      onNone: onReset == null || cue == null
          ? null
          : () => edit((c) => c.copyWith(audioId: '')),
      onRemoved: onReset != null
          ? (accented ? () => onReset(type) : null)
          : (cue == null ? null : () => edit((c) => c.copyWith(audioId: ''))),
    ),
  ];
  if (cue == null) return rows;
  final state = accented ? NutriaTextState.highlighted : null;
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
      isAccented: state != null,
      onPrevious: () =>
          edit((c) => c.copyWith(end: _step(FmvMusicEnd.values, c.end, -1))),
      onNext: () =>
          edit((c) => c.copyWith(end: _step(FmvMusicEnd.values, c.end, 1))),
      options: options<FmvMusicEnd>(
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
      isAccented: state != null,
      onTap: () => edit((c) => c.copyWith(loop: !c.loop)),
    ),
    NutriaSettingRow(
      label: t.musicFadeOut,
      value: '',
      isAccented: state != null,
      field: NutriaNumberField(
        text: (cue.fadeOutMs / 1000).toStringAsFixed(2),
        decimals: true,
        isAccented: state != null,
        onStep: (d) =>
            edit((c) => c.copyWith(fadeOutMs: stepFade(c.fadeOutMs, d))),
        onDragStart: editor.beginValueDrag,
        onDragEnd: editor.endValueDrag,
        onChanged: (text) {
          final ms = fadeFromSeconds(NutriaNumberField.parse(text));
          if (ms != null) {
            edit((c) => c.copyWith(fadeOutMs: ms), mergeKey: fadeMergeKey);
          }
        },
      ),
      options: options<int>(
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
      isAccented: state != null,
      onTap: () => edit((c) => c.copyWith(pauseWithVideo: !c.pauseWithVideo)),
    ),
  ]);
  return rows;
}

/// The pause music rows (the track, and once there is one its fade-out),
/// for a node's settings or a color's defaults. [settings] are the values
/// shown. On a node, [onReset] removes an override: settings in
/// [overridden] are accented and get an (x). In the defaults ([onReset]
/// `null`), the (x) removes the track.
List<Widget> pauseMusicRows(
  BuildContext context,
  WidgetRef ref, {
  required VideoSettings settings,
  required void Function(
    VideoSettingType type,
    VideoSettings next, {
    Object? mergeKey,
  })
  onChanged,
  required Object fadeMergeKey,
  Set<VideoSettingType> overridden = const {},
  void Function(VideoSettingType type)? onReset,
}) {
  final t = AppLocalizations.of(context);
  final editor = ref.read(graphEditorProvider);
  final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
  const track = VideoSettingType.pauseMusic;
  const fade = VideoSettingType.pauseMusicFadeOut;
  final audioId = settings.pauseMusicOrNull;
  void set(VideoSettingType type, VideoSettings next, {Object? mergeKey}) =>
      onChanged(type, next, mergeKey: mergeKey);
  return [
    _trackRow(
      context,
      ref,
      label: t.musicPause,
      audioId: audioId,
      isAccented: overridden.contains(track),
      onPicked: (id) => set(track, settings.copyWith(pauseMusicId: id)),
      onNone: onReset == null || audioId == null
          ? null
          : () => set(track, settings.copyWith(pauseMusicId: '')),
      onRemoved: onReset != null
          ? (overridden.contains(track) ? () => onReset(track) : null)
          : (audioId == null
                ? null
                : () => set(track, settings.copyWith(pauseMusicId: ''))),
    ),
    if (audioId != null)
      NutriaSettingRow(
        label: t.musicPauseFadeOut,
        value: '',
        isAccented: overridden.contains(fade),
        onReset: onReset != null && overridden.contains(fade)
            ? () => onReset(fade)
            : null,
        resetTooltip: t.tooltipResetOverride,
        field: NutriaNumberField(
          text: (settings.pauseMusicFadeOutMs / 1000).toStringAsFixed(2),
          decimals: true,
          isAccented: overridden.contains(fade),
          onStep: (d) => set(fade, settings.step(fade, d)),
          onDragStart: editor.beginValueDrag,
          onDragEnd: editor.endValueDrag,
          onChanged: (text) {
            final ms = fadeFromSeconds(NutriaNumberField.parse(text));
            if (ms == null) return;
            set(
              fade,
              settings.copyWith(pauseMusicFadeOutMs: ms),
              mergeKey: fadeMergeKey,
            );
          },
        ),
        options: [
          for (final option in settings.optionsFor(fade))
            NutriaContextMenuItem(
              icon: settings.sameValue(option, fade)
                  ? Icons.check
                  : Icons.circle_outlined,
              label: fadeLabel(option.pauseMusicFadeOutMs),
              onSelected: () => set(fade, option),
            ),
        ],
        onOptionsOpenChanged: menuOpen,
      ),
  ];
}

/// The pause menu music (when the viewer pauses the story), for the
/// Defaults section.
class PauseMenuMusicRow extends ConsumerWidget {
  const PauseMenuMusicRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editor = ref.read(graphEditorProvider);
    final id = ref.watch(
      projectDocumentProvider.select((d) => d.origin.pauseMenuMusicId),
    );
    return _trackRow(
      context,
      ref,
      label: AppLocalizations.of(context).musicPauseMenu,
      audioId: id,
      onPicked: editor.setPauseMenuMusic,
      onRemoved: id == null ? null : () => editor.setPauseMenuMusic(null),
    );
  }
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
        onRemoved: id == null ? null : () => editor.setMenuMusic(null),
      ),
    );
  }
}
