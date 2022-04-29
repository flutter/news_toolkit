import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/login/login.dart';
import 'package:mockingjay/mockingjay.dart' show MockNavigator;
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
  const loginFormCloseModalKey = Key('loginForm_closeModal');

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
          'LoginGoogleSubmitted when sign in with google button is pressed',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithGoogleButtonKey));
        await tester.tap(find.byKey(signInWithGoogleButtonKey));
        verify(() => loginBloc.add(LoginGoogleSubmitted())).called(1);
      });

      testWidgets(
          'LoginTwitterSubmitted when sign in with Twitter button is pressed',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithTwitterButtonKey));
        await tester.tap(find.byKey(signInWithTwitterButtonKey));
        verify(() => loginBloc.add(LoginTwitterSubmitted())).called(1);
      });

      testWidgets(
          'LoginFacebookSubmitted when sign in with Facebook button is pressed',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(signInWithFacebookButtonKey));
        await tester.tap(find.byKey(signInWithFacebookButtonKey));
        verify(() => loginBloc.add(LoginFacebookSubmitted())).called(1);
      });

      testWidgets(
          'LoginAppleSubmitted when sign in with apple button is pressed',
          (tester) async {
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
            LoginState(status: FormzStatus.submissionInProgress),
            LoginState(status: FormzStatus.submissionFailure),
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
            LoginState(status: FormzStatus.submissionInProgress),
            LoginState(status: FormzStatus.submissionCanceled),
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
      testWidgets('when the close icon is pressed', (tester) async {
        final navigator = MockNavigator();
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginForm(),
          ),
          navigator: navigator,
        );
        await tester.tap(find.byKey(loginFormCloseModalKey));
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });

      testWidgets('when user is authenticated', (tester) async {
        final navigator = MockNavigator();
        whenListen(
          appBloc,
          Stream.fromIterable(
            <AppState>[AppState.authenticated(user)],
          ),
          initialState: const AppState.unauthenticated(),
        );

        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginForm(),
          ),
          navigator: navigator,
          appBloc: appBloc,
        );
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });
    });
  });
}
