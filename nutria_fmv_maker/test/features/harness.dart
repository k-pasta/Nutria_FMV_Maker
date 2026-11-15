// Test setup for providers: a ProviderContainer with in-memory fakes for disk,
// dialogs, video playback and preferences.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/services/file_dialogs.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/fixtures.dart';

/// Project files kept in a map instead of on disk.
class MemoryProjectFiles extends ProjectFileService {
  MemoryProjectFiles() : super(const _NoDialogs());

  final Map<String, ProjectDocument> files = {};
  String? nextSavePath;
  String? nextOpenPath;
  FmvExport? lastExport;

  /// What the next "pick videos" dialog returns.
  List<String> nextVideos = const [];

  @override
  Future<String?> pickProject() async => nextOpenPath;

  @override
  Future<List<String>> pickVideos() async => nextVideos;

  @override
  Future<ProjectDocument> readProject(String path) async => files[path]!;

  @override
  Future<void> writeProject(String path, ProjectDocument document) async =>
      files[path] = document;

  @override
  Future<String?> saveProjectAs(ProjectDocument document,
      {String suggestedName = 'project'}) async {
    final path = nextSavePath;
    if (path != null) files[path] = document;
    return path;
  }

  @override
  Future<String?> saveExportAs(FmvExport export,
      {String suggestedName = 'project'}) async {
    lastExport = export;
    return nextSavePath;
  }
}

class _NoDialogs implements FileDialogs {
  const _NoDialogs();
  @override
  Future<String?> pickFile({required List<String> extensions}) async => null;
  @override
  Future<List<String>> pickVideos() async => const [];
  @override
  Future<String?> saveFile(
          {required String fileName, required Uint8List bytes}) async =>
      null;
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
  final ValueNotifier<PlaybackStatus> status =
      ValueNotifier(kStoppedStatus);
  @override
  void dispose() {}
}

/// Everything a provider test needs.
class Harness {
  Harness._(this.container, this.files, this.player);

  final ProviderContainer container;
  final MemoryProjectFiles files;
  final FakePlayer player;

  /// A container whose document is [storyFixture] (loaded, so not dirty).
  static Future<Harness> create({Preferences? preferences}) async {
    SharedPreferences.setMockInitialValues({
      if (preferences != null)
        'preferences': jsonEncode(preferences.toJson()),
    });
    final prefs = await SharedPreferences.getInstance();
    final files = MemoryProjectFiles();
    final player = FakePlayer();
    final container = ProviderContainer.test(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      projectFileServiceProvider.overrideWithValue(files),
      previewPlayerProvider.overrideWithValue(player),
      idGeneratorProvider.overrideWithValue(sequentialIds('new')),
    ]);
    files.files['story.nfmv'] = storyFixture();
    await container.read(documentProvider.notifier).openPath('story.nfmv');
    return Harness._(container, files, player);
  }

  ProjectDocument get document => container.read(documentProvider).document;
}
