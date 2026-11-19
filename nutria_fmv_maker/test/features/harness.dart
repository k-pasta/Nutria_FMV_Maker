// Test setup for providers: a ProviderContainer with in-memory fakes for disk,
// dialogs, video playback and preferences.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/services/file_dialogs.dart';
import 'package:nutria_fmv_maker/services/media_files_service.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:nutria_fmv_maker/services/window_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/fixtures.dart';

/// Project files kept in a map instead of on disk.
class MemoryProjectFiles extends ProjectFileService {
  MemoryProjectFiles() : super(const _NoDialogs());

  final Map<String, ProjectDocument> files = {};
  String? nextSavePath;
  String? nextOpenPath;
  FmvExport? lastExport;

  /// What the next "pick files" dialog returns (for media or videos).
  List<String> nextVideos = const [];

  @override
  Future<String?> pickProject() async => nextOpenPath;

  @override
  Future<List<String>> pickMedia() async => nextVideos;

  @override
  Future<List<String>> pickVideoFiles() async => nextVideos;

  /// What the next "pick a file" and "pick a folder" dialogs return.
  String? nextFile;
  String? nextFolder;

  @override
  Future<String?> pickFileOf(MediaKind kind) async => nextFile;

  @override
  Future<String?> pickFolder() async => nextFolder;

  @override
  Future<ProjectDocument> readProject(String path) async => files[path]!;

  @override
  Future<void> writeProject(String path, ProjectDocument document) async =>
      files[path] = document;

  @override
  Future<String?> saveProjectAs(
    ProjectDocument document, {
    String suggestedName = 'project',
  }) async {
    final path = nextSavePath;
    if (path != null) files[path] = document;
    return path;
  }

  @override
  Future<String?> saveExportAs(
    FmvExport export, {
    String suggestedName = 'project',
  }) async {
    lastExport = export;
    return nextSavePath;
  }
}

class _NoDialogs implements FileDialogs {
  const _NoDialogs();
  @override
  Future<String?> pickFile({required List<String> extensions}) async => null;
  @override
  Future<List<String>> pickFiles({required List<String> extensions}) async =>
      const [];
  @override
  Future<String?> pickFolder() async => null;
  @override
  Future<String?> saveFile({
    required String fileName,
    required Uint8List bytes,
  }) async => null;
}

/// Records what the preview was asked to play.
class FakePlayer implements PreviewPlayer {
  final List<String> opened = [];
  int stops = 0;

  @override
  Future<void> open(String path) async => opened.add(path);
  @override
  Future<void> stop() async => stops++;
  @override
  Future<void> playOrPause() async => status.value = (
    position: status.value.position,
    duration: status.value.duration,
    playing: !status.value.playing,
    volume: status.value.volume,
  );
  @override
  Future<void> seek(Duration position) async => status.value = (
    position: position,
    duration: status.value.duration,
    playing: status.value.playing,
    volume: status.value.volume,
  );
  @override
  Future<void> setVolume(double volume) async => status.value = (
    position: status.value.position,
    duration: status.value.duration,
    playing: status.value.playing,
    volume: volume,
  );
  @override
  final ValueNotifier<PlaybackStatus> status = ValueNotifier(kStoppedStatus);

  /// What [frame] returns.
  Uint8List? currentFrame;
  @override
  Future<Uint8List?> frame() async => currentFrame;
  @override
  void dispose() {}
}

/// Files on a pretend disk: everything exists except [missing]; [folders]
/// lists what each folder holds.
class FakeMediaFiles implements MediaFiles {
  final Set<String> missing = {};
  final Map<String, List<String>> folders = {};

  /// Text contents of files, by path.
  final Map<String, String> contents = {};

  @override
  bool exists(String path) => !missing.contains(path);

  /// File sizes by path; others are 1 MB (missing files have none).
  final Map<String, int> sizes = {};

  @override
  int? sizeOf(String path) =>
      missing.contains(path) ? null : (sizes[path] ?? 1 << 20);

  @override
  List<String> filesIn(String folder) => folders[folder] ?? const [];

  @override
  Future<Uint8List?> readBytes(String path) async => switch (contents[path]) {
    final text? => utf8.encode(text),
    null => null,
  };
}

/// Everything a provider test needs.
/// The app window, recording what it was asked to do.
class FakeWindowControls implements WindowControls {
  FakeWindowControls({this.hasCustomFrame = false});

  @override
  final bool hasCustomFrame;

  @override
  final ValueNotifier<bool> isMaximized = ValueNotifier(false);

  final calls = <String>[];

  @override
  set onCloseRequested(Future<void> Function()? handler) {}

  @override
  void minimize() => calls.add('minimize');

  @override
  void toggleMaximize() {
    calls.add('toggleMaximize');
    isMaximized.value = !isMaximized.value;
  }

  @override
  void startDragging() => calls.add('drag');

  @override
  void close() => calls.add('close');
}

class Harness {
  Harness._(this.container, this.files, this.player);

  final ProviderContainer container;
  final MemoryProjectFiles files;
  final FakePlayer player;

  /// A container whose document is [storyFixture] (loaded, so not dirty).
  static Future<Harness> create({Preferences? preferences}) async {
    SharedPreferences.setMockInitialValues({
      if (preferences != null) 'preferences': jsonEncode(preferences.toJson()),
    });
    final prefs = await SharedPreferences.getInstance();
    final files = MemoryProjectFiles();
    final player = FakePlayer();
    final container = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        projectFileServiceProvider.overrideWithValue(files),
        previewPlayerProvider.overrideWithValue(player),
        idGeneratorProvider.overrideWithValue(sequentialIds('new')),
        mediaFilesProvider.overrideWithValue(FakeMediaFiles()),
      ],
    );
    files.files['story.nfmv'] = storyFixture();
    await container.read(documentProvider.notifier).openPath('story.nfmv');
    return Harness._(container, files, player);
  }

  ProjectDocument get document => container.read(documentProvider).document;
}
