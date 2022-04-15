import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/reset_password/reset_password.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockSignUpBloc extends MockBloc<ResetPasswordEvent, ResetPasswordState>
    implements ResetPasswordBloc {}

class MockEmail extends Mock implements Email {}

void main() {
  const submitButtonKey = Key('submitResetPassword_continue_elevatedButton');
  const emailInputKey = Key('resetPasswordForm_emailInput_textField');

  const testEmail = 'test@gmail.com';

  group('ResetPasswordForm', () {
    late ResetPasswordBloc resetPasswordBloc;

    setUp(() {
      resetPasswordBloc = MockSignUpBloc();
      when(
        () => resetPasswordBloc.state,
      ).thenReturn(const ResetPasswordState());
    });

    group('adds', () {
      testWidgets('ResetPasswordEmailChanged when email changes',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordForm(),
          ),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        verify(
          () => resetPasswordBloc.add(
            const ResetPasswordEmailChanged(testEmail),
          ),
        ).called(1);
      });

      testWidgets('ResetPasswordSubmitted when submit button is pressed',
          (tester) async {
        when(() => resetPasswordBloc.state).thenReturn(
          const ResetPasswordState(status: FormzStatus.valid),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordForm(),
          ),
        );
        await tester.tap(find.byKey(submitButtonKey));
        verify(
          () => resetPasswordBloc.add(const ResetPasswordSubmitted()),
        ).called(1);
      });
    });

    group('renders', () {
      testWidgets('Sign Up Failure SnackBar when submission fails',
          (tester) async {
        whenListen(
          resetPasswordBloc,
          Stream.fromIterable(const <ResetPasswordState>[
            ResetPasswordState(status: FormzStatus.submissionInProgress),
            ResetPasswordState(status: FormzStatus.submissionFailure),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordForm(),
          ),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = MockEmail();
        when(() => email.invalid).thenReturn(true);
        when(() => resetPasswordBloc.state)
            .thenReturn(ResetPasswordState(email: email));
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordForm(),
          ),
        );
        expect(find.text('Invalid email'), findsOneWidget);
      });

      testWidgets('disabled submit button when status is not validated',
          (tester) async {
        when(() => resetPasswordBloc.state).thenReturn(
          const ResetPasswordState(status: FormzStatus.invalid),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordForm(),
          ),
        );
        final submitButton = tester.widget<ElevatedButton>(
          find.byKey(submitButtonKey),
        );
        expect(submitButton.enabled, isFalse);
      });

      testWidgets('enabled submit button when status is validated',
          (tester) async {
        when(() => resetPasswordBloc.state).thenReturn(
          const ResetPasswordState(status: FormzStatus.valid),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordForm(),
          ),
        );
        final submitButton = tester.widget<ElevatedButton>(
          find.byKey(submitButtonKey),
        );
        expect(submitButton.enabled, isTrue);
      });
    });

    group('navigates', () {
      testWidgets('back to previous page when submission status is success',
          (tester) async {
        whenListen(
          resetPasswordBloc,
          Stream.fromIterable(const <ResetPasswordState>[
            ResetPasswordState(status: FormzStatus.submissionInProgress),
            ResetPasswordState(status: FormzStatus.submissionSuccess),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const Scaffold(body: ResetPasswordForm()),
          ),
        );
        expect(find.byType(ResetPasswordForm), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.byType(ResetPasswordForm), findsNothing);
      });
    });
  });
}
