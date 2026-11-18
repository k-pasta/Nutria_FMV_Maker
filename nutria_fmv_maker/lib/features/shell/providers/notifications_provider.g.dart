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
    r'6ba98704332facebbc3eea963f0460909e6ee33b';

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

/// Every notification of this session, oldest first (capped at
/// [kNotificationHistoryLength]), for the "all notifications" window.

@ProviderFor(NotificationHistory)
final notificationHistoryProvider = NotificationHistoryProvider._();

/// Every notification of this session, oldest first (capped at
/// [kNotificationHistoryLength]), for the "all notifications" window.
final class NotificationHistoryProvider
    extends $NotifierProvider<NotificationHistory, List<PastNotification>> {
  /// Every notification of this session, oldest first (capped at
  /// [kNotificationHistoryLength]), for the "all notifications" window.
  NotificationHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationHistoryHash();

  @$internal
  @override
  NotificationHistory create() => NotificationHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PastNotification> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PastNotification>>(value),
    );
  }
}

String _$notificationHistoryHash() =>
    r'5c2fcf112bc9c4c695fc1ad30281136e5fe976b1';

/// Every notification of this session, oldest first (capped at
/// [kNotificationHistoryLength]), for the "all notifications" window.

abstract class _$NotificationHistory extends $Notifier<List<PastNotification>> {
  List<PastNotification> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<PastNotification>, List<PastNotification>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PastNotification>, List<PastNotification>>,
              List<PastNotification>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
