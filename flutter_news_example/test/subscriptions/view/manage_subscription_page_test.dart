// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/subscriptions/subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

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
  group('ManageSubscriptionPage', () {
    testWidgets('routeBuilder builds a ManageSubscriptionPage', (tester) async {
      final page = ManageSubscriptionPage.routeBuilder(context, goRouterState);

      expect(page, isA<ManageSubscriptionPage>());
    });

    testWidgets('renders ManageSubscriptionView', (tester) async {
      await tester.pumpApp(ManageSubscriptionPage());
      expect(find.byType(ManageSubscriptionView), findsOneWidget);
    });
  });

  group('ManageSubscriptionView', () {
    final appBloc = MockAppBloc();

    testWidgets(
        'navigates back '
        'when subscriptions ListTile tapped', (tester) async {
      final navigator = MockNavigator();
      when(navigator.canPop).thenAnswer((_) => true);
      when(navigator.maybePop).thenAnswer((_) async => true);

      await tester.pumpApp(
        ManageSubscriptionPage(),
        appBloc: appBloc,
        navigator: navigator,
      );

      await tester.tap(find.byKey(Key('manageSubscription_subscriptions')));
      await tester.pumpAndSettle();
      verify(navigator.maybePop).called(1);
    });
  });
}
