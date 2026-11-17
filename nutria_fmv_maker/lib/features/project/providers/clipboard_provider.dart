// Whether there is something to paste, so menus can offer Paste or not.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/fragment.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/services/clipboard_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clipboard_provider.g.dart';

/// Whether the clipboard holds copied nodes. The clipboard can change
/// outside the app at any time and can only be read asynchronously, so this
/// is refreshed at the moments it matters: after copying, when the window
/// regains focus, and when a menu is about to open.
@Riverpod(keepAlive: true)
class ClipboardHasNodes extends _$ClipboardHasNodes {
  @override
  bool build() {
    refresh();
    return false;
  }

  /// Nodes were just copied: no need to read the clipboard back (on Windows
  /// it may still be busy right after writing).
  void copied() => state = true;

  /// Reads the clipboard again.
  Future<void> refresh() async {
    final text = await ref.read(clipboardServiceProvider).read();
    final fragment = NodeFragment.decode(text);
    state = fragment != null && !fragment.isEmpty;
  }
}

/// Whether the selection has anything that can be copied or duplicated
/// (everything but the origin node can).
@riverpod
bool canCopySelection(Ref ref) => ref.watch(selectionProvider
    .select((s) => s.selected.any((id) => id != kOriginNodeId)));
