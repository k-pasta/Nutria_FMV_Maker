// Which nodes are selected, and which were raised to the front most recently.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection_provider.freezed.dart';
part 'selection_provider.g.dart';

/// Editor-only state: never saved and never part of undo.
@freezed
abstract class SelectionState with _$SelectionState {
  const factory SelectionState({
    @Default(<String>{}) Set<String> selected,

    /// Nodes brought to the front, most recent last. Drawn above the others.
    @Default(<String>[]) List<String> raised,
  }) = _SelectionState;
}

/// The node selection. Resets when another project is opened.
@Riverpod(keepAlive: true)
class SelectionNotifier extends _$SelectionNotifier {
  @override
  SelectionState build() {
    ref.watch(documentProvider.select((s) => s.generation));
    return const SelectionState();
  }

  /// Selects only [id].
  void selectOnly(String id) =>
      state = state.copyWith(selected: {id});

  /// Adds [id] to the selection.
  void add(String id) =>
      state = state.copyWith(selected: {...state.selected, id});

  /// Removes [id] from the selection.
  void remove(String id) => state =
      state.copyWith(selected: {...state.selected}..remove(id));

  void clear() {
    if (state.selected.isNotEmpty) {
      state = state.copyWith(selected: const {});
    }
  }

  /// Draws [id] above every other node.
  void raise(String id) {
    if (state.raised.isNotEmpty && state.raised.last == id) return;
    state = state.copyWith(
      raised: [...state.raised.where((r) => r != id), id],
    );
  }
}

/// Whether node [id] is selected.
@riverpod
bool isNodeSelected(Ref ref, String id) =>
    ref.watch(selectionProvider.select((s) => s.selected.contains(id)));
