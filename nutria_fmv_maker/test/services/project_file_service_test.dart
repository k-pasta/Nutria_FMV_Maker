import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';
import 'package:nutria_fmv_maker/services/file_dialogs.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:path/path.dart' as p;

import '../core/fixtures.dart';

/// Answers save dialogs with [savePath] and writes the bytes like the real one.
class FakeDialogs implements FileDialogs {
  FakeDialogs(this.savePath);

  final String? savePath;

  @override
  Future<String?> pickFile({required List<String> extensions}) async => null;

  @override
  Future<List<String>> pickFiles({required List<String> extensions}) async =>
      const [];

  @override
  Future<String?> saveFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    if (savePath == null) return null;
    await File(savePath!).writeAsBytes(bytes);
    return savePath;
  }
}

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('nfmv_test'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('save as, then read back the same document', () async {
    final path = p.join(dir.path, 'story.nfmv');
    final service = ProjectFileService(FakeDialogs(path));
    final doc = storyFixture();

    expect(await service.saveProjectAs(doc), path);
    expect(await service.readProject(path), doc);
  });

  test('save as stores video paths relative to the chosen folder', () async {
    final path = p.join(dir.path, 'story.nfmv');
    await ProjectFileService(FakeDialogs(path)).saveProjectAs(storyFixture());
    final videos = jsonDecode(File(path).readAsStringSync())['media'] as List;
    expect(videos.first['relativePath'], isNotNull);
  });

  test('adds the extension when the user leaves it out', () async {
    final service = ProjectFileService(FakeDialogs(p.join(dir.path, 'story')));
    final saved = await service.saveExportAs(exportFmv(storyFixture()));
    expect(saved, p.join(dir.path, 'story.fmv'));
    expect(File(saved!).existsSync(), isTrue);
    expect(File(p.join(dir.path, 'story')).existsSync(), isFalse);
  });

  test('a cancelled dialog returns null', () async {
    final service = ProjectFileService(FakeDialogs(null));
    expect(await service.saveProjectAs(storyFixture()), isNull);
  });

  test('errors are typed', () async {
    final service = ProjectFileService(FakeDialogs(null));
    await expectLater(service.readProject(p.join(dir.path, 'missing.nfmv')),
        throwsA(isA<ProjectIoException>()));

    final bad = File(p.join(dir.path, 'bad.nfmv'))..writeAsStringSync('nope');
    await expectLater(
        service.readProject(bad.path), throwsA(isA<NfmvFormatException>()));
  });
}
