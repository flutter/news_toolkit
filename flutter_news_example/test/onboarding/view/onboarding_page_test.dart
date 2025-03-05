// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/onboarding/onboarding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  late GoRouterState goRouterState;
  late BuildContext context;

  setUp(() {
    goRouterState = _MockGoRouterState();
    context = _MockBuildContext();
  });
  group('OnboardingPage', () {
    testWidgets('routeBuilder builds a OnboardingPage', (tester) async {
      final page = OnboardingPage.routeBuilder(context, goRouterState);

      expect(page, isA<OnboardingPage>());
    });

    testWidgets('renders OnboardingView', (tester) async {
      await tester.pumpApp(OnboardingPage());
      expect(find.byType(OnboardingView), findsOneWidget);
    });
  });
}
