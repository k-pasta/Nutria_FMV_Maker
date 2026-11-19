import 'dart:convert';

import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:test/test.dart';

const _variables = {
  'coins': FmvVariable(type: FmvVariableType.integer, initial: 5, min: 0, max: 10),
  'speed': FmvVariable(type: FmvVariableType.decimal, initial: 1.5),
  'has_key': FmvVariable(type: FmvVariableType.boolean, initial: false),
};

void main() {
  test('logic nodes and variables are written and read back', () {
    const project = FmvProject(
      nodes: {
        '001': FmvNode(
          type: FmvNodeType.change,
          variable: 'coins',
          operation: FmvChangeOperation.add,
          value: '2',
          target: '002',
        ),
        '002': FmvNode(
          type: FmvNodeType.compare,
          conditions: [
            FmvCondition(
              variable: 'coins',
              comparison: FmvComparison.greaterOrEqual,
              value: '7',
            ),
          ],
          whenTrue: '003',
          whenFalse: '004',
        ),
        '003': FmvNode(type: FmvNodeType.compare, expression: 'has_key'),
        '004': FmvNode(video: 'end.mp4'),
      },
      variables: _variables,
    );
    final json = jsonDecode(project.encode()) as Map<String, Object?>;
    expect((json['Nodes'] as Map)['001'], {
      'type': 'change',
      'variable': 'coins',
      'operation': 'add',
      'value': '2',
      'target': '002',
    });
    expect(((json['Nodes'] as Map)['002'] as Map)['match'], 'all');
    expect(((json['Nodes'] as Map)['004'] as Map).containsKey('type'), isFalse,
        reason: 'video nodes are written as before');
    expect((json['Variables'] as Map)['coins'],
        {'type': 'integer', 'initial': 5, 'min': 0, 'max': 10});

    final read = FmvProject.fromJson(json);
    expect(read.encode(), project.encode());
    expect(read.nodes['002']!.conditions.single.comparison,
        FmvComparison.greaterOrEqual);
    expect(read.variables['speed']!.initial, 1.5);
  });

  test('a file without variables is written without the section', () {
    const project = FmvProject(nodes: {'001': FmvNode(video: 'a.mp4')});
    expect(project.toJson().containsKey('Variables'), isFalse);
  });

  group('playback', () {
    late FmvVariableState state;
    setUp(() => state = FmvVariableState(_variables));

    test('changes round, clamp and use expressions', () {
      expect(state.change('coins', FmvChangeOperation.add, '3'), isNull);
      expect(state.values['coins'], 8);
      state.change('coins', FmvChangeOperation.multiply, 'coins');
      expect(state.values['coins'], 10, reason: 'clamped to the maximum');
      state.change('coins', FmvChangeOperation.divide, '4');
      expect(state.values['coins'], 3, reason: '2.5 rounds away from zero');
      state.change('speed', FmvChangeOperation.set, 'coins / 2');
      expect(state.values['speed'], 1.5);
      state.change('has_key', FmvChangeOperation.toggle, null);
      expect(state.values['has_key'], true);
      state.change('has_key', FmvChangeOperation.and, 'coins > 5');
      expect(state.values['has_key'], false);
      state.change('coins', FmvChangeOperation.subtract, '99');
      expect(state.values['coins'], 0, reason: 'clamped to the minimum');
    });

    test('a division by zero leaves the value unchanged', () {
      final error = state.change('coins', FmvChangeOperation.divide, '0');
      expect(error, isA<FmvEvaluationError>());
      expect(state.values['coins'], 5);
      expect(state.change('gold', FmvChangeOperation.add, '1'), isNotNull);
    });

    test('compare nodes test all, any, or an expression', () {
      const atLeast3 = FmvCondition(
          variable: 'coins', comparison: FmvComparison.greaterOrEqual, value: '3');
      const hasKey = FmvCondition(
          variable: 'has_key', comparison: FmvComparison.equal, value: 'true');
      expect(state.test(conditions: [atLeast3, hasKey]), isFalse);
      expect(state.test(conditions: [atLeast3, hasKey], matchAny: true), isTrue);
      expect(state.test(expression: 'coins = 5 and not has_key'), isTrue);
      expect(state.test(expression: 'coins +'), isFalse,
          reason: 'invalid counts as false');
      expect(state.test(), isFalse);
    });
  });

  test('music: with a video, while choosing and in the menu', () {
    const project = FmvProject(
      info: FmvProjectInfo(menuMusic: FmvLoopMusic(track: 'menu.mp3')),
      nodes: {
        '001': FmvNode(
          video: 'a.mp4',
          music: FmvMusic(
            track: 'theme.mp3',
            end: FmvMusicEnd.laterNodeChanges,
            loop: true,
            fadeOutMs: 2000,
          ),
          pauseMusic: FmvLoopMusic(track: 'tick.mp3', fadeOutMs: 500),
        ),
      },
    );
    final read = FmvProject.decode(project.encode());
    expect(read.encode(), project.encode());
    expect(read.info.menuMusic!.track, 'menu.mp3');
    final node = read.nodes['001']!;
    expect(node.music!.end, FmvMusicEnd.laterNodeChanges);
    expect(node.music!.fadeOutMs, 2000);
    expect(node.pauseMusic!.fadeOutMs, 500);
    expect(const FmvNode(video: 'b.mp4').toJson().containsKey('music'),
        isFalse);
  });

  test('the menu screen is written only when designed', () {
    const project = FmvProject(
      menuScreen: FmvMenuScreen(
        background: 'bg.png',
        elements: [
          FmvScreenElement(
            kind: 'start',
            x: 0.5,
            y: 0.6,
            width: 0.3,
            text: 'Play',
            style: FmvScreenStyle(textColor: 0xFFFF0000, bold: true),
          ),
        ],
      ),
    );
    final json = project.toJson();
    final style = ((((json['Screens'] as Map)['menu'] as Map)['elements']
        as List).single as Map)['style'] as Map;
    expect(style['textColor'], '#FFFF0000');
    final read = FmvProject.decode(project.encode());
    expect(read.encode(), project.encode());
    expect(read.menuScreen.elements.single.style.textColor, 0xFFFF0000);
    expect(const FmvProject().toJson().containsKey('Screens'), isFalse);
  });

  test('copies are separate; restoring keeps only fitting values', () {
    final state = FmvVariableState({
      'coins': const FmvVariable(type: FmvVariableType.integer, initial: 1),
      'key': const FmvVariable(type: FmvVariableType.boolean, initial: false),
    });
    final copy = state.copy()..change('coins', FmvChangeOperation.add, '2');
    expect(copy.values['coins'], 3);
    expect(state.values['coins'], 1);

    state.restore({'coins': 7, 'key': 'yes', 'gone': true});
    expect(state.values, {'coins': 7, 'key': false});
  });
}
