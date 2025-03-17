import 'dart:io';

import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:nutria_fmv_maker/models/video_metadata.dart';
import 'package:nutria_fmv_maker/static_data/data_static_properties.dart';

import '../models/enums_data.dart';
import '../models/file_size.dart';

class VideoMetadataRetriever {
  static List<MetadataEntry<dynamic>> fetchFileMetadata(String filePath) {
    try {
      File file = File(filePath);

      if (!file.existsSync()) {
        return [
          MetadataEntry(
              key: VideoMetadataType.filename, value: 'file does not exist')
        ];
      }

      // Retrieve metadata
      String fileName = file.uri.pathSegments.last;
      String fileLocation = file.absolute.path;
      int fileSize = file.lengthSync(); // File size in bytes
      DateTime lastModified = file.lastModifiedSync();

      // Return results as a map
      return [
        MetadataEntry(key: VideoMetadataType.filename, value: fileName),
        MetadataEntry(key: VideoMetadataType.filePath, value: fileLocation),
        MetadataEntry(
          key: VideoMetadataType.fileSize,
          value: FileSize(
            fileSize >= 1024 * 1024 * 1024
                ? double.parse(
                    (fileSize / (1024 * 1024 * 1024)).toStringAsFixed(2))
                : fileSize >= 1024 * 1024
                    ? double.parse(
                        (fileSize / (1024 * 1024)).toStringAsFixed(2))
                    : double.parse((fileSize / 1024).toStringAsFixed(2)),
            fileSize >= 1024 * 1024 * 1024
                ? FileSizeUnit.gigabytes
                : fileSize >= 1024 * 1024
                    ? FileSizeUnit.megabytes
                    : FileSizeUnit.kilobytes,
          ),
        ),
        MetadataEntry(key: VideoMetadataType.dateCreated, value: lastModified),
      ];
    } catch (e) {
      return [
        MetadataEntry(
            key: VideoMetadataType.filename,
            value: "Error retrieving metadata: $e")
      ];
    }
  }

  /// Fetches video and audio metadata from the given video file.
  static Future<List<MetadataEntry<dynamic>>> fetchVideoMetadata(
      String videoFilePath) async {
    try {
      final MediaInformation? mediaInfo = await FFMpegHelper.instance
          .runProbe(videoFilePath, DataStaticProperties.ffprobePath);

      if (mediaInfo == null) {
        throw Exception("Failed to retrieve media information.");
      }

      List<MetadataEntry<dynamic>> metadataEntries = [];
// dynamic info = mediaInfo.getAllProperties();
      final streams = mediaInfo.getStreams();
      for (var stream in streams) {
        print('stream');
        print(stream.getAllProperties().toString());
      }
      final format = mediaInfo.getFormat();

      if (streams.isEmpty || format == null) {
        throw Exception("Invalid media format.");
      }

      // Extract Video Metadata
      StreamInformation? videoStream;
      try {
        videoStream = streams.firstWhere((stream) =>
            findValueForKey(stream.getAllProperties(), "codec_type") ==
            "video");
      } catch (e) {
        videoStream = null;
      }
      Map<dynamic, dynamic>? videoStreamProperties =
          videoStream?.getAllProperties();

      if (videoStream != null) {
        String rotation =
            findValueForKey(videoStreamProperties, "rotation")?.toString() ??
                "0";
        print('rotation : $rotation');
        String width =
            findValueForKey(videoStreamProperties, "width")?.toString() ??
                "Unknown";
        String height =
            findValueForKey(videoStreamProperties, "height")?.toString() ??
                "Unknown";
        if (rotation == "90" ||
            rotation == "270" ||
            rotation == "-90" ||
            rotation == "-270") {
          String temp = width;
          width = height;
          height = temp;
        }

        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.resolution, value: "$width x $height"));
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.frameRate,
            value: findValueForKey(videoStreamProperties, "avg_frame_rate")
                    ?.toString() ??
                "Unknown"));
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.codecFormat,
            value: findValueForKey(videoStreamProperties, "codec_name") ??
                "Unknown"));
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.bitrate,
            value: int.tryParse(
                    findValueForKey(videoStreamProperties, "bit_rate")
                            ?.toString() ??
                        "0") ??
                0));
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.aspectRatio,
            value: _findAspectRatioFromResolution(width, height) ?? "Unknown"));
        // findValueForKey(
        //     videoStreamProperties, "display_aspect_ratio") ??
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.colorProfile,
            value: findValueForKey(videoStreamProperties, "color_space") ??
                "Unknown"));
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.duration,
            value: double.tryParse(
                    findValueForKey(videoStreamProperties, "duration")
                            ?.toString() ??
                        "0.0") ??
                0.0));
        // For timecode, extract from nested tags.
        var tags = findValueForKey(videoStreamProperties, "tags");
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.timecode,
            value: (tags is Map && tags.containsKey("timecode"))
                ? tags["timecode"]
                : "Unknown"));
      }

      // Extract Audio Metadata
      StreamInformation? audioStream;
      try {
        audioStream = streams.firstWhere((stream) =>
            findValueForKey(stream.getAllProperties(), "codec_type") ==
            "audio");
      } catch (e) {
        audioStream = null;
      }
      Map<dynamic, dynamic>? audioStreamProperties =
          audioStream?.getAllProperties();

      if (audioStream != null) {
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.audioSampleRate,
            value: int.tryParse(
                    findValueForKey(audioStreamProperties, "sample_rate")
                            ?.toString() ??
                        "0") ??
                0));
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.audioBitDepth,
            value: int.tryParse(
                    findValueForKey(audioStreamProperties, "bits_per_sample")
                            ?.toString() ??
                        "0") ??
                0));
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.audioChannels,
            value: int.tryParse(
                    findValueForKey(audioStreamProperties, "channels")
                            ?.toString() ??
                        "0") ??
                0));
        metadataEntries.add(MetadataEntry(
            key: VideoMetadataType.audioCodecFormat,
            value: findValueForKey(audioStreamProperties, "codec_name") ??
                "Unknown"));
      }

      return metadataEntries;
    } catch (e) {
      throw Exception("Error fetching metadata: $e");
    }
  }

  static String? _findAspectRatioFromResolution(String width, String height) {
    int? widthInt = int.tryParse(width);
    int? heightInt = int.tryParse(height);

    if (widthInt == null || heightInt == null) {
      return null;
    }

    int divisor = _gcd(widthInt, heightInt);
    int widthReduced = widthInt ~/ divisor;
    int heightReduced = heightInt ~/ divisor;

    return "$widthReduced:$heightReduced from function";
  }

  static int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  /// Recursively searches for a key in nested JSON structures.
  static dynamic findValueForKey(dynamic data, String targetKey) {
    if (data is Map) {
      if (data.containsKey(targetKey)) {
        return data[targetKey];
      }
      // Search in nested maps
      for (var key in data.keys) {
        final result = findValueForKey(data[key], targetKey);
        if (result != null) {
          return result;
        }
      }
    } else if (data is List) {
      // Iterate over each item in the list
      for (var item in data) {
        final result = findValueForKey(item, targetKey);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }
}
