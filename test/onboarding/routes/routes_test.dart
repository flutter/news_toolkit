import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

void main() {
  group('onGenerateOnboardingPages', () {
    test('returns [OnboardingWelcome] when initial', () {
      expect(
        onGenerateOnboardingPages(OnboardingState.initial, []),
        [
          isA<MaterialPage>().having(
            (p) => p.child,
            'child',
            isA<OnboardingWelcome>(),
          )
        ],
      );
    });
  });
}
