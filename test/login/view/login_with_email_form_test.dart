import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/login/login.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockEmail extends Mock implements Email {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements User {}

void main() {
  const nextButtonKey = Key('loginWithEmailForm_nextButton');
  const emailInputKey = Key('loginWithEmailForm_emailInput_textField');
  const loginWithEmailFormHeaderTitleKey =
      Key('loginWithEmailForm_header_title');
  const loginWithEmailFormTermsAndPrivacyPolicyKey =
      Key('loginWithEmailForm_terms_and_privacy_policy');
  const loginWithEmailFormSuffixIconKey =
      Key('loginWithEmailForm_clearIconButton');

  const testEmail = 'test@gmail.com';
  const invalidTestEmail = 'test@g';

  late LoginBloc loginBloc;
  late AppBloc appBloc;
  late User user;

  group('LoginWithEmailForm', () {
    setUp(() {
      loginBloc = MockLoginBloc();
      appBloc = MockAppBloc();
      user = MockUser();
      when(() => loginBloc.state).thenReturn(const LoginState());
    });

    group('adds', () {
      testWidgets('LoginEmailChanged when email changes', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailForm(),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(() => loginBloc.add(const LoginEmailChanged(testEmail)))
            .called(1);
      });

      testWidgets('SendEmailLinkSubmitted when next button is pressed',
          (tester) async {
        when(() => loginBloc.state).thenReturn(
          const LoginState(status: FormzStatus.valid),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailForm(),
          ),
        );
        await tester.tap(find.byKey(nextButtonKey));
        verify(() => loginBloc.add(SendEmailLinkSubmitted())).called(1);
      });

      testWidgets('LoginEmailChanged when pressed on suffixIcon',
          (tester) async {
        when(() => loginBloc.state).thenAnswer(
          (_) => const LoginState(email: Email.dirty(testEmail)),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailForm(),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);

        await tester.ensureVisible(find.byKey(loginWithEmailFormSuffixIconKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(loginWithEmailFormSuffixIconKey));
        await tester.pumpAndSettle();
        verify(() => loginBloc.add(const LoginEmailChanged(''))).called(1);
      });

      group('renders', () {
        testWidgets('header title', (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailForm(),
            ),
          );
          final headerTitle = find.byKey(loginWithEmailFormHeaderTitleKey);
          expect(headerTitle, findsOneWidget);
        });

        testWidgets('email text field', (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailForm(),
            ),
          );
          final emailTextField = find.byKey(emailInputKey);
          expect(emailTextField, findsOneWidget);
        });

        testWidgets('terms and privacy policy text', (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailForm(),
            ),
          );
          final termsAndPrivacyPolicyText =
              find.byKey(loginWithEmailFormTermsAndPrivacyPolicyKey);
          expect(termsAndPrivacyPolicyText, findsOneWidget);
        });

        testWidgets('Login with email failure SnackBar when submission fails',
            (tester) async {
          whenListen(
            loginBloc,
            Stream.fromIterable(const <LoginState>[
              LoginState(status: FormzStatus.submissionInProgress),
              LoginState(status: FormzStatus.submissionFailure),
            ]),
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailForm(),
            ),
          );
          await tester.pump();
          expect(find.byType(SnackBar), findsOneWidget);
        });

        testWidgets(
            'TOS app modal when tapped on '
            'Terms of Use and Privacy Policy text', (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailForm(),
            ),
          );
          final richText = tester.widget<RichText>(
            find.byKey(loginWithEmailFormTermsAndPrivacyPolicyKey),
          );

          tapTextSpan(
            richText,
            'Terms of Use and Privacy Policy',
          );

          await tester.pumpAndSettle();
          expect(find.byType(TermsOfServiceModal), findsOneWidget);
        });

        testWidgets('disabled next button when status is not validated',
            (tester) async {
          when(() => loginBloc.state).thenReturn(
            const LoginState(status: FormzStatus.invalid),
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailForm(),
            ),
          );
          final signUpButton = tester.widget<AppButton>(
            find.byKey(nextButtonKey),
          );
          expect(signUpButton.onPressed, null);
        });

        testWidgets('disabled next button when invalid email is added',
            (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailForm(),
            ),
          );
          await tester.enterText(find.byKey(emailInputKey), invalidTestEmail);
          final signUpButton = tester.widget<AppButton>(
            find.byKey(nextButtonKey),
          );
          expect(signUpButton.onPressed, null);
        });

        testWidgets('enabled next button when status is validated',
            (tester) async {
          when(() => loginBloc.state).thenReturn(
            const LoginState(status: FormzStatus.valid),
          );
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginWithEmailForm(),
            ),
          );
          final signUpButton = tester.widget<AppButton>(
            find.byKey(nextButtonKey),
          );
          expect(signUpButton.onPressed, isNotNull);
        });
      });
    });

    group('navigates', () {
      testWidgets('when user is authenticated', (tester) async {
        final navigator = MockNavigator();
        whenListen(
          appBloc,
          Stream.fromIterable(
            <AppState>[AppState.authenticated(user)],
          ),
          initialState: const AppState.unauthenticated(),
        );

        when(() => navigator.popUntil(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          BlocProvider.value(
            value: loginBloc,
            child: const LoginWithEmailPage(),
          ),
          navigator: navigator,
          appBloc: appBloc,
        );
        await tester.pumpAndSettle();
        verify(() => navigator.popUntil(any())).called(1);
      });
    });
  });
}

void tapTextSpan(RichText richText, String text) =>
    richText.text.visitChildren((visitor) {
      if (visitor is TextSpan && visitor.text == text) {
        final recognizer = visitor.recognizer;
        if (recognizer is TapGestureRecognizer) {
          recognizer.onTap!();
        }
        return false;
      }
      return true;
    });
