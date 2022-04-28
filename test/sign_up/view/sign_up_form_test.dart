import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  const nextButtonKey = Key('signUpForm_nextButton');
  const emailInputKey = Key('signUpForm_emailInput_textField');
  const signUpFormHeaderTitleKey = Key('signUpForm_header_title');
  const signUpFormTermsAndPrivacyPolicyKey =
      Key('signUpForm_terms_and_privacy_policy');
  const signUpFormSuffixIconKey = Key('email_textField_suffixIcon');

  const testEmail = 'test@gmail.com';
  const invalidTestEmail = 'test@g';

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

      testWidgets('SignUpSubmitted when next button is pressed',
          (tester) async {
        when(() => signUpBloc.state).thenReturn(
          const SignUpState(status: FormzStatus.valid),
        );
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        await tester.tap(find.byKey(nextButtonKey));
        verify(() => signUpBloc.add(SignUpSubmitted())).called(1);
      });
    });

    group('renders', () {
      testWidgets('header title', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        final headerTitle = find.byKey(signUpFormHeaderTitleKey);
        expect(headerTitle, findsOneWidget);
      });

      testWidgets('email text field', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        final emailTextField = find.byKey(emailInputKey);
        expect(emailTextField, findsOneWidget);
      });

      testWidgets('terms and privacy policy text', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        final termsAndPrivacyPolicyText =
            find.byKey(signUpFormTermsAndPrivacyPolicyKey);
        expect(termsAndPrivacyPolicyText, findsOneWidget);
      });

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

      testWidgets(
          'Terms and Privacy Policy SnackBar when tapped on '
          'Terms of Use and Privacy Policy text', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );

        final richText =
            find.byKey(const Key('signUpForm_terms_and_privacy_policy')).first;
        fireOnTap(
          richText,
          'Terms of Use and Privacy Policy',
        );

        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('disabled next button when status is not validated',
          (tester) async {
        when(() => signUpBloc.state).thenReturn(
          const SignUpState(status: FormzStatus.invalid),
        );
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        final signUpButton = tester.widget<AppButton>(
          find.byKey(nextButtonKey),
        );
        expect(signUpButton.onPressed, null);
      });

      testWidgets('disabled next button when invalid email is added',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        await tester.enterText(find.byKey(emailInputKey), invalidTestEmail);
        final signUpButton = tester.widget<AppButton>(
          find.byKey(nextButtonKey),
        );
        expect(signUpButton.onPressed, null);
      });

      testWidgets('enabled next button when status is validated',
          (tester) async {
        when(() => signUpBloc.state).thenReturn(
          const SignUpState(status: FormzStatus.valid),
        );
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        final signUpButton = tester.widget<AppButton>(
          find.byKey(nextButtonKey),
        );
        expect(signUpButton.onPressed, isNotNull);
      });
    });

    group('delete', () {
      testWidgets('email when press on suffixIcon', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: signUpBloc, child: const SignUpForm()),
        );
        await tester.enterText(find.byKey(emailInputKey), testEmail);
        await tester.tap(find.byKey(signUpFormSuffixIconKey));
        await tester.pumpAndSettle();
        final emailTextFieldText = tester.widget<AppEmailField>(
          find.byKey(emailInputKey),
        );
        expect(emailTextFieldText.controller?.text, '');
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

/// Runs the onTap handler for the [TextSpan] which matches the search-string.
void fireOnTap(Finder finder, String text) {
  late RenderParagraph paragraph;
  final element = finder.evaluate().single;
  if (element.renderObject != null) {
    paragraph = element.renderObject! as RenderParagraph;
  }

  // The children are the individual TextSpans which have GestureRecognizers
  paragraph.text.visitChildren((dynamic span) {
    if ((span as TextSpan).text != text) return true; // continue iterating.
    final recognizer = span.recognizer;

    if (recognizer is TapGestureRecognizer) {
      recognizer.onTap!();
    }
    return false; // stop iterating, we found the one.
  });
}
