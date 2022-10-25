// ignore_for_file: prefer_const_constructors

import 'package:google_news_template/onboarding/onboarding.dart';
import 'package:test/test.dart';

void main() {
  group('OnboardingState', () {
    group('OnboardingInitial', () {
      test('supports value comparisons', () {
        final state1 = OnboardingInitial();
        final state2 = OnboardingInitial();
        expect(state1, equals(state2));
      });
    });

    group('OnboardingInitial', () {
      test('supports value comparisons', () {
        final state1 = OnboardingInitial();
        final state2 = OnboardingInitial();
        expect(state1, equals(state2));
      });
    });

    group('EnablingNotifications', () {
      test('supports value comparisons', () {
        final state1 = EnablingNotifications();
        final state2 = EnablingNotifications();
        expect(state1, equals(state2));
      });
    });

    group('EnablingNotificationsSucceeded', () {
      test('supports value comparisons', () {
        final state1 = EnablingNotificationsSucceeded();
        final state2 = EnablingNotificationsSucceeded();
        expect(state1, equals(state2));
      });
    });

    group('EnablingNotificationsFailed', () {
      test('supports value comparisons', () {
        final state1 = EnablingNotificationsFailed();
        final state2 = EnablingNotificationsFailed();
        expect(state1, equals(state2));
      });
    });
  });
}
