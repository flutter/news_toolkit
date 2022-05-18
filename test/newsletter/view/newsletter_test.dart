// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/newsletter/newsletter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

class MockNewsletterBloc extends Mock implements NewsletterBloc {}

void main() {
  late NewsletterBloc bloc;
  const initialState = NewsletterState();

  setUp(() {
    bloc = MockNewsletterBloc();
  });

  group('Newsletter', () {
    testWidgets('renders NewsletterView', (tester) async {
      await tester.pumpApp(
        Newsletter(),
      );

      expect(find.byType(NewsletterView), findsOneWidget);
    });
  });

  group('NewsletterView', () {
    testWidgets('renders NewsletterSignUp', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable([initialState]),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: bloc,
          child: NewsletterView(),
        ),
      );

      expect(find.byType(NewsletterSignUp), findsOneWidget);
    });

    testWidgets('renders disabled button when status is not valid',
        (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable([initialState]),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: bloc,
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
        bloc,
        Stream.fromIterable([initialState.copyWith(isValid: true)]),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: bloc,
          child: NewsletterView(),
        ),
      );

      final signUpButton = find.byType(AppButton);
      expect(tester.widget<AppButton>(signUpButton).onPressed, isNotNull);
      await tester.tap(signUpButton);

      verify(() => bloc.add(NewsletterSubscribed())).called(1);
    });

    testWidgets('onChanged triggered on email text field filled',
        (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable([initialState.copyWith(isValid: true)]),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: bloc,
          child: NewsletterView(),
        ),
      );

      const changedEmail = 'test@test.com';
      await tester.enterText(find.byType(AppEmailTextField), changedEmail);

      verify(() => bloc.add(EmailChanged(email: changedEmail))).called(1);
    });

    testWidgets('renders NewsletterSuccess when NewsletterStatus is success',
        (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(
          [NewsletterState(status: NewsletterStatus.success)],
        ),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: bloc,
          child: NewsletterView(),
        ),
      );

      expect(find.byType(NewsletterSucceeded), findsOneWidget);
    });

    testWidgets('shows SnackBar when NewsletterStatus is failure',
        (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(
          [NewsletterState(status: NewsletterStatus.failure)],
        ),
        initialState: initialState,
      );

      await tester.pumpApp(
        BlocProvider<NewsletterBloc>.value(
          value: bloc,
          child: NewsletterView(),
        ),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
