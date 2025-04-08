import 'dart:io';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nutria_fmv_maker/models/file_size.dart';

import 'enums_data.dart';

part 'video_metadata.g.dart';

@JsonSerializable()
class MetadataEntry<T> {
  final VideoMetadataType key; // Enum for metadata type
  @MetadataEntryConverter()
  final T value; // Generic type (int, double, DateTime, etc.)

  MetadataEntry({
    required this.key,
    required this.value,
  });

// JsonSerializable encode and decode methods
  factory MetadataEntry.fromJson(Map<String, dynamic> json) =>
      _$MetadataEntryFromJson<T>(json);

  Map<String, dynamic> toJson() => _$MetadataEntryToJson<T>(this);
}

extension MetadataEntryExtension<T> on MetadataEntry<T> {
  /// Converts title into a displayable string
  String metadataTitle(AppLocalizations t) {
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

  /// Converts value into a displayable string with localization support
  String metadataValue(AppLocalizations t) {
    final Map<VideoMetadataType, String Function(T, AppLocalizations)>
        metadataValues = {
      VideoMetadataType.filename: (v, _) => _filenameValue(v),
      VideoMetadataType.filePath: (v, _) => _filePathValue(v),
      VideoMetadataType.fileSize: _fileSizeValue,
      VideoMetadataType.dateCreated: (v, _) => _dateCreatedValue(v),
      VideoMetadataType.resolution: (v, _) => _resolutionValue(v),
      VideoMetadataType.frameRate: _frameRateValue, // Now takes localization
      VideoMetadataType.codecFormat: (v, _) => _codecFormatValue(v),
      VideoMetadataType.bitrate: (v, _) => _bitrateValue(v),
      VideoMetadataType.aspectRatio: (v, _) => _aspectRatioValue(v),
      VideoMetadataType.colorProfile: (v, _) => _colorProfileValue(v),
      VideoMetadataType.duration: (v, _) => _durationValue(v),
      VideoMetadataType.timecode: (v, _) => _timecodeValue(v),
      VideoMetadataType.audioSampleRate: (v, _) => _audioSampleRateValue(v),
      VideoMetadataType.audioBitDepth: (v, _) => _audioBitDepthValue(v),
      VideoMetadataType.audioChannels: (v, _) => _audioChannelsValue(v),
      VideoMetadataType.audioCodecFormat: (v, _) => _audioCodecFormatValue(v),
    };

    return metadataValues[key]?.call(value, t) ?? value.toString();
  }

  String _filenameValue(T value) => value.toString();
  String _filePathValue(T value) => value.toString();
  String _fileSizeValue(T value, AppLocalizations t) {
    FileSize fileSize = (value as FileSize);
    String suffix = '';

    switch (fileSize.unit) {
      case FileSizeUnit.bytes:
        suffix = t.videoMetadataNamesBytes;
      case FileSizeUnit.kilobytes:
        suffix = t.videoMetadataNamesKilobytes;
      case FileSizeUnit.megabytes:
        suffix = t.videoMetadataNamesMegabytes;
      case FileSizeUnit.gigabytes:
        suffix = t.videoMetadataNamesGigabytes;

        break;
      default:
        '';
    }

    return '${fileSize.size.toStringAsFixed(2)} $suffix';
  }

  String _dateCreatedValue(T value) { 
    
    return (value is DateTime)
      ? DateFormat('dd MMM yyyy, HH:mm', ).format(value.toLocal())
      : value.toString(); }
  String _resolutionValue(T value) => value.toString();

  String _frameRateValue(T value, AppLocalizations t) {

  // Check if the string contains a fraction
  if ((value as String).contains('/')) {
    final parts = value.split('/');
    if (parts.length == 2) {
      final numerator = double.tryParse(parts[0].trim());
      final denominator = double.tryParse(parts[1].trim());
      if (numerator != null && denominator != null && denominator != 0) {
        // Perform the division and round the result to 2 decimals
        return '${(numerator / denominator).toStringAsFixed(2)} ${t.videoMetadataNamesFps}' ;
      }
    }
    // Fallback if parsing fails
    return '0.00';
  } else {
    // Directly parse the numeric value and round to 2 decimals
    final parsedValue = double.tryParse(value.trim());
    if (parsedValue != null) {
      return '${parsedValue.toStringAsFixed(2)} ${t.videoMetadataNamesFps}';
    }
    // Fallback if parsing fails
    return '0.00';
  }
}

  //     return "${value.toStringAsFixed(2)} ${t}"; // Use localized FPS suffix
  //   }
  //   return value.toString();
  // }

  String _codecFormatValue(T value) => value.toString();
  String _bitrateValue(T value) => value.toString();
  String _aspectRatioValue(T value) => value.toString();
  String _colorProfileValue(T value) => value.toString();
  String _durationValue(T value) => value.toString();
  String _timecodeValue(T value) => value.toString();
  String _audioSampleRateValue(T value) => value.toString();
  String _audioBitDepthValue(T value) => value.toString();
  String _audioChannelsValue(T value) => value.toString();
  String _audioCodecFormatValue(T value) => value.toString();
}

// Custom converter for MetadataEntry<T>
class MetadataEntryConverter<T> implements JsonConverter<T, dynamic> {
  const MetadataEntryConverter();

  @override
  T fromJson(dynamic json) {
    if (json is String) return json as T;
    if (json is int) return json as T;
    if (json is double) return json as T;

    // Handle DateTime
    if (json is Map<String, dynamic> && T == DateTime) {
      return DateTime.parse(json['date']) as T;
    }

    // Handle Duration (assumed stored as milliseconds)
    if (json is int && T == Duration) {
      return Duration(milliseconds: json) as T;
    }

    // Handle FileSize
    if (json is Map<String, dynamic> && T == FileSize) {
      final size = json['size'] as double;
      final unit = FileSizeUnit.values.firstWhere(
        (e) => e.toString().split('.').last == json['unit'],
        orElse: () => FileSizeUnit.bytes, // Default unit if not found
      );
      return FileSize(size, unit) as T;
    }

    throw UnsupportedError('Unsupported type: ${T.toString()}');
  }

  @override
  dynamic toJson(T object) {
    if (object is String || object is int || object is double) {
      return object;
    }

    // Convert DateTime to JSON
    if (object is DateTime) {
      return {'date': object.toIso8601String()};
    }

    // Convert Duration to JSON (stored as milliseconds)
    if (object is Duration) {
      return object.inMilliseconds;
    }

    // Convert FileSize to JSON
    if (object is FileSize) {
      return {
        'size': object.size,
        'unit': object.unit.toString().split('.').last,
      };
    }

    throw UnsupportedError('Unsupported type: ${object.runtimeType}');
  }
}
