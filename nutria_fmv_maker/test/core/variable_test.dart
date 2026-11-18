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

  test('new names are free; invalid and repeated names are flagged', () {
    var doc = ProjectDocument.empty()
        .addVariable(const Variable.boolean(id: 'a', name: 'variable_1'));
    expect(doc.freeVariableName('variable'), 'variable_2');
    doc = doc
        .addVariable(const Variable.integer(id: 'b', name: 'variable_1'))
        .addVariable(const Variable.integer(id: 'c', name: ''))
        .addVariable(const Variable.integer(id: 'd', name: 'old name'));
    expect(doc.invalidVariableNames, {'variable_1', '', 'old name'});
    doc = doc
        .removeVariable('b')
        .renameVariable('c', 'other')
        .renameVariable('d', 'όνομα-2');
    expect(doc.invalidVariableNames, isEmpty,
        reason: 'letters of any script are fine');
  });

  test('name rules: a letter first, then letters, digits, - and _', () {
    for (final ok in ['a', 'score_2', 'hp-max', 'Ελένη']) {
      expect(Variable.isValidName(ok), isTrue, reason: ok);
    }
    for (final bad in ['', '2nd', '_x', '-x', 'a b', 'a.b', 'é!']) {
      expect(Variable.isValidName(bad), isFalse, reason: bad);
    }
    expect(Variable.typingPattern.hasMatch(''), isTrue,
        reason: 'an empty field is allowed while typing');
  });

  test('min and max keep the value inside them', () {
    Variable v = const Variable.integer(id: 'a', name: 'hp', initial: 50);
    v = v.withLimitText(isMin: false, text: '10')!;
    expect((v as IntVariable).initial, 10, reason: 'clamped to the new max');
    expect(v.stepped(1), v, reason: 'stepping stays at the max');
    expect((v.withInitialText('-5')! as IntVariable).initial, -5);
    v = v.withLimitText(isMin: true, text: '0')!;
    expect((v.withInitialText('-5')! as IntVariable).initial, 0);
    expect(v.limitText(isMin: true), '0');
    expect(v.withLimitText(isMin: true, text: 'x'), isNull);
    final noMin = v.withLimitText(isMin: true, text: '')!;
    expect(noMin.limits, (null, 10));

    final crossed = v.withLimitText(isMin: true, text: '20')!;
    expect(crossed.hasValidRange, isFalse, reason: 'shown as an error');
    expect(crossed.withType(VariableType.decimal).limits, (null, null),
        reason: 'changing the type drops the limits');

    final d = const Variable.decimal(id: 'b', name: 'x')
        .withLimitText(isMin: true, text: '0,5')!;
    expect((d as DecimalVariable).initial, 0.5);
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
