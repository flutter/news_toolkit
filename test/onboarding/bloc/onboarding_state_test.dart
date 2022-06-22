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

    group('OnboardingEnablingNotifications', () {
      test('supports value comparisons', () {
        final state1 = OnboardingEnablingNotifications();
        final state2 = OnboardingEnablingNotifications();
        expect(state1, equals(state2));
      });
    });

    group('OnboardingEnablingNotificationsFailed', () {
      test('supports value comparisons', () {
        final state1 = OnboardingEnablingNotificationsFailed();
        final state2 = OnboardingEnablingNotificationsFailed();
        expect(state1, equals(state2));
      });
    });
  });
}
