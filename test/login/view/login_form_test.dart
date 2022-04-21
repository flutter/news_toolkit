import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/reset_password/reset_password.dart';
import 'package:google_news_template/sign_up/sign_up.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockEmail extends Mock implements Email {}

class MockPassword extends Mock implements LoginPassword {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}

void main() {
  const loginButtonKey = Key('loginForm_continue_elevatedButton');
  const signInWithGoogleButtonKey = Key('loginForm_googleLogin_elevatedButton');
  const signInWithFacebookButtonKey =
      Key('loginForm_facebookLogin_elevatedButton');
  const signInWithAppleButtonKey = Key('loginForm_appleLogin_elevatedButton');
  const emailInputKey = Key('loginForm_emailInput_textField');
  const passwordInputKey = Key('loginForm_passwordInput_textField');
  const createAccountButtonKey = Key('loginForm_createAccount_textButton');
  const forgotPasswordButtonKey = Key('loginForm_forgotPassword_textButton');

  const testEmail = 'test@gmail.com';
  const testPassword = 'testPassword123';

  const email = Email.dirty(testEmail);
  const password = LoginPassword.dirty(testPassword);

  group('LoginForm', () {
    late LoginBloc loginBloc;

    setUp(() {
      loginBloc = MockLoginBloc();
      when(() => loginBloc.state).thenReturn(const LoginState());
    });

    setUpAll(() {
      registerFallbackValue(MockRoute());
    });

    group('adds', () {
      testWidgets('LoginEmailChanged when email changes', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(
          () => loginBloc.add(const LoginEmailChanged(testEmail)),
        ).called(1);
      });

      testWidgets('LoginPasswordChanged when password changes', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.enterText(find.byKey(passwordInputKey), testPassword);
        verify(
          () => loginBloc.add(const LoginPasswordChanged(testPassword)),
        ).called(1);
      });

      testWidgets('LoginCredentialsSubmitted when login button is pressed',
          (tester) async {
        when(() => loginBloc.state).thenReturn(
          const LoginState(
            status: FormzStatus.valid,
            email: email,
            password: password,
          ),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(loginButtonKey));
        await tester.tap(find.byKey(loginButtonKey));
        verify(() => loginBloc.add(LoginCredentialsSubmitted())).called(1);
      });

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
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsNothing);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = MockEmail();
        when(() => email.valid).thenReturn(false);
        when(() => email.invalid).thenReturn(true);
        when(() => loginBloc.state).thenReturn(
          LoginState(email: email, password: password),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        expect(find.text('Invalid email'), findsOneWidget);
      });

      testWidgets('invalid password error text when password is invalid',
          (tester) async {
        final password = MockPassword();
        when(() => password.invalid).thenReturn(true);
        when(() => loginBloc.state).thenReturn(LoginState(password: password));
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        expect(find.text('Invalid password'), findsOneWidget);
      });

      testWidgets('disabled login button when status is not validated',
          (tester) async {
        when(() => loginBloc.state).thenReturn(
          const LoginState(status: FormzStatus.invalid),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        final loginButton = tester.widget<ElevatedButton>(
          find.byKey(loginButtonKey),
        );
        expect(loginButton.enabled, isFalse);
      });

      testWidgets('enabled login button when email and password are valid',
          (tester) async {
        when(() => loginBloc.state).thenReturn(
          const LoginState(
            status: FormzStatus.valid,
            email: email,
            password: password,
          ),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        final loginButton = tester.widget<ElevatedButton>(
          find.byKey(loginButtonKey),
        );
        expect(loginButton.enabled, isTrue);
      });
    });

    group('navigates', () {
      testWidgets('to SignUpPage when Create Account is pressed',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(createAccountButtonKey));
        await tester.tap(find.byKey(createAccountButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(SignUpPage), findsOneWidget);
      });

      testWidgets('to ResetPasswordPage when Forgot Password is pressed',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
        );
        await tester.ensureVisible(find.byKey(forgotPasswordButtonKey));
        await tester.tap(find.byKey(forgotPasswordButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(ResetPasswordPage), findsOneWidget);
      });

      testWidgets('back when submission succeeds', (tester) async {
        final navigatorObserver = MockNavigatorObserver();
        whenListen(
          loginBloc,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzStatus.submissionInProgress),
            LoginState(status: FormzStatus.submissionSuccess),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginForm()),
          navigatorObserver: navigatorObserver,
        );
        await tester.pump();
        verify(() => navigatorObserver.didPop(any(), any())).called(1);
      });
    });
  });
}
