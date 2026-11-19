// The preview of an imported file the player doesn't play: an image, a
// font's sample text, or the dialogue of a subtitle file.
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/features/media_library/providers/media_library_providers.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// The file name, then what [asset] holds, by kind.
class MediaDetails extends ConsumerWidget {
  const MediaDetails({super.key, required this.asset});

  final MediaAsset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    // The video a subtitle file is linked to, if any.
    final linkedTo = asset.kind == MediaKind.subtitle
        ? ref.watch(
            mediaAssetsProvider.select(
              (media) => media
                  .where((m) => m.subtitles.containsValue(asset.id))
                  .firstOrNull
                  ?.fileName,
            ),
          )
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NutriaText(
          text: asset.fileName,
          textStyle: NutriaTextStyle.bold,
          maxLines: 3,
        ),
        if (linkedTo != null)
          NutriaText(
            text: t.previewLinkedTo(linkedTo),
            state: NutriaTextState.inactive,
            maxLines: 2,
          ),
        SizedBox(height: theme.dSectionPadding),
        switch (asset.kind) {
          MediaKind.image => AspectRatio(
            aspectRatio: 16 / 9,
            child: ColoredBox(
              color: theme.cBackground,
              child: Image.file(
                File(asset.path),
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(
                  child: NutriaText(
                    text: t.previewUnreadable,
                    state: NutriaTextState.inactive,
                  ),
                ),
              ),
            ),
          ),
          MediaKind.font => _FontSample(path: asset.path),
          MediaKind.subtitle => _SubtitleCues(path: asset.path),
          MediaKind.video || MediaKind.audio => const SizedBox.shrink(),
        },
      ],
    );
  }
}

/// Sample text in the font at [path], in a few sizes.
class _FontSample extends ConsumerWidget {
  const _FontSample({required this.path});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final family = ref.watch(mediaFontFamilyProvider(path));
    return switch (family) {
      AsyncData(value: final family?) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (text, size) in [
            ('Aa Bb Cc 123', theme.dTextHeight * 2.4),
            (t.previewFontSample, theme.dTextHeight * 1.4),
            (t.previewFontSample, theme.dTextHeight),
          ]) ...[
            Text(
              text,
              style: TextStyle(
                fontFamily: family,
                fontSize: size,
                color: theme.cText,
              ),
            ),
            SizedBox(height: theme.dPanelPadding),
          ],
        ],
      ),
      AsyncLoading() => const SizedBox.shrink(),
      _ => NutriaText(
        text: t.previewUnreadable,
        state: NutriaTextState.inactive,
      ),
    };
  }
}

/// Every cue of the subtitle file at [path]: a small, quiet time range
/// above its text.
class _SubtitleCues extends ConsumerWidget {
  const _SubtitleCues({required this.path});

  final String path;

  static String _time(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final millis = (d.inMilliseconds % 1000).toString().padLeft(3, '0');
    final minutes = d.inHours > 0
        ? '${d.inHours}:${two(d.inMinutes % 60)}'
        : '${d.inMinutes}';
    return '$minutes:${two(d.inSeconds % 60)}.$millis';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final cues = ref.watch(subtitleCuesProvider(path));
    return switch (cues) {
      AsyncData(value: final cues?) when cues.isEmpty => NutriaText(
        text: t.previewNoCues,
        state: NutriaTextState.inactive,
        maxLines: 2,
      ),
      AsyncData(value: final List<FmvSubtitleCue> cues) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final cue in cues) ...[
            NutriaText(
              text: '${_time(cue.start)} – ${_time(cue.end)}',
              state: NutriaTextState.inactive,
              sizeMultiplier: 0.8,
            ),
            NutriaText(text: cue.text, maxLines: 6),
            SizedBox(height: theme.dPanelPadding * 1.5),
          ],
        ],
      ),
      AsyncLoading() => const SizedBox.shrink(),
      _ => NutriaText(
        text: t.previewUnreadable,
        state: NutriaTextState.inactive,
      ),
    };
  }
}
