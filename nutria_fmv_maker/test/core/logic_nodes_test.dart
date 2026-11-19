import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/logic_check.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

void main() {
  final base = ProjectDocument.empty().copyWith(
    variables: const [
      Variable.integer(id: 'c', name: 'coins', initial: 2, min: 0),
      Variable.boolean(id: 'k', name: 'has_key', initial: false),
    ],
  );

  LogicProblemType? problem(Node node, {bool simple = false}) =>
      logicProblem(base, node, simple: simple)?.type;

  test('change nodes need a variable, a fitting operation and a value', () {
    const node = ChangeVariableNode(id: 'n', position: Position.zero);
    expect(problem(node), LogicProblemType.noVariable);
    expect(
      problem(node.copyWith(variableId: 'gone')),
      LogicProblemType.unknownVariable,
    );
    expect(
      problem(
        node.copyWith(
          variableId: 'k',
          operation: FmvChangeOperation.add,
          value: '1',
        ),
      ),
      LogicProblemType.wrongOperation,
    );
    expect(
      problem(node.copyWith(variableId: 'c', value: 'coins +')),
      LogicProblemType.invalidExpression,
    );
    expect(
      problem(node.copyWith(variableId: 'c', value: 'has_key')),
      LogicProblemType.invalidExpression,
      reason: 'wrong type',
    );
    expect(problem(node.copyWith(variableId: 'c', value: 'coins * 2')), isNull);
    expect(
      problem(node.copyWith(variableId: 'c', value: 'coins * 2'), simple: true),
      LogicProblemType.invalidExpression,
      reason: 'simple math takes one number or variable',
    );
    expect(
      problem(node.copyWith(variableId: 'c', value: '-3'), simple: true),
      isNull,
    );
    expect(
      problem(
        node.copyWith(variableId: 'k', operation: FmvChangeOperation.toggle),
      ),
      isNull,
      reason: 'toggle takes no value',
    );
  });

  test('a fraction stored in a whole number warns about rounding', () {
    const node = ChangeVariableNode(
      id: 'n',
      position: Position.zero,
      variableId: 'c',
      value: 'coins / 2',
    );
    expect(logicWarning(base, node), LogicWarning.rounded);
    expect(logicWarning(base, node.copyWith(value: 'coins + 1')), isNull);
  });

  test('logic nodes and variables are exported by name; saved and loaded', () {
    final doc = base
        .putNode(
          const ChangeVariableNode(
            id: 'n',
            position: Position.zero,
            variableId: 'c',
            operation: FmvChangeOperation.add,
            value: '1',
          ),
        )
        .putNode(
          const CompareNode(
            id: 'm',
            position: Position(300, 0),
            conditions: [
              LogicCondition(
                id: 'x',
                variableId: 'c',
                comparison: FmvComparison.greaterOrEqual,
                value: '3',
              ),
            ],
          ),
        )
        .connect(
          const PortRef(nodeId: kOriginNodeId, port: kNextPortKey),
          PortRef.input('n'),
        )
        .connect(
          const PortRef(nodeId: 'n', port: kNextPortKey),
          PortRef.input('m'),
        )
        .connect(
          const PortRef(nodeId: 'm', port: kTruePortKey),
          PortRef.input('n'),
        );
    final export = exportFmv(doc);
    expect(export.issues, isEmpty);
    final project = export.project;
    expect(project.nodes['001']!.type, FmvNodeType.change);
    expect(project.nodes['001']!.variable, 'coins');
    expect(project.nodes['001']!.target, '002');
    expect(project.nodes['002']!.conditions.single.variable, 'coins');
    expect(project.nodes['002']!.whenTrue, '001');
    expect(project.nodes['002']!.whenFalse, isNull);
    expect(project.variables['coins']!.min, 0);
    expect(project.variables['has_key']!.type, FmvVariableType.boolean);

    // A broken node is reported but still exported.
    final broken = doc.updateChange('n', (n) => n.copyWith(value: 'gold'));
    expect(exportFmv(broken).issues.single.type, ExportIssueType.invalidLogic);

    expect(NfmvCodec.decode(NfmvCodec.encode(doc)), doc);
  });
}
