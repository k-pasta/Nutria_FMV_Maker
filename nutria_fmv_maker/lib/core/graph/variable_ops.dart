// Editing the project's variables.
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';

/// Variable edits. Each returns a new document; unknown ids change nothing.
extension VariableOps on ProjectDocument {
  /// A name like "variable_3" that no variable has yet.
  String freeVariableName(String base) {
    final taken = {for (final v in variables) v.name};
    var n = variables.length + 1;
    while (taken.contains('${base}_$n')) {
      n++;
    }
    return '${base}_$n';
  }

  ProjectDocument addVariable(Variable variable) =>
      copyWith(variables: [...variables, variable]);

  ProjectDocument removeVariable(String id) => copyWith(
    variables: [
      for (final v in variables)
        if (v.id != id) v,
    ],
  );

  /// Replaces variable [id] with [update] of it.
  ProjectDocument updateVariable(
    String id,
    Variable Function(Variable variable) update,
  ) => copyWith(
    variables: [for (final v in variables) v.id == id ? update(v) : v],
  );

  ProjectDocument renameVariable(String id, String name) =>
      updateVariable(id, (v) => v.copyWith(name: name));

  ProjectDocument setVariableType(String id, VariableType type) =>
      updateVariable(id, (v) => v.withType(type));

  /// Names shown as errors: used by more than one variable, or not a valid
  /// name (see [Variable.namePattern]; e.g. empty, or from an older project).
  Set<String> get invalidVariableNames {
    final seen = <String>{};
    final invalid = <String>{};
    for (final v in variables) {
      if (!Variable.isValidName(v.name) || !seen.add(v.name)) {
        invalid.add(v.name);
      }
    }
    return invalid;
  }

  /// Sets the minimum ([isMin]) or maximum of variable [id] from typed
  /// [text] (empty: no limit). Text that isn't a number changes nothing.
  ProjectDocument setVariableLimit(
    String id, {
    required bool isMin,
    required String text,
  }) =>
      updateVariable(id, (v) => v.withLimitText(isMin: isMin, text: text) ?? v);
}
