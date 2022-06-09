// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

void main() {
  late AppBloc appBloc;
  late User user;

  const subscribeButtonKey =
      Key('subscribeWithArticleLimitModal_subscribeButton');
  const logInButtonKey = Key('subscribeWithArticleLimitModal_logInButton');
  const watchVideoButton =
      Key('subscribeWithArticleLimitModal_watchVideoButton');

  setUp(() {
    user = MockUser();
    appBloc = MockAppBloc();
    when(() => appBloc.state).thenReturn(AppState.unauthenticated());
  });

  group('SubscribeWithArticleLimitModal', () {
    group('renders', () {
      testWidgets(
          'subscribe and watch video buttons when user is authenticated',
          (tester) async {
        when(() => appBloc.state).thenReturn(AppState.authenticated(user));
        await tester.pumpApp(
          SubscribeWithArticleLimitModal(),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(watchVideoButton), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsNothing);
      });

      testWidgets(
          'subscribe log in and watch video buttons'
          ' when user is unauthenticated', (tester) async {
        when(() => appBloc.state).thenReturn(AppState.unauthenticated());
        await tester.pumpApp(
          SubscribeWithArticleLimitModal(),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsOneWidget);
        expect(find.byKey(watchVideoButton), findsOneWidget);
      });
    });

    group('does nothing', () {
      testWidgets('when tapped on subscribe button', (tester) async {
        await tester.pumpApp(SubscribeWithArticleLimitModal());
        await tester.tap(find.byKey(subscribeButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
      });

      testWidgets('when tapped on watch video button', (tester) async {
        await tester.pumpApp(SubscribeWithArticleLimitModal());
        await tester.tap(find.byKey(watchVideoButton));
        await tester.pumpAndSettle();
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
      });
    });

    testWidgets(
        'shows LoginModal '
        'when tapped on log in button', (tester) async {
      whenListen(
        appBloc,
        Stream.value(AppState.unauthenticated()),
        initialState: AppState.unauthenticated(),
      );

      await tester.pumpApp(
        SubscribeWithArticleLimitModal(),
        appBloc: appBloc,
      );

      await tester.tap(find.byKey(logInButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(LoginModal), findsOneWidget);
    });
  });
}
