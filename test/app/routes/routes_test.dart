import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns [OnboardingPage] when onboardingRequired', () {
      expect(
        onGenerateAppViewPages(AppStatus.onboardingRequired, []),
        [
          isA<MaterialPage>().having(
            (p) => p.child,
            'child',
            isA<OnboardingPage>(),
          )
        ],
      );
    });

    test('returns [HomePage] when authenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.authenticated, []),
        [
          isA<MaterialPage>().having(
            (p) => p.child,
            'child',
            isA<HomePage>(),
          )
        ],
      );
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [isA<MaterialPage>().having((p) => p.child, 'child', isA<LoginPage>())],
      );
    });
  });
}
