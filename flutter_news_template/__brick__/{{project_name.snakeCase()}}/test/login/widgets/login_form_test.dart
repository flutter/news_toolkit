// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockUser extends Mock implements User {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  const loginButtonKey = Key('loginForm_emailLogin_appButton');
  const signInWithGoogleButtonKey = Key('loginForm_googleLogin_appButton');
  const signInWithAppleButtonKey = Key('loginForm_appleLogin_appButton');
  const signInWithFacebookButtonKey = Key('loginForm_facebookLogin_appButton');
  const signInWithTwitterButtonKey = Key('loginForm_twitterLogin_appButton');
  const loginFormCloseModalKey = Key('loginForm_closeModal_iconButton');

  group('LoginForm', () {
    late LoginBloc loginBloc;
    late AppBloc appBloc;
    late User user;

    setUp(() {
      loginBloc = MockLoginBloc();
      appBloc = MockAppBloc();
      user = MockUser();

      when(() => loginBloc.state).thenReturn(const LoginState());
    });

    group('adds', () {
      testWidgets(
          'LoginGoogleSubmitted to LoginBloc '
          'when sign in with google button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithGoogleButtonKey));
        await tester.tap(find.byKey(signInWithGoogleButtonKey));
        verify(() => loginBloc.add(LoginGoogleSubmitted())).called(1);
      });

      testWidgets(
          'LoginTwitterSubmitted to LoginBloc '
          'when sign in with Twitter button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithTwitterButtonKey));
        await tester.tap(find.byKey(signInWithTwitterButtonKey));
        verify(() => loginBloc.add(LoginTwitterSubmitted())).called(1);
      });

      testWidgets(
          'LoginFacebookSubmitted to LoginBloc '
          'when sign in with Facebook button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithFacebookButtonKey));
        await tester.tap(find.byKey(signInWithFacebookButtonKey));
        verify(() => loginBloc.add(LoginFacebookSubmitted())).called(1);
      });

      testWidgets(
          'LoginAppleSubmitted to LoginBloc '
          'when sign in with apple button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          platform: TargetPlatform.iOS,
        );
        await tester.ensureVisible(find.byKey(signInWithAppleButtonKey));
        await tester.tap(find.byKey(signInWithAppleButtonKey));
        verify(() => loginBloc.add(LoginAppleSubmitted())).called(1);
      });

      testWidgets('AuthenticationFailure SnackBar when submission fails',
          (tester) async {
        whenListen(
          loginBloc,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.failure),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('nothing when login is canceled', (tester) async {
        whenListen(
          loginBloc,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.canceled),
          ]),
        );
      });
    });

    group('renders', () {
      testWidgets('Sign in with Google and Apple on iOS', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          platform: TargetPlatform.iOS,
        );
        expect(find.byKey(signInWithAppleButtonKey), findsOneWidget);
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });

      testWidgets('only Sign in with Google on Android', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          platform: TargetPlatform.android,
        );
        expect(find.byKey(signInWithAppleButtonKey), findsNothing);
        expect(find.byKey(signInWithGoogleButtonKey), findsOneWidget);
      });

      testWidgets('Sign in with Facebook', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        expect(find.byKey(signInWithFacebookButtonKey), findsOneWidget);
      });

      testWidgets('Sign in with Twitter', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        expect(find.byKey(signInWithTwitterButtonKey), findsOneWidget);
      });
    });

    group('navigates', () {
      testWidgets('to LoginWithEmailPage when Continue with email is pressed',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(loginButtonKey));
        await tester.tap(find.byKey(loginButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(LoginWithEmailPage), findsOneWidget);
      });
    });

    group('closes modal', () {
      const buttonText = 'button';

      testWidgets('when the close icon is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: Builder(
              builder: (context) {
                return AppButton.black(
                  child: Text(buttonText),
                  onPressed: () => showAppModal<void>(
                    context: context,
                    builder: (context) => const LoginModal(),
                    routeSettings: const RouteSettings(name: LoginModal.name),
                  ),
                );
              },
            ),
          ),
        );
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(loginFormCloseModalKey));
        await tester.pumpAndSettle();

        expect(find.byType(LoginForm), findsNothing);
      });

      testWidgets('when user is authenticated', (tester) async {
        final appStateController = StreamController<AppState>();

        whenListen(
          appBloc,
          appStateController.stream,
          initialState: const AppState.unauthenticated(),
        );

        await tester.pumpApp(
          Builder(
            builder: (context) {
              return AppButton.black(
                child: Text(buttonText),
                onPressed: () => showAppModal<void>(
                  context: context,
                  builder: (context) => BlocProvider.value(
                    value: appBloc,
                    child: LoginModal(),
                  ),
                  routeSettings: const RouteSettings(name: LoginModal.name),
                ),
              );
            },
          ),
        );
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byKey(loginButtonKey));
        await tester.tap(find.byKey(loginButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(LoginWithEmailPage), findsOneWidget);

        appStateController.add(AppState.authenticated(user));
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byType(LoginWithEmailPage), findsNothing);
        expect(find.byType(LoginForm), findsNothing);
      });
    });
  });
}
