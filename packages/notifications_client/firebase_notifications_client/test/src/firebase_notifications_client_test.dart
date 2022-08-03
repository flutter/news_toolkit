// ignore_for_file: prefer_const_constructors
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications_client/firebase_notifications_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  group('FirebaseNotificationsClient', () {
    late FirebaseMessaging firebaseMessaging;
    late FirebaseNotificationsClient firebaseNotificationsClient;

    setUp(() {
      firebaseMessaging = MockFirebaseMessaging();
      firebaseNotificationsClient = FirebaseNotificationsClient(
        firebaseMessaging: firebaseMessaging,
      );
    });
    test('can be instantiated', () {
      expect(
        FirebaseNotificationsClient(firebaseMessaging: firebaseMessaging),
        isNotNull,
      );
    });

    test(
        'calls FirebaseMessaging.subscribeToTopic '
        'when FirebaseNotificationClient.subscribeToCategory called', () async {
      when(() => firebaseMessaging.subscribeToTopic('category'))
          .thenAnswer((_) async {});

      await firebaseNotificationsClient.subscribeToCategory('category');

      verify(() => firebaseMessaging.subscribeToTopic('category')).called(1);
    });

    test(
        'calls FirebaseMessaging.unsubscribeFromTopic '
        'when FirebaseNotificationClient.unsubscribeFromCategory called',
        () async {
      when(() => firebaseMessaging.unsubscribeFromTopic('category'))
          .thenAnswer((_) async {});

      await firebaseNotificationsClient.unsubscribeFromCategory('category');

      verify(() => firebaseMessaging.unsubscribeFromTopic('category'))
          .called(1);
    });
  });
}
