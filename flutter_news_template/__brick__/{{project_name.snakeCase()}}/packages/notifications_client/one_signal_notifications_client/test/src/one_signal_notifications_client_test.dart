// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_client/notifications_client.dart';
import 'package:one_signal_notifications_client/one_signal_notifications_client.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MockOneSignal extends Mock implements OneSignal {}

void main() {
  group('OneSignalNotificationsClient', () {
    late OneSignal oneSignal;
    late OneSignalNotificationsClient oneSignalNotificationsClient;

    const category = 'category';

    setUp(() {
      oneSignal = MockOneSignal();
      oneSignalNotificationsClient = OneSignalNotificationsClient(
        oneSignal: oneSignal,
      );
    });

    group('when OneSignalNotificationsClient.subscribeToCategory called', () {
      test('calls OneSignal.sendTag', () async {
        when(
          () => oneSignal.sendTag(category, true),
        ).thenAnswer((_) async => {});

        await oneSignalNotificationsClient.subscribeToCategory(category);

        verify(() => oneSignal.sendTag(category, true)).called(1);
      });

      test(
          'throws SubscribeToCategoryFailure '
          'when OneSignal.deleteTag fails', () async {
        when(
          () => oneSignal.sendTag(category, true),
        ).thenAnswer((_) async => throw Exception());

        expect(
          () => oneSignalNotificationsClient.subscribeToCategory(category),
          throwsA(isA<SubscribeToCategoryFailure>()),
        );
      });
    });

    group('when OneSignalNotificationsClient.unsubscribeFromCategory called',
        () {
      test('calls OneSignal.deleteTag', () async {
        when(() => oneSignal.deleteTag(category)).thenAnswer((_) async => {});

        await oneSignalNotificationsClient.unsubscribeFromCategory(category);

        verify(() => oneSignal.deleteTag(category)).called(1);
      });

      test(
          'throws UnsubscribeFromCategoryFailure '
          'when OneSignal.deleteTag fails', () async {
        when(
          () => oneSignal.deleteTag(category),
        ).thenAnswer((_) async => throw Exception());

        expect(
          () => oneSignalNotificationsClient.unsubscribeFromCategory(category),
          throwsA(isA<UnsubscribeFromCategoryFailure>()),
        );
      });
    });
  });
}
