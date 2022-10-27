// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/onboarding/onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('OnboardingPage', () {
    test('has a page', () {
      expect(OnboardingPage.page(), isA<MaterialPage<void>>());
    });

    testWidgets('renders OnboardingView', (tester) async {
      await tester.pumpApp(OnboardingPage());
      expect(find.byType(OnboardingView), findsOneWidget);
    });
  });
}
