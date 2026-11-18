// Which comment is being edited (its text field shown instead of its text).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_provider.g.dart';

/// The comment whose text is being edited, or `null`. Comments show their
/// formatted text otherwise, so they can be grabbed anywhere to move them.
@Riverpod(keepAlive: true)
class EditingCommentNotifier extends _$EditingCommentNotifier {
  @override
  String? build() {
    // A new or opened project ends any editing.
    ref.watch(documentProvider.select((s) => s.generation));
    return null;
  }

  /// Starts editing comment [id] (ending any other).
  void start(String id) => state = id;

  /// Ends editing comment [id], unless another one is being edited by now.
  void stop(String id) {
    if (state == id) state = null;
  }
}
