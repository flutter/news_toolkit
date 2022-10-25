// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_template/analytics/analytics.dart';
import 'package:flutter_news_template/newsletter/newsletter.dart'
    hide NewsletterEvent;
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/helpers.dart';

class MockNewsletterBloc extends Mock implements NewsletterBloc {}

class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState>
    implements AnalyticsBloc {}

void main() {
  late NewsletterBloc newsletterBloc;

  const initialState = NewsletterState();

  setUp(() {
    newsletterBloc = MockNewsletterBloc();

    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('Newsletter', () {
    testWidgets('renders NewsletterView', (tester) async {
      await tester.pumpApp(
        Newsletter(),
      );

      await tester.pump();

      expect(find.byType(NewsletterView), findsOneWidget);
    });
  });

  group('NewsletterView', () {
    testWidgets('renders NewsletterSignUp', (tester) async {
      whenListen(
        newsletterBloc,
        Stream.fromIterable([initialState]),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: newsletterBloc,
          child: NewsletterView(),
        ),
      );

      expect(find.byType(NewsletterSignUp), findsOneWidget);
    });

    testWidgets('renders disabled button when status is not valid',
        (tester) async {
      whenListen(
        newsletterBloc,
        Stream.fromIterable([initialState]),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: newsletterBloc,
          child: NewsletterView(),
        ),
      );

      expect(
        tester.widget<AppButton>(find.byType(AppButton)).onPressed,
        isNull,
      );
    });

    testWidgets('renders enabled button when status is valid', (tester) async {
      whenListen(
        newsletterBloc,
        Stream.fromIterable([initialState.copyWith(isValid: true)]),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: newsletterBloc,
          child: NewsletterView(),
        ),
      );

      final signUpButton = find.byType(AppButton);
      expect(tester.widget<AppButton>(signUpButton).onPressed, isNotNull);
      await tester.tap(signUpButton);

      verify(() => newsletterBloc.add(NewsletterSubscribed())).called(1);
    });

    testWidgets(
        'adds EmailChanged to NewsletterBloc '
        'on email text field filled', (tester) async {
      whenListen(
        newsletterBloc,
        Stream.fromIterable([initialState.copyWith(isValid: true)]),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: newsletterBloc,
          child: NewsletterView(),
        ),
      );

      const changedEmail = 'test@test.com';
      await tester.enterText(find.byType(AppEmailTextField), changedEmail);

      verify(() => newsletterBloc.add(EmailChanged(email: changedEmail)))
          .called(1);
    });

    testWidgets(
        'adds TrackAnalyticsEvent to AnalyticsBloc '
        'with NewsletterEvent.impression '
        'when shown', (tester) async {
      final AnalyticsBloc analyticsBloc = MockAnalyticsBloc();

      whenListen(
        newsletterBloc,
        Stream.fromIterable([initialState]),
        initialState: initialState,
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: newsletterBloc),
            BlocProvider.value(value: analyticsBloc),
          ],
          child: NewsletterView(),
        ),
      );

      verify(
        () => analyticsBloc.add(
          TrackAnalyticsEvent(NewsletterEvent.impression()),
        ),
      ).called(1);
    });

    testWidgets(
        'adds TrackAnalyticsEvent to AnalyticsBloc '
        'with NewsletterEvent.signUp '
        'when status is success', (tester) async {
      final AnalyticsBloc analyticsBloc = MockAnalyticsBloc();

      whenListen(
        newsletterBloc,
        Stream.fromIterable(
          [
            NewsletterState(),
            NewsletterState(status: NewsletterStatus.success),
          ],
        ),
        initialState: initialState,
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: newsletterBloc),
            BlocProvider.value(value: analyticsBloc),
          ],
          child: NewsletterView(),
        ),
      );

      verify(
        () => analyticsBloc.add(
          TrackAnalyticsEvent(NewsletterEvent.signUp()),
        ),
      ).called(1);
    });

    testWidgets('renders NewsletterSuccess when NewsletterStatus is success',
        (tester) async {
      whenListen(
        newsletterBloc,
        Stream.fromIterable(
          [NewsletterState(status: NewsletterStatus.success)],
        ),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: newsletterBloc,
          child: NewsletterView(),
        ),
      );

      expect(find.byType(NewsletterSucceeded), findsOneWidget);
    });

    testWidgets('shows SnackBar when NewsletterStatus is failure',
        (tester) async {
      whenListen(
        newsletterBloc,
        Stream.fromIterable(
          [NewsletterState(status: NewsletterStatus.failure)],
        ),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: newsletterBloc,
          child: NewsletterView(),
        ),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
