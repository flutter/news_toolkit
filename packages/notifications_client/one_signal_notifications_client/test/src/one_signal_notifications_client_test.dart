// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:one_signal_notifications_client/one_signal_notifications_client.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MockOneSignal extends Mock implements OneSignal {}

void main() {
  group('OneSignalNotificationsClient', () {
    late OneSignal oneSignal;
    late OneSignalNotificationsClient oneSignalNotificationsClient;

    setUp(() {
      oneSignal = MockOneSignal();
      oneSignalNotificationsClient = OneSignalNotificationsClient(
        oneSignal: oneSignal,
      );
    });
    test('can be instantiated', () {
      expect(
        OneSignalNotificationsClient(oneSignal: oneSignal),
        isNotNull,
      );
    });

    test(
        'calls OneSignal.sendTag '
        'when OneSignalNotificationsClient.subscribeToCategory called',
        () async {
      when(() => oneSignal.sendTag('category', true))
          .thenAnswer((_) async => {});

      await oneSignalNotificationsClient.subscribeToCategory('category');

      verify(() => oneSignal.sendTag('category', true)).called(1);
    });

    test(
        'calls OneSignal.deleteTag '
        'when OneSignalNotificationsClient.unsubscribeFromCategory called',
        () async {
      when(() => oneSignal.deleteTag('category')).thenAnswer((_) async => {});

      await oneSignalNotificationsClient.unsubscribeFromCategory('category');

      verify(() => oneSignal.deleteTag('category')).called(1);
    });
  });
}
