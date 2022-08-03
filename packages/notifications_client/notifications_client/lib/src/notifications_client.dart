/// {@template notifications_client}
/// A Generic Notifications Client Interface.
/// {@endtemplate}
abstract class NotificationsClient {
  /// Subscribes user to the notification group based on category.
  Future<void> subscribeToCategory(String category);

  /// Unsubscribes user from the notification group based on category.
  Future<void> unsubscribeFromCategory(String category);
}
