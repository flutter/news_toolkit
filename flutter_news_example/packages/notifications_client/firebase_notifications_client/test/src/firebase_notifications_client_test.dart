// ignore_for_file: prefer_const_constructors
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications_client/firebase_notifications_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_client/notifications_client.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  group('FirebaseNotificationsClient', () {
    late FirebaseMessaging firebaseMessaging;
    late FirebaseNotificationsClient firebaseNotificationsClient;

    const category = 'category';

    setUp(() {
      firebaseMessaging = MockFirebaseMessaging();
      firebaseNotificationsClient = FirebaseNotificationsClient(
        firebaseMessaging: firebaseMessaging,
      );
    });

    group('when FirebaseNotificationClient.subscribeToCategory called', () {
      test('calls FirebaseMessaging.subscribeToTopic', () async {
        when(
          () => firebaseMessaging.subscribeToTopic(category),
        ).thenAnswer((_) async {});

        await firebaseNotificationsClient.subscribeToCategory(category);

        verify(() => firebaseMessaging.subscribeToTopic(category)).called(1);
      });

      test(
          'throws SubscribeToCategoryFailure '
          'when FirebaseMessaging.subscribeToTopic fails', () async {
        when(
          () => firebaseMessaging.subscribeToTopic(category),
        ).thenAnswer((_) async => throw Exception());

        expect(
          () => firebaseNotificationsClient.subscribeToCategory(category),
          throwsA(isA<SubscribeToCategoryFailure>()),
        );
      });
    });

    group('when FirebaseNotificationClient.unsubscribeFromCategory called', () {
      test('calls FirebaseMessaging.unsubscribeFromTopic', () async {
        when(
          () => firebaseMessaging.unsubscribeFromTopic(category),
        ).thenAnswer((_) async {});

        await firebaseNotificationsClient.unsubscribeFromCategory(category);

        verify(() => firebaseMessaging.unsubscribeFromTopic(category))
            .called(1);
      });

      test(
          'throws UnsubscribeFromCategoryFailure '
          'when FirebaseMessaging.unsubscribeFromTopic fails', () async {
        when(
          () => firebaseMessaging.unsubscribeFromTopic(category),
        ).thenAnswer((_) async => throw Exception());

        expect(
          () => firebaseNotificationsClient.unsubscribeFromCategory(category),
          throwsA(isA<UnsubscribeFromCategoryFailure>()),
        );
      });
    });
  });
}
