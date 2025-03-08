import 'dart:io';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:file_selector/file_selector.dart';
import 'package:tmp_path/tmp_path.dart';

// Task class to manage thumbnail generation
class Task {
  final String name;
  String srcFile;
  final int width;
  final int height;
  final bool? isSrcUri;

  String? destFile;
  String? destImgSize;
  String? error;

  Task({
    required this.name,
    required this.srcFile,
    required this.width,
    required this.height,
    this.isSrcUri,
  });

  // Run the task (generate video thumbnail)
  Future<void> run() async {
  try {
    srcFile = formatPathForWindows(srcFile);
    print(srcFile);

    // Check if file exists before proceeding
    if (!File(srcFile).existsSync()) {
      throw Exception('The file $srcFile does not exist on your system'); //TODO handle by providing feedback to the user. Maybe not here
    }

    var plugin = FcNativeVideoThumbnail();
    final destFile = tmpPath() + p.extension(srcFile);
    await plugin.getVideoThumbnail(
      srcFile: srcFile,
      destFile: destFile,
      width: width,
      height: height,
      srcFileUri: isSrcUri,
      format: 'jpeg',
    );

    // Check if the thumbnail was created successfully
    if (await File(destFile).exists()) {
      var imageFile = File(destFile);
      var decodedImage =
          await decodeImageFromList(imageFile.readAsBytesSync());
      destImgSize =
          'Decoded size: ${decodedImage.width}x${decodedImage.height}';
      this.destFile = destFile;
    } else {
      error = 'No thumbnail extracted';
    }
  } catch (err) {
    error = err.toString();
    print(error); // Ensure the error is visible
  }
}

  String formatPathForWindows(String path) {
    if (Platform.isWindows) {
      return path.replaceAll('/', '\\');
    }
    return path;
  }
}
