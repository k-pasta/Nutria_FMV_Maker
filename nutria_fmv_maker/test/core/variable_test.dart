import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/graph/variable_ops.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';

import 'fixtures.dart';

void main() {
  test('changing the type keeps the value as well as it can', () {
    const flag = Variable.boolean(id: 'a', name: 'seen', initial: true);
    expect(flag.withType(VariableType.integer),
        const Variable.integer(id: 'a', name: 'seen', initial: 1));
    const score = Variable.decimal(id: 'b', name: 'score', initial: 2.6);
    expect(score.withType(VariableType.integer),
        const Variable.integer(id: 'b', name: 'score', initial: 3));
    expect(score.withType(VariableType.boolean),
        const Variable.boolean(id: 'b', name: 'score', initial: true));
    expect(const Variable.integer(id: 'c', name: 'n')
            .withType(VariableType.boolean),
        const Variable.boolean(id: 'c', name: 'n'));
  });

  test('typed values are read per type; anything else is rejected', () {
    const n = Variable.integer(id: 'a', name: 'n');
    expect(n.withInitialText(' -12 '),
        const Variable.integer(id: 'a', name: 'n', initial: -12));
    expect(n.withInitialText('-'), isNull);
    expect(n.withInitialText('1.5'), isNull);
    const x = Variable.decimal(id: 'b', name: 'x');
    expect(x.withInitialText('0.25'),
        const Variable.decimal(id: 'b', name: 'x', initial: 0.25));
    expect(x.withInitialText('-1,75'),
        const Variable.decimal(id: 'b', name: 'x', initial: -1.75));
    expect(x.initialText, '0.0');
    expect(const Variable.boolean(id: 'c', name: 'f').withInitialText('TRUE'),
        const Variable.boolean(id: 'c', name: 'f', initial: true));
  });

  test('new names are free; empty and repeated names are conflicts', () {
    var doc = ProjectDocument.empty()
        .addVariable(const Variable.boolean(id: 'a', name: 'variable 1'));
    expect(doc.freeVariableName('variable'), 'variable 2');
    doc = doc
        .addVariable(const Variable.integer(id: 'b', name: 'variable 1'))
        .addVariable(const Variable.integer(id: 'c', name: ' '));
    expect(doc.conflictingVariableNames, {'variable 1', ''});
    expect(doc.removeVariable('b').renameVariable('c', 'other')
        .conflictingVariableNames, isEmpty);
  });

  test('variables are saved, and files without them still load', () {
    final doc = storyFixture()
        .addVariable(const Variable.boolean(id: 'a', name: 'seen'))
        .addVariable(const Variable.decimal(id: 'b', name: 'score', initial: 1.5));
    final saved = NfmvCodec.encode(doc);
    expect(NfmvCodec.decode(saved).variables, doc.variables);

    final old = jsonDecode(saved) as Map<String, dynamic>..remove('variables');
    expect(NfmvCodec.decode(jsonEncode(old)).variables, isEmpty);
  });
}
