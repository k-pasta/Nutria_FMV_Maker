// Reads and writes project files (.nfmv) and exports (.fmv) on disk.
import 'dart:convert';
import 'dart:io';

import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';
import 'package:nutria_fmv_maker/services/file_dialogs.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_file_service.g.dart';

/// File extension of project saves.
const kProjectExtension = 'nfmv';

/// File extension of exports for the Player.
const kExportExtension = 'fmv';

/// A file couldn't be read or written. [cause] is the underlying error.
class ProjectIoException implements Exception {
  const ProjectIoException(this.path, this.cause);

  final String path;
  final FileSystemException cause;

  @override
  String toString() => 'ProjectIoException($path): ${cause.message}';
}

/// Disk access for projects. Holds no state: the current save path and the
/// dirty flag live in the document provider.
///
/// Errors are thrown as [ProjectIoException] (disk) or [NfmvFormatException]
/// (bad file contents). Cancelled dialogs return `null`, never throw.
class ProjectFileService {
  const ProjectFileService(this._dialogs);

  final FileDialogs _dialogs;

  /// Asks the user for a project file to open.
  Future<String?> pickProject() =>
      _dialogs.pickFile(extensions: const [kProjectExtension]);

  /// Asks the user for video files to import.
  Future<List<String>> pickVideos() => _dialogs.pickVideos();

  /// Reads the project at [path]. Video paths stored relative to the project
  /// are preferred when those files exist, so moved project folders still work.
  Future<ProjectDocument> readProject(String path) async {
    final source = await _guard(path, () => File(path).readAsString());
    return NfmvCodec.decode(
      source,
      projectDir: p.dirname(path),
      fileExists: (file) => File(file).existsSync(),
    );
  }

  /// Saves [document] to [path], overwriting it.
  Future<void> writeProject(String path, ProjectDocument document) => _guard(
        path,
        () => File(path).writeAsString(
          NfmvCodec.encode(document, projectDir: p.dirname(path)),
        ),
      );

  /// Asks where to save [document], saves it, and returns the chosen path.
  Future<String?> saveProjectAs(
    ProjectDocument document, {
    String suggestedName = 'project',
  }) async {
    // The dialog writes the bytes itself, before we know the folder. Write a
    // valid file first, then rewrite it with paths relative to that folder.
    final chosen = await _saveWithDialog(
      '$suggestedName.$kProjectExtension',
      NfmvCodec.encode(document),
      kProjectExtension,
    );
    if (chosen == null) return null;
    await writeProject(chosen, document);
    return chosen;
  }

  /// Asks where to save [export] for the Player, saves it, and returns the
  /// chosen path. Check `export.issues` before calling.
  Future<String?> saveExportAs(
    FmvExport export, {
    String suggestedName = 'project',
  }) =>
      _saveWithDialog(
        '$suggestedName.$kExportExtension',
        const JsonEncoder.withIndent('  ').convert(export.json),
        kExportExtension,
      );

  Future<String?> _saveWithDialog(
    String fileName,
    String contents,
    String extension,
  ) async {
    final chosen = await _dialogs.saveFile(
      fileName: fileName,
      bytes: utf8.encode(contents),
    );
    if (chosen == null) return null;
    // The Windows dialog has no type filter, so the user can drop the
    // extension. Move the file to the name with the extension.
    if (p.extension(chosen).toLowerCase() == '.$extension') return chosen;
    final fixed = '$chosen.$extension';
    await _guard(fixed, () => File(chosen).rename(fixed));
    return fixed;
  }

  Future<T> _guard<T>(String path, Future<T> Function() action) async {
    try {
      return await action();
    } on FileSystemException catch (e) {
      throw ProjectIoException(path, e);
    }
  }
}

/// The app's [ProjectFileService].
@Riverpod(keepAlive: true)
ProjectFileService projectFileService(Ref ref) =>
    ProjectFileService(ref.watch(fileDialogsProvider));
