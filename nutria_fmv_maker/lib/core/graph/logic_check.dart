// What is wrong with a logic node, if anything: shown on the node and
// reported when exporting.
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// Why a logic node can't do its job.
enum LogicProblemType {
  /// No variable picked.
  noVariable,

  /// The picked variable was deleted.
  unknownVariable,

  /// The operation doesn't fit the variable's type (e.g. add to true/false).
  wrongOperation,

  /// A value or expression can't be read; see [LogicProblem.error].
  invalidExpression,

  /// A compare node with nothing to test.
  noConditions,
}

/// A problem, and the expression error behind it, if any.
typedef LogicProblem = ({LogicProblemType type, FmvExpressionError? error});

/// Something worth knowing that isn't an error.
enum LogicWarning {
  /// The result can have decimals but is stored in a whole-number variable,
  /// so it's rounded.
  rounded,
}

/// The type of each variable, by name, for parsing expressions.
Map<String, FmvValueType> variableTypes(ProjectDocument doc) => {
  for (final v in doc.variables)
    v.name: v is BoolVariable ? FmvValueType.boolean : FmvValueType.number,
};

Variable? _variable(ProjectDocument doc, String? id) =>
    doc.variables.where((v) => v.id == id).firstOrNull;

/// With [simple] (the "simple math" preference), a value must be one
/// number, `true`/`false` or one variable name.
bool _isSimple(FmvExpression e) {
  final tokens = e.tokens;
  if (tokens.length == 1) return tokens.single.kind != FmvTokenKind.operator;
  return tokens.length == 2 &&
      tokens.first.text == '-' &&
      tokens.last.kind == FmvTokenKind.number;
}

/// Parses [source] and checks that it gives [type].
LogicProblem? _checkExpression(
  String source,
  FmvValueType type,
  Map<String, FmvValueType> types, {
  required bool simple,
}) {
  final e = FmvExpression.parse(source, types);
  final error = e.error;
  if (error != null) {
    return (type: LogicProblemType.invalidExpression, error: error);
  }
  if (e.type != type || (simple && !_isSimple(e))) {
    return (
      type: LogicProblemType.invalidExpression,
      error: FmvExpressionError(
        FmvExpressionProblem.wrongType,
        0,
        source.length,
      ),
    );
  }
  return null;
}

/// The first thing wrong with logic node [node], or `null`.
LogicProblem? logicProblem(
  ProjectDocument doc,
  Node node, {
  bool simple = false,
}) {
  final types = variableTypes(doc);
  switch (node) {
    case ChangeVariableNode(:final variableId, :final operation, :final value):
      if (variableId == null) {
        return (type: LogicProblemType.noVariable, error: null);
      }
      final variable = _variable(doc, variableId);
      if (variable == null) {
        return (type: LogicProblemType.unknownVariable, error: null);
      }
      final isBool = variable is BoolVariable;
      if (isBool ? !operation.isForBooleans : !operation.isForNumbers) {
        return (type: LogicProblemType.wrongOperation, error: null);
      }
      if (!operation.takesValue) return null;
      return _checkExpression(
        value,
        isBool ? FmvValueType.boolean : FmvValueType.number,
        types,
        simple: simple,
      );
    case CompareNode(:final conditions, :final expression):
      if (expression != null) {
        return _checkExpression(
          expression,
          FmvValueType.boolean,
          types,
          simple: false,
        );
      }
      if (conditions.isEmpty) {
        return (type: LogicProblemType.noConditions, error: null);
      }
      for (final c in conditions) {
        if (c.variableId == null) {
          return (type: LogicProblemType.noVariable, error: null);
        }
        final variable = _variable(doc, c.variableId);
        if (variable == null) {
          return (type: LogicProblemType.unknownVariable, error: null);
        }
        final isBool = variable is BoolVariable;
        if (isBool && !c.comparison.isForBooleans) {
          return (type: LogicProblemType.wrongOperation, error: null);
        }
        final problem = _checkExpression(
          c.value,
          isBool ? FmvValueType.boolean : FmvValueType.number,
          types,
          simple: simple,
        );
        if (problem != null) return problem;
      }
      return null;
    default:
      return null;
  }
}

/// A warning for change node [node], or `null`.
LogicWarning? logicWarning(ProjectDocument doc, Node node) {
  if (node is! ChangeVariableNode || !node.operation.takesValue) return null;
  final variable = _variable(doc, node.variableId);
  if (variable is! IntVariable) return null;
  final divides =
      node.operation == FmvChangeOperation.divide ||
      node.operation == FmvChangeOperation.power;
  final e = FmvExpression.parse(node.value, variableTypes(doc));
  return divides || (e.isValid && e.mayBeFractional)
      ? LogicWarning.rounded
      : null;
}
