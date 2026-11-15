// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The message currently shown (`null` for none). Messages posted while one
/// is visible wait in a queue. Messages are already localized by the caller.

@ProviderFor(NotificationsNotifier)
final notificationsProvider = NotificationsNotifierProvider._();

/// The message currently shown (`null` for none). Messages posted while one
/// is visible wait in a queue. Messages are already localized by the caller.
final class NotificationsNotifierProvider
    extends $NotifierProvider<NotificationsNotifier, String?> {
  /// The message currently shown (`null` for none). Messages posted while one
  /// is visible wait in a queue. Messages are already localized by the caller.
  NotificationsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsNotifierHash();

  @$internal
  @override
  NotificationsNotifier create() => NotificationsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$notificationsNotifierHash() =>
    r'ac48147174de7d514258489b7c32fe2b3695f252';

/// The message currently shown (`null` for none). Messages posted while one
/// is visible wait in a queue. Messages are already localized by the caller.

abstract class _$NotificationsNotifier extends $Notifier<String?> {
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
