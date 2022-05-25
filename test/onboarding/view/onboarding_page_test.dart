// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('OnboardingPage', () {
    test('has a page', () {
      expect(OnboardingPage.page(), isA<MaterialPage>());
    });

    testWidgets('renders OnboardingPage', (tester) async {
      await tester.pumpApp(OnboardingPage());
      expect(find.byType(OnboardingPage), findsOneWidget);
    });
  });
}
