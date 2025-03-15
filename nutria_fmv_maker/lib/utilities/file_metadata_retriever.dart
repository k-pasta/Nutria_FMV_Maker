import 'dart:io';

import 'package:nutria_fmv_maker/models/enums_data.dart';

import '../models/file_size.dart';

Map<VideoMetadataType, dynamic> getFileMetadata(String filePath) {
  try {
    File file = File(filePath);

    if (!file.existsSync()) {
      return {VideoMetadataType.filename: "File does not exist."};
    }

    // Retrieve metadata
    String fileName = file.uri.pathSegments.last;
    String fileLocation = file.absolute.path;
    int fileSize = file.lengthSync(); // File size in bytes
    DateTime lastModified = file.lastModifiedSync();

    // Return results as a map
    return {
      VideoMetadataType.filename: fileName,
      VideoMetadataType.filePath: fileLocation,
      VideoMetadataType.fileSize: FileSize(
        fileSize >= 1024 * 1024 * 1024
        ? double.parse((fileSize / (1024 * 1024 * 1024)).toStringAsFixed(2))
        : fileSize >= 1024 * 1024
        ? double.parse((fileSize / (1024 * 1024)).toStringAsFixed(2))
        : double.parse((fileSize / 1024).toStringAsFixed(2)),
        fileSize >= 1024 * 1024 * 1024
        ? FileSizeUnit.gigabytes
        : fileSize >= 1024 * 1024
        ? FileSizeUnit.megabytes
        : FileSizeUnit.kilobytes,
      ),
      VideoMetadataType.dateCreated: lastModified
    };

  } catch (e) {
    return {VideoMetadataType.filename: "Error retrieving metadata: $e"};
  }
}
