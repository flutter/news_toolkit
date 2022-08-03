import 'package:flutter_test/flutter_test.dart';
import 'package:notifications_client/notifications_client.dart';

class FakeNotificationsClient extends Fake implements NotificationsClient {}

void main() {
  test('NotificationsClient can be implemented', () {
    expect(FakeNotificationsClient.new, returnsNormally);
  });
}
