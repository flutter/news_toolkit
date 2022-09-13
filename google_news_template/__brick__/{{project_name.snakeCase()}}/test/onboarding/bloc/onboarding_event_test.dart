// ignore_for_file: prefer_const_constructors

import 'package:{{project_name.snakeCase()}}/onboarding/onboarding.dart';
import 'package:test/test.dart';

void main() {
  group('OnboardingEvent', () {
{{#include_ads}}
    group('EnableAdTrackingRequested', () {
      test('supports value comparisons', () {
        final event1 = EnableAdTrackingRequested();
        final event2 = EnableAdTrackingRequested();
        expect(event1, equals(event2));
      });
    });
{{/include_ads}}

    group('EnableNotificationsRequested', () {
      test('supports value comparisons', () {
        final event1 = EnableNotificationsRequested();
        final event2 = EnableNotificationsRequested();
        expect(event1, equals(event2));
      });
    });
  });
}
