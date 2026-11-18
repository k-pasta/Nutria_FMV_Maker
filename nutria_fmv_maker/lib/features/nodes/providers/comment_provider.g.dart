// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The comment whose text is being edited, or `null`. Comments show their
/// formatted text otherwise, so they can be grabbed anywhere to move them.

@ProviderFor(EditingCommentNotifier)
final editingCommentProvider = EditingCommentNotifierProvider._();

/// The comment whose text is being edited, or `null`. Comments show their
/// formatted text otherwise, so they can be grabbed anywhere to move them.
final class EditingCommentNotifierProvider
    extends $NotifierProvider<EditingCommentNotifier, String?> {
  /// The comment whose text is being edited, or `null`. Comments show their
  /// formatted text otherwise, so they can be grabbed anywhere to move them.
  EditingCommentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editingCommentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editingCommentNotifierHash();

  @$internal
  @override
  EditingCommentNotifier create() => EditingCommentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$editingCommentNotifierHash() =>
    r'8c78690d5f9b88ce421238d225e3dac8c4e3cf8d';

/// The comment whose text is being edited, or `null`. Comments show their
/// formatted text otherwise, so they can be grabbed anywhere to move them.

abstract class _$EditingCommentNotifier extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
