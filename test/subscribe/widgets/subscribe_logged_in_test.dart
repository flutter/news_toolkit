// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/subscribe/subscribe.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

void main() {
  late AppBloc appBloc;
  late User user;

  const subscribeButtonKey = Key('subscribeLoggedInOutModal_subscribeButton');
  const logInButtonKey = Key('subscribeLoggedInOutModal_logInButton');

  setUp(() {
    user = MockUser();
    appBloc = MockAppBloc();
    when(() => appBloc.state).thenReturn(AppState.unauthenticated());
  });

  group('SubscribeLoggedInOutModal', () {
    group('renders', () {
      testWidgets(' SubscribeLoggedIn', (tester) async {
        await tester.pumpApp(
          SubscribeLoggedInOutModal(),
          appBloc: appBloc,
        );
        expect(find.byType(SubscribeLoggedInOutModal), findsOneWidget);
      });

      testWidgets('subscribe button when when user is authenticated',
          (tester) async {
        when(() => appBloc.state).thenReturn(AppState.authenticated(user));
        await tester.pumpApp(
          SubscribeLoggedInOutModal(),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
      });

      testWidgets(
          'Subscribe and Log In buttons when when user is unauthenticated',
          (tester) async {
        when(() => appBloc.state).thenReturn(AppState.unauthenticated());
        await tester.pumpApp(
          SubscribeLoggedInOutModal(),
          appBloc: appBloc,
        );
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
        expect(find.byKey(logInButtonKey), findsOneWidget);
      });
    });

    group('does nothing', () {
      testWidgets('when tap on Subscribe button', (tester) async {
        await tester.pumpApp(SubscribeLoggedInOutModal());
        await tester.tap(find.byKey(subscribeButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(subscribeButtonKey), findsOneWidget);
      });
    });

    group('navigates', () {
      testWidgets(
          'shows LoginModal '
          'when tapped on Log In button', (tester) async {
        whenListen(
          appBloc,
          Stream.value(AppState.unauthenticated()),
          initialState: AppState.unauthenticated(),
        );

        await tester.pumpApp(
          SubscribeLoggedInOutModal(),
          appBloc: appBloc,
        );

        await tester.tap(find.byKey(logInButtonKey));
        await tester.pumpAndSettle();

        expect(find.byType(LoginModal), findsOneWidget);
      });
    });
  });
}
