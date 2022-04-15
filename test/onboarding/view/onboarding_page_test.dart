import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/onboarding/onboarding.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('OnboardingPage', () {
    testWidgets('renders OnboardingWelcome by default', (tester) async {
      await tester.pumpApp(const OnboardingPage());
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingWelcome), findsOneWidget);
    });
  });

  group('OnboardingWelcome', () {
    testWidgets(
        'updates to state to welcomeComplete '
        'when next is pressed', (tester) async {
      final appBloc = MockAppBloc();
      await tester.pumpApp(
        BlocProvider<AppBloc>.value(
          value: appBloc,
          child: const OnboardingWelcome(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));

      verify(() => appBloc.add(AppOnboardingCompleted())).called(1);
    });
  });
}
