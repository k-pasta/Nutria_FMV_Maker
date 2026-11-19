import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';

import 'fixtures.dart';

void main() {
  test('round-trips a document', () {
    final doc = storyFixture();
    expect(NfmvCodec.decode(NfmvCodec.encode(doc)), doc);
  });

  test('stores relative video paths and prefers them when the file exists', () {
    final doc = storyFixture();
    final encoded = NfmvCodec.encode(doc, projectDir: r'C:\projects\story');
    final videos = jsonDecode(encoded)['media'] as List;
    expect(videos.first['relativePath'], r'..\..\videos\a.mp4');

    // The project folder (with videos) was moved to another machine.
    final moved = NfmvCodec.decode(
      encoded,
      projectDir: r'D:\stories\story',
      fileExists: (path) => path.startsWith(r'D:\'),
    );
    expect(moved.media.first.path, r'D:\videos\a.mp4');

    // Relative file missing: fall back to the absolute path.
    final fallback = NfmvCodec.decode(
      encoded,
      projectDir: r'D:\stories\story',
      fileExists: (_) => false,
    );
    expect(fallback.media.first.path, r'C:\videos\a.mp4');
  }, testOn: 'windows');

  test('rejects files from before format versioning', () {
    expect(
      () => NfmvCodec.decode('{"nodes": [], "videos": []}'),
      throwsA(
        isA<NfmvFormatException>().having(
          (e) => e.reason,
          'reason',
          NfmvReason.unsupportedOldVersion,
        ),
      ),
    );
  });

  test('reads version 1, which called the imported files "videos"', () {
    final json = jsonDecode(NfmvCodec.encode(storyFixture())) as Map;
    json['formatVersion'] = 1;
    json['videos'] = json.remove('media');
    final read = NfmvCodec.decode(jsonEncode(json));
    expect(read.media, storyFixture().media);
    expect(read.formatVersion, kNfmvFormatVersion);
  });

  test('reads version 2, which linked one subtitle file per video', () {
    final json = jsonDecode(NfmvCodec.encode(storyFixture())) as Map;
    json['formatVersion'] = 2;
    final media = json['media'] as List;
    (media.first as Map)['subtitleId'] = 'srt';
    media.add({'id': 'srt', 'path': r'C:.srt'});
    final read = NfmvCodec.decode(jsonEncode(json));
    expect(read.media.first.subtitles, {'': 'srt'});
    expect(read.formatVersion, kNfmvFormatVersion);
  });

  test('rejects files from a newer version', () {
    expect(
      () => NfmvCodec.decode('{"formatVersion": 999}'),
      throwsA(
        isA<NfmvFormatException>().having(
          (e) => e.reason,
          'reason',
          NfmvReason.unsupportedNewVersion,
        ),
      ),
    );
  });

  test('rejects garbage and documents without an origin', () {
    for (final source in ['not json', '[1,2]', '{"formatVersion": 1}']) {
      expect(
        () => NfmvCodec.decode(source),
        throwsA(isA<NfmvFormatException>()),
        reason: source,
      );
    }
  });
}
