// ignore_for_file: prefer_const_constructors

import 'package:notifications_client/notifications_client.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

class FakeNotificationsClient extends Fake implements NotificationsClient {}

void main() {
  test('NotificationsClient can be implemented', () {
    expect(FakeNotificationsClient.new, returnsNormally);
  });

  test('exports SubscribeToCategoryFailure', () {
    expect(
      () => SubscribeToCategoryFailure('oops'),
      returnsNormally,
    );
  });

  test('exports UnsubscribeFromCategoryFailure', () {
    expect(
      () => UnsubscribeFromCategoryFailure('oops'),
      returnsNormally,
    );
  });
}
