// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/onboarding/onboarding.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late AppBloc appBloc;
  const onboardingViewTitleKey = Key('onboardingView_onboardingTitle');
  const onboardingViewSubtitleKey = Key('onboardingView_onboardingsubTitle');
  const onboardingViewPageOneKey = Key('onboarding_pageOne');
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
  });

  group('renders', () {
    testWidgets('Onboarding title', (tester) async {
      await tester.pumpApp(OnboardingView());
      expect(find.byKey(onboardingViewTitleKey), findsOneWidget);
    });

    testWidgets('Onboarding subtitle', (tester) async {
      await tester.pumpApp(OnboardingView());
      expect(find.byKey(onboardingViewSubtitleKey), findsOneWidget);
    });

    testWidgets('Onboarding PageView', (tester) async {
      await tester.pumpApp(OnboardingView());
      expect(find.byType(PageView), findsOneWidget);
    });
  });

  group('Navigates', () {
    testWidgets('to onboarding item two', (tester) async {
      await tester.pumpApp(
        OnboardingView(),
      );
      final button = find.byWidgetPredicate(
        (widget) =>
            widget is OnboardingViewItem &&
            widget.key == onboardingViewPageOneKey &&
            widget.secondaryButton.key ==
                onboardingViewPageOneSecondaryButtonKey,
      );
      await tester.ensureVisible(button);
      await tester.tap(
        find.byKey(
          onboardingViewPageOneSecondaryButtonKey,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(onboardingViewPageTwoKey), findsOneWidget);
    });

    testWidgets('to home when onboarding is complete', (tester) async {
      await tester.pumpApp(
        OnboardingView(),
        appBloc: appBloc,
      );

      final buttonOne = find.byWidgetPredicate(
        (widget) =>
            widget is OnboardingViewItem &&
            widget.key == onboardingViewPageOneKey &&
            widget.secondaryButton.key ==
                onboardingViewPageOneSecondaryButtonKey,
      );
      await tester.ensureVisible(buttonOne);
      await tester.tap(
        find.byKey(
          onboardingViewPageOneSecondaryButtonKey,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(onboardingViewPageTwoKey), findsOneWidget);

      final button = find.byWidgetPredicate(
        (widget) =>
            widget is OnboardingViewItem &&
            widget.key == onboardingViewPageTwoKey &&
            widget.secondaryButton.key ==
                onboardingViewPageTwoSecondaryButtonKey,
      );
      await tester.ensureVisible(button);
      await tester.tap(
        find.byKey(
          onboardingViewPageTwoSecondaryButtonKey,
        ),
      );

      verify(() => appBloc.add(AppOnboardingCompleted())).called(1);
    });

    group('does nothing', () {
      testWidgets('when personalized my ads button is pressed', (tester) async {
        await tester.pumpApp(OnboardingView());
        final button = find.byWidgetPredicate(
          (widget) =>
              widget is OnboardingViewItem &&
              widget.key == onboardingViewPageOneKey &&
              widget.primaryButton.key == onboardingViewPageOnePrimaryButtonKey,
        );
        await tester.ensureVisible(button);
        await tester.tap(
          find.byKey(
            onboardingViewPageOnePrimaryButtonKey,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(onboardingViewPageOnePrimaryButtonKey),
          findsOneWidget,
        );
      });

      testWidgets('when subscribe to notifications now button is pressed',
          (tester) async {
        await tester.pumpApp(OnboardingView());
        final buttonOne = find.byWidgetPredicate(
          (widget) =>
              widget is OnboardingViewItem &&
              widget.key == onboardingViewPageOneKey &&
              widget.secondaryButton.key ==
                  onboardingViewPageOneSecondaryButtonKey,
        );
        await tester.ensureVisible(buttonOne);
        await tester.tap(
          find.byKey(
            onboardingViewPageOneSecondaryButtonKey,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(onboardingViewPageTwoKey), findsOneWidget);
        final button = find.byWidgetPredicate(
          (widget) =>
              widget is OnboardingViewItem &&
              widget.key == onboardingViewPageTwoKey &&
              widget.primaryButton.key == onboardingViewPageTwoPrimaryButtonKey,
        );
        await tester.ensureVisible(button);
        await tester.tap(
          find.byKey(
            onboardingViewPageTwoPrimaryButtonKey,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.byKey(onboardingViewPageTwoPrimaryButtonKey),
          findsOneWidget,
        );
      });
    });
  });
}
