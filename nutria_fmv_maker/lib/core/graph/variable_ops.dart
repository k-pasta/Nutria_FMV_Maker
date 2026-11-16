// Editing the project's variables.
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';

/// Variable edits. Each returns a new document; unknown ids change nothing.
extension VariableOps on ProjectDocument {
  /// A name like "variable 3" that no variable has yet.
  String freeVariableName(String base) {
    final taken = {for (final v in variables) v.name};
    var n = variables.length + 1;
    while (taken.contains('$base $n')) {
      n++;
    }
    return '$base $n';
  }

  ProjectDocument addVariable(Variable variable) =>
      copyWith(variables: [...variables, variable]);

  ProjectDocument removeVariable(String id) =>
      copyWith(variables: [for (final v in variables) if (v.id != id) v]);

  /// Replaces variable [id] with [update] of it.
  ProjectDocument updateVariable(
          String id, Variable Function(Variable variable) update) =>
      copyWith(variables: [
        for (final v in variables) v.id == id ? update(v) : v,
      ]);

  ProjectDocument renameVariable(String id, String name) =>
      updateVariable(id, (v) => v.copyWith(name: name));

  ProjectDocument setVariableType(String id, VariableType type) =>
      updateVariable(id, (v) => v.withType(type));

  /// Names used by more than one variable, or empty: shown as errors.
  Set<String> get conflictingVariableNames {
    final seen = <String>{};
    final conflicts = <String>{};
    for (final v in variables) {
      final name = v.name.trim();
      if (name.isEmpty || !seen.add(name)) conflicts.add(name);
    }
    return conflicts;
  }
}
