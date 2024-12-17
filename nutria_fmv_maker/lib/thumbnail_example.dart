import 'dart:io';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:file_selector/file_selector.dart';
import 'package:tmp_path/tmp_path.dart';

// Task class to manage thumbnail generation
class Task {
  final String name;
  final String srcFile;
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
    }
  }
}

// Main widget for displaying the UI
class ThumbnailExample extends StatefulWidget {
  const ThumbnailExample({super.key});

  @override
  State<ThumbnailExample> createState() => _ThumbnailExampleState();
}

class _ThumbnailExampleState extends State<ThumbnailExample> {
  final _tasks = <Task>[]; // List of tasks to track thumbnail generation
  final double _width = 300;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Button to select a video file
          ElevatedButton(
            onPressed: () => _selectVideo(),
            child: const Text('Select video from file'),
          ),
          const SizedBox(height: 8.0),
          // Display task results (thumbnails)
          ..._tasks.map((task) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text('>>> ${task.name}',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
                if (task.error != null) ...[
                  const SizedBox(height: 8.0),
                  Text(task.error!, style: const TextStyle(color: Colors.red)),
                ],
                if (task.destFile != null) ...[
                  const SizedBox(height: 8.0),
                  SelectableText('Dest image: ${task.destFile}'),
                  const SizedBox(height: 8.0),
                  Text(task.destImgSize ?? ''),
                  const SizedBox(height: 8.0),
                  Container(
                    width: _width,
                    height: _width * 9 / 16, //TODO implement mode for vertical
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(),
                    child: ClipRect(
                      child: Image(
                        fit: BoxFit.cover,
                        image: FileImage(
                          File(task.destFile!),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  // Function to select a video file from the system
  Future<void> _selectVideo() async {
    try {
      String? srcPath;

      // Open the file selector to pick a video file

      var src = await openFile();
      if (src == null) return;
      srcPath = src.path;

      // Clear previous tasks
      setState(() {
        _tasks.clear();
      });

      // Add tasks for generating thumbnails with different sizes
      _tasks.add(
        Task(
          name: 'Resize to 300x300',
          srcFile: srcPath!,
          width: 1000,
          height: 1000,
        ),
      );

      // Run the tasks
      await Future.forEach(_tasks, (Task task) async {
        await task.run();
        setState(() {});
      });
    } catch (err) {
      if (!mounted) return;
      await _showErrorAlert(context, err.toString());
    }
  }

  // Show an error alert if something goes wrong
  Future<void> _showErrorAlert(BuildContext context, String msg) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SelectableText('Error'),
        content: SelectableText(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
