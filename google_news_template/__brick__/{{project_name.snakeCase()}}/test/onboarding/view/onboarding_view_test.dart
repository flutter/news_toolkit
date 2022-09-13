// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/onboarding/onboarding.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

void main() {
  late AppBloc appBloc;
  late OnboardingBloc onboardingBloc;

  const onboardingViewTitleKey = Key('onboardingView_onboardingTitle');
  const onboardingViewSubtitleKey = Key('onboardingView_onboardingSubtitle');
  const onboardingViewPageTwoKey = Key('onboarding_pageTwo');
  const onboardingViewPageOnePrimaryButtonKey =
      Key('onboardingItem_primaryButton_pageOne');
  const onboardingViewPageOneSecondaryButtonKey =
      Key('onboardingItem_secondaryButton_pageOne');

  const onboardingViewPageTwoPrimaryButtonKey =
      Key('onboardingItem_primaryButton_pageTwo');
  const onboardingViewPageTwoSecondaryButtonKey =
      Key('onboardingItem_secondaryButton_pageTwo');

  setUp(() {
    appBloc = MockAppBloc();
    onboardingBloc = MockOnboardingBloc();

    whenListen(
      onboardingBloc,
      Stream<OnboardingState>.empty(),
      initialState: OnboardingInitial(),
    );
  });

  group('renders', () {
    testWidgets('Onboarding title', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingBloc,
          child: OnboardingView(),
        ),
      );
      expect(find.byKey(onboardingViewTitleKey), findsOneWidget);
    });

    testWidgets('Onboarding subtitle', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingBloc,
          child: OnboardingView(),
        ),
      );
      expect(find.byKey(onboardingViewSubtitleKey), findsOneWidget);
    });

    testWidgets('Onboarding PageView', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingBloc,
          child: OnboardingView(),
        ),
      );
      expect(find.byType(PageView), findsOneWidget);
    });
  });

  group('navigates', () {
    testWidgets('to onboarding page two when button page one is tapped',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingBloc,
          child: OnboardingView(),
        ),
      );

      final button = find.byKey(onboardingViewPageOneSecondaryButtonKey);

      await tester.dragUntilVisible(
        button,
        find.byType(OnboardingView),
        Offset(0, -100),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.byKey(onboardingViewPageTwoKey), findsOneWidget);
    });

    testWidgets(
        'to onboarding page two '
        'when state is EnablingAdTrackingSucceeded', (tester) async {
      whenListen(
        onboardingBloc,
        Stream.fromIterable([
          OnboardingInitial(),
{{#include_ads}}
          EnablingAdTrackingSucceeded(),
{{/include_ads}}
        ]),
        initialState: OnboardingInitial(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingBloc,
          child: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(onboardingViewPageTwoKey), findsOneWidget);
    });

    testWidgets(
        'to onboarding page two '
        'when state is EnablingAdTrackingFailed', (tester) async {
      whenListen(
        onboardingBloc,
        Stream.fromIterable([
          OnboardingInitial(),
{{#include_ads}}
          EnablingAdTrackingFailed(),
{{/include_ads}}
        ]),
        initialState: OnboardingInitial(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingBloc,
          child: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(onboardingViewPageTwoKey), findsOneWidget);
    });

    testWidgets('to home when onboarding is complete', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingBloc,
          child: OnboardingView(),
        ),
        appBloc: appBloc,
      );

      final buttonOne = find.byKey(onboardingViewPageOneSecondaryButtonKey);

      await tester.dragUntilVisible(
        buttonOne,
        find.byType(OnboardingView),
        Offset(0, -100),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.tap(buttonOne);
      await tester.pumpAndSettle();

      expect(find.byKey(onboardingViewPageTwoKey), findsOneWidget);

      final button = find.byKey(onboardingViewPageTwoSecondaryButtonKey);
      await tester.tap(button);

      verify(() => appBloc.add(AppOnboardingCompleted())).called(1);
    });
  });

  testWidgets(
      'adds EnableNotificationsRequested to OnboardingBloc '
      'when subscribe to notifications now button is pressed', (tester) async {
    await tester.pumpApp(
      BlocProvider.value(
        value: onboardingBloc,
        child: OnboardingView(),
      ),
    );

    final buttonOne = find.byKey(onboardingViewPageOneSecondaryButtonKey);

    await tester.dragUntilVisible(
      buttonOne,
      find.byType(OnboardingView),
      Offset(0, -100),
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();
    await tester.tap(buttonOne);
    await tester.pumpAndSettle();

    expect(find.byKey(onboardingViewPageTwoKey), findsOneWidget);

    final button = find.byKey(onboardingViewPageTwoPrimaryButtonKey);

    await tester.dragUntilVisible(
      button,
      find.byType(OnboardingView),
      Offset(0, -100),
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(
      find.byKey(onboardingViewPageTwoPrimaryButtonKey),
      findsOneWidget,
    );

    verify(() => onboardingBloc.add(EnableNotificationsRequested())).called(1);
  });

  testWidgets(
      'adds AppOnboardingCompleted to AppBloc '
      'when OnboardingState is EnablingNotificationsSucceeded', (tester) async {
    final onboardingStateController = StreamController<OnboardingState>();

    whenListen(
      onboardingBloc,
      onboardingStateController.stream,
      initialState: OnboardingInitial(),
    );

    await tester.pumpApp(
      BlocProvider.value(
        value: onboardingBloc,
        child: OnboardingView(),
      ),
      appBloc: appBloc,
    );

    verifyNever(() => appBloc.add(AppOnboardingCompleted()));

    onboardingStateController.add(EnablingNotificationsSucceeded());
    await tester.pump();

    verify(() => appBloc.add(AppOnboardingCompleted())).called(1);
  });

  group('does nothing', () {
    testWidgets('when personalized my ads button is pressed', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: onboardingBloc,
          child: OnboardingView(),
        ),
      );

      final button = find.byKey(onboardingViewPageOnePrimaryButtonKey);

      await tester.dragUntilVisible(
        button,
        find.byType(OnboardingView),
        Offset(0, -100),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.byKey(onboardingViewPageOnePrimaryButtonKey),
        findsOneWidget,
      );
    });
  });
}
