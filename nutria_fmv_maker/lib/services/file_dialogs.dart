// Native open/save dialogs, behind an interface so services can be tested without a UI.
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_dialogs.g.dart';

/// The native file dialogs the app uses. Every method returns `null` (or an
/// empty list) when the user cancels.
abstract interface class FileDialogs {
  /// Lets the user pick one file with one of [extensions] (without the dot).
  Future<String?> pickFile({required List<String> extensions});

  /// Lets the user pick any number of files with one of [extensions].
  Future<List<String>> pickFiles({required List<String> extensions});

  /// Lets the user pick a folder.
  Future<String?> pickFolder();

  /// Asks where to save, writes [bytes] there and returns the chosen path.
  Future<String?> saveFile({
    required String fileName,
    required Uint8List bytes,
  });
}

/// [FileDialogs] backed by the `file_picker` plugin.
class FilePickerDialogs implements FileDialogs {
  const FilePickerDialogs();

  @override
  Future<String?> pickFile({required List<String> extensions}) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    return file?.path;
  }

  @override
  Future<List<String>> pickFiles({required List<String> extensions}) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );
    return [
      for (final file in files)
        if (file.path != null) file.path!,
    ];
  }

  @override
  Future<String?> pickFolder() => FilePicker.getDirectoryPath();

  @override
  Future<String?> saveFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final uri = await FilePicker.saveFile(fileName: fileName, bytes: bytes);
    return uri?.toFilePath();
  }
}

/// The app's file dialogs. Override in tests.
@Riverpod(keepAlive: true)
FileDialogs fileDialogs(Ref ref) => const FilePickerDialogs();
