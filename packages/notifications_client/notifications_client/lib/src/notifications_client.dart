/// {@template notification_exception}
/// Exceptions from the notification client.
/// {@endtemplate}
abstract class NotificationException implements Exception {
  /// {@macro notification_exception}
  const NotificationException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template subscribe_to_category_failure}
/// Thrown during the subscription to category if a failure occurs.
/// {@endtemplate}
class SubscribeToCategoryFailure extends NotificationException {
  /// {@macro subscribe_to_category_failure}
  const SubscribeToCategoryFailure(super.error);
}

/// {@template unsubscribe_from_category_failure}
/// Thrown during the subscription to category if a failure occurs.
/// {@endtemplate}
class UnsubscribeFromCategoryFailure extends NotificationException {
  /// {@macro unsubscribe_from_category_failure}
  const UnsubscribeFromCategoryFailure(super.error);
}

/// {@template notifications_client}
/// A Generic Notifications Client Interface.
/// {@endtemplate}
abstract class NotificationsClient {
  /// Subscribes user to the notification group based on [category].
  Future<void> subscribeToCategory(String category);

  /// Unsubscribes user from the notification group based on [category].
  Future<void> unsubscribeFromCategory(String category);
}
