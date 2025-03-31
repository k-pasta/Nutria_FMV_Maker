  
  import 'dart:io';

import 'package:file_picker/file_picker.dart';

  Future<List<String>?> selectVideos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return null;

      return result.files.map((file) => file.path!).toList();
    } catch (err) {
      print('Error: $err');
      return null;
    }
  }

  Future<String?> selectVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      return result.files.single.path;
    } catch (err) {
      print('Error: $err');
      return null;
    }
  }