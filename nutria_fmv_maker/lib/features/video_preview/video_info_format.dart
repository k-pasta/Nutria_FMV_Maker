// Text for the preview panel: timecodes and the video's technical details.
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/services/media_info_service.dart';

/// Used for timecodes when the video's frame rate is unknown.
const kFallbackFrameRate = 30.0;

String _two(int n) => n.toString().padLeft(2, '0');

/// `hh:mm:ss:ff`, where ff is the frame within the second.
String formatTimecode(Duration time, {double frameRate = kFallbackFrameRate}) {
  final frames = ((time.inMilliseconds % 1000) * frameRate / 1000).floor();
  return '${_two(time.inHours)}:${_two(time.inMinutes.remainder(60))}:'
      '${_two(time.inSeconds.remainder(60))}:${_two(frames)}';
}

/// File size in the largest unit that keeps the number at least 1.
String formatFileSize(int bytes, AppLocalizations t) {
  const k = 1024;
  if (bytes < k) return '$bytes ${t.videoMetadataNamesBytes}';
  if (bytes < k * k) {
    return '${(bytes / k).toStringAsFixed(1)} ${t.videoMetadataNamesKilobytes}';
  }
  if (bytes < k * k * k) {
    return '${(bytes / (k * k)).toStringAsFixed(1)} '
        '${t.videoMetadataNamesMegabytes}';
  }
  return '${(bytes / (k * k * k)).toStringAsFixed(2)} '
      '${t.videoMetadataNamesGigabytes}';
}

String _date(DateTime d) {
  final local = d.toLocal();
  return '${local.year}-${_two(local.month)}-${_two(local.day)} '
      '${_two(local.hour)}:${_two(local.minute)}';
}

/// Label and value of the details [info] has, in display order. Codecs,
/// bitrates and audio details are left out: they're often missing or
/// unreadable (codec GUIDs on Windows) and rarely matter while editing.
List<(String, String)> videoInfoRows(VideoInfo info, AppLocalizations t) {
  final frameRate = info.frameRate;
  final duration = info.duration;
  return [
    (t.videoMetadataFilename, info.fileName),
    (t.videoMetadataFilePath, info.path),
    if (info.fileSizeBytes case final size?)
      (t.videoMetadataFileSize, formatFileSize(size, t)),
    if (info.created case final created?)
      (t.videoMetadataDateCreated, _date(created)),
    if (duration != null)
      (
        t.videoMetadataDuration,
        formatTimecode(duration, frameRate: frameRate ?? kFallbackFrameRate)
      ),
    if ((info.width, info.height) case (final w?, final h?))
      (t.videoMetadataResolution, '$w × $h'),
    if (frameRate != null)
      (
        t.videoMetadataFrameRate,
        '${frameRate.toStringAsFixed(frameRate % 1 == 0 ? 0 : 2)} '
            '${t.videoMetadataNamesFps}'
      ),
  ];
}
