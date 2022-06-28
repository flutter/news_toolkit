// ignore_for_file: prefer_const_constructors

import 'package:google_news_template/onboarding/onboarding.dart';
import 'package:test/test.dart';

void main() {
  group('OnboardingEvent', () {
    group('EnableNotificationsRequested', () {
      test('supports value comparisons', () {
        final event1 = EnableNotificationsRequested();
        final event2 = EnableNotificationsRequested();
        expect(event1, equals(event2));
      });
    });
  });
}
