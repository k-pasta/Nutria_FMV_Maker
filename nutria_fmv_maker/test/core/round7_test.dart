// One of each screen element, questions and music as settings, and the
// upgrade of version 5 projects.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/music.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';

import 'fixtures.dart';

void main() {
  test('a screen has one of each element, but any number of texts', () {
    var doc = ProjectDocument.empty();
    expect(doc.canAddScreenElement('menu', ScreenElementKind.quit), isFalse);
    expect(
      doc.addScreenElement('menu', 'q2', ScreenElementKind.quit),
      same(doc),
    );
    doc = doc
        .addScreenElement('menu', 't1', ScreenElementKind.text)
        .addScreenElement('menu', 't2', ScreenElementKind.text)
        .setScreenElementText('t1', 'Chapter one');
    expect(
      doc.screenOf(ScreenKind.menu).elements.where(
        (e) => e.kind == ScreenElementKind.text,
      ),
      hasLength(2),
    );
    final text = exportFmv(doc).project.menuScreen.elements.firstWhere(
      (e) => e.kind == 'text',
    );
    expect(text.text, 'Chapter one');
  });

  test('the question shows by its setting; music comes from the defaults', () {
    var doc = storyFixture();
    final node = doc.nodes.values.whereType<BranchedVideoNode>().first;
    doc = doc.setQuestion(node.id, 'Which way?');
    String? question() => exportFmv(
      doc,
    ).project.nodes.values.firstWhere((n) => n.isBranched).question;
    expect(question(), isNull, reason: 'Show Question is off by default');
    doc = doc.editDefaults(0, (s) => s.copyWith(showQuestion: true));
    expect(question(), 'Which way?');
  });

  test('version 5: pause choice screens and node music and questions move', () {
    final doc = storyFixture();
    final json = jsonDecode(NfmvCodec.encode(doc)) as Map<String, dynamic>;
    json['formatVersion'] = 5;
    (json['settings'] as Map<String, dynamic>)
      ..['pauseOnEnd'] = true
      ..['endChoiceScreenId'] = 'end';
    json['screens'] = [
      ...json['screens'] as List,
      {'id': 'end', 'kind': 'endChoice', 'elements': <Object>[]},
    ];
    final nodes = json['nodes'] as Map<String, dynamic>;
    final branched =
        nodes.values.firstWhere((n) => (n as Map)['type'] == 'branchedVideo')
            as Map<String, dynamic>;
    branched['question'] = 'Left or right?';
    branched['music'] = {'audioId': 'song', 'loop': true};

    final read = NfmvCodec.decode(jsonEncode(json));
    expect(read.screenById('end')!.kind, ScreenKind.choice);
    expect(read.screenById('end')!.name, 'Pause Choice Screen');
    expect(read.settings.choiceScreenId, 'end', reason: 'it waited');
    final node = read.nodes[branched['id']]! as BranchedVideoNode;
    expect(node.question, 'Left or right?');
    expect(node.overrides.showQuestion, isTrue);
    expect(
      node.overrides.music,
      const MusicCue(audioId: 'song', loop: true),
    );
    expect(read.formatVersion, kNfmvFormatVersion);
  });

  test('a turned pie is kept and exported', () {
    final doc = ProjectDocument.empty();
    final choices = doc
        .screenOf(ScreenKind.choice)
        .elements
        .firstWhere((e) => e.kind == ScreenElementKind.choices);
    final turned = doc.setScreenElementRotation(choices.id, 270);
    expect(turned.screenElement(choices.id)!.rotation, 180, reason: 'at most');
    expect(const VideoSettings().showQuestion, isFalse);
  });
}
