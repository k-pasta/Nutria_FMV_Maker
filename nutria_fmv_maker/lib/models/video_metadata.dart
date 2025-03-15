import 'package:nutria_fmv_maker/providers/video_player_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'enums_data.dart';

class MetadataEntry<T> {
  final VideoMetadataType key; // Enum for metadata type
  final T value; // Generic type (int, double, DateTime, etc.)
  final String localizationKey; // Localization key for label
  // final String? suffixKey;  // Optional localization key for suffix (e.g., "MB", "FPS")

  MetadataEntry({
    required this.key,
    required this.value,
    required this.localizationKey,
    // this.suffixKey, // Nullable, only needed for units like MB, FPS
  });

  /// Converts value into a displayable string
  String MetadataTitle(AppLocalizations t) {
    final Map<VideoMetadataType, String> metadataTitles = {
      VideoMetadataType.filename: t.videoMetadataFilename,
      VideoMetadataType.filePath: t.videoMetadataFilePath,
      VideoMetadataType.fileSize: t.videoMetadataFileSize,
      VideoMetadataType.dateCreated: t.videoMetadataDateCreated,
      VideoMetadataType.resolution: t.videoMetadataResolution,
      VideoMetadataType.frameRate: t.videoMetadataFrameRate,
      VideoMetadataType.codecFormat: t.videoMetadataCodecFormat,
      VideoMetadataType.bitrate: t.videoMetadataBitrate,
      VideoMetadataType.aspectRatio: t.videoMetadataAspectRatio,
      VideoMetadataType.colorProfile: t.videoMetadataColorProfile,
      VideoMetadataType.duration: t.videoMetadataDuration,
      VideoMetadataType.timecode: t.videoMetadataTimecode,
      VideoMetadataType.audioSampleRate: t.videoMetadataAudioSampleRate,
      VideoMetadataType.audioBitDepth: t.videoMetadataAudioBitDepth,
      VideoMetadataType.audioChannels: t.videoMetadataAudioChannels,
      VideoMetadataType.audioCodecFormat: t.videoMetadataCodecFormat,
    };

    return metadataTitles[key] ?? 'unknown';
  }

  String MetadataValue(AppLocalizations t) {
    return value.toString();
  }
  // String valueStr;

  // if (value is DateTime) {
  //   valueStr = (value as DateTime).toLocal().toString(); // Format date properly
  // } else if (value is double) {
  //   valueStr = (value as double).toStringAsFixed(2); // Format decimals
  // } else {
  //   valueStr = value.toString();
  // }

  // // Handle suffix translation if needed
  // if (suffixKey != null) {
  //   return "$valueStr ${translate(suffixKey!)}";
  // }

  // return valueStr;
}
