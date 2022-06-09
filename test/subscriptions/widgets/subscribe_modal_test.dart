// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/subscriptions/subscribe.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

void main() {
  late AppBloc appBloc;
  late User user;

  const subscribeButtonKey = Key('subscribeModal_subscribeButton');
  const logInButtonKey = Key('subscribeModal_logInButton');

  setUp(() {
    user = MockUser();
    appBloc = MockAppBloc();
    when(() => appBloc.state).thenReturn(AppState.unauthenticated());
  });

  group('SubscribeModal', () {
    group('renders', () {
      testWidgets('subscribe button when user is authenticated',
          (tester) async {
        when(() => appBloc.state).thenReturn(AppState.authenticated(user));
        await tester.pumpApp(
          SubscribeModal(),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsNothing);
      });

      testWidgets('subscribe and log in buttons when user is unauthenticated',
          (tester) async {
        when(() => appBloc.state).thenReturn(AppState.unauthenticated());
        await tester.pumpApp(
          SubscribeModal(),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsOneWidget);
      });
    });

    group('does nothing', () {
      testWidgets('when tapped on subscribe button', (tester) async {
        await tester.pumpApp(SubscribeModal());
        await tester.tap(find.byKey(subscribeButtonKey));
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
        SubscribeModal(),
        appBloc: appBloc,
      );

      await tester.tap(find.byKey(logInButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(LoginModal), findsOneWidget);
    });
  });
}
