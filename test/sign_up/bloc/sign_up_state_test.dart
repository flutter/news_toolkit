// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/sign_up/sign_up.dart';

void main() {
  const email = Email.dirty('email');
  const password = SignUpPassword.dirty('password');
  group('SignUpState', () {
    test('supports value comparisons', () {
      expect(SignUpState(), SignUpState());
    });

    test('returns same object when no properties are passed', () {
      expect(SignUpState().copyWith(), SignUpState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        SignUpState().copyWith(status: FormzStatus.pure),
        SignUpState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        SignUpState().copyWith(email: email),
        SignUpState(email: email),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        SignUpState().copyWith(password: password),
        SignUpState(password: password),
      );
    });
  });
}
