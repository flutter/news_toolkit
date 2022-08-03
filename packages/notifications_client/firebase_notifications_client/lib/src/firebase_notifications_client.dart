import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifications_client/notifications_client.dart';

/// {@template firebase_notifications_client}
/// A Firebase Cloud Messaging notifications client.
/// {@endtemplate}
class FirebaseNotificationsClient implements NotificationsClient {
  /// {@macro firebase_notifications_client}
  const FirebaseNotificationsClient({
    required FirebaseMessaging firebaseMessaging,
  }) : _firebaseMessaging = firebaseMessaging;

  final FirebaseMessaging _firebaseMessaging;

  /// Subscribes to the notification group based on category.
  @override
  Future<void> subscribeToCategory(String category) {
    return _firebaseMessaging.subscribeToTopic(category);
  }

  /// UnSubscribes from the notification group based on category.
  @override
  Future<void> unsubscribeFromCategory(String category) {
    return _firebaseMessaging.unsubscribeFromTopic(category);
  }
}
