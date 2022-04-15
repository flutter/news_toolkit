import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/sign_up/sign_up.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

class MockEmail extends Mock implements Email {}

class MockPassword extends Mock implements SignUpPassword {}

void main() {
  const signUpButtonKey = Key('signUpForm_continue_elevatedButton');
  const emailInputKey = Key('signUpForm_emailInput_textField');
  const passwordInputKey = Key('signUpForm_passwordInput_textField');

  const testEmail = 'test@gmail.com';
  const testPassword = 'testP@ssw0rd1';

  group('SignUpForm', () {
    late SignUpBloc signUpBloc;

    setUp(() {
      signUpBloc = MockSignUpBloc();
      when(() => signUpBloc.state).thenReturn(const SignUpState());
    });

    group('adds', () {
      testWidgets('SignUpEmailChanged when email changes', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(() => signUpBloc.add(const SignUpEmailChanged(testEmail)))
            .called(1);
      });

      testWidgets('SignUpPasswordChanged when password changes',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        await tester.enterText(find.byKey(passwordInputKey), testPassword);
        verify(
          () => signUpBloc.add(const SignUpPasswordChanged(testPassword)),
        ).called(1);
      });

      testWidgets('SignUpSubmitted when sign up button is pressed',
          (tester) async {
        when(() => signUpBloc.state).thenReturn(
          const SignUpState(status: FormzStatus.valid),
        );
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        await tester.tap(find.byKey(signUpButtonKey));
        verify(() => signUpBloc.add(SignUpSubmitted())).called(1);
      });
    });

    group('renders', () {
      testWidgets('Sign Up Failure SnackBar when submission fails',
          (tester) async {
        whenListen(
          signUpBloc,
          Stream.fromIterable(const <SignUpState>[
            SignUpState(status: FormzStatus.submissionInProgress),
            SignUpState(status: FormzStatus.submissionFailure),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = MockEmail();
        when(() => email.invalid).thenReturn(true);
        when(() => signUpBloc.state).thenReturn(SignUpState(email: email));
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        expect(find.text('Invalid email'), findsOneWidget);
      });

      testWidgets('invalid password error text when password is invalid',
          (tester) async {
        final password = MockPassword();
        when(() => password.invalid).thenReturn(true);
        when(() => signUpBloc.state)
            .thenReturn(SignUpState(password: password));
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        expect(find.text('Invalid password'), findsOneWidget);
      });

      testWidgets('disabled sign up button when status is not validated',
          (tester) async {
        when(() => signUpBloc.state).thenReturn(
          const SignUpState(status: FormzStatus.invalid),
        );
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        final signUpButton = tester.widget<ElevatedButton>(
          find.byKey(signUpButtonKey),
        );
        expect(signUpButton.enabled, isFalse);
      });

      testWidgets('enabled sign up button when status is validated',
          (tester) async {
        when(() => signUpBloc.state).thenReturn(
          const SignUpState(status: FormzStatus.valid),
        );
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        final signUpButton = tester.widget<ElevatedButton>(
          find.byKey(signUpButtonKey),
        );
        expect(signUpButton.enabled, isTrue);
      });
    });

    group('navigates', () {
      testWidgets('back to previous page when submission status is success',
          (tester) async {
        whenListen(
          signUpBloc,
          Stream.fromIterable(const <SignUpState>[
            SignUpState(status: FormzStatus.submissionInProgress),
            SignUpState(status: FormzStatus.submissionSuccess),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: signUpBloc,
            child: const Scaffold(body: SignUpForm()),
          ),
        );
        expect(find.byType(SignUpForm), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.byType(SignUpForm), findsNothing);
      });
    });
  });
}
