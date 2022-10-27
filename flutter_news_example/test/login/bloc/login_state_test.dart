// ignore_for_file: prefer_const_constructors
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';

void main() {
  const email = Email.dirty('email');

  group('LoginState', () {
    test('supports value comparisons', () {
      expect(LoginState(), LoginState());
    });

    test('returns same object when no properties are passed', () {
      expect(LoginState().copyWith(), LoginState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        LoginState().copyWith(status: FormzSubmissionStatus.initial),
        LoginState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        LoginState().copyWith(email: email),
        LoginState(email: email),
      );
    });

    test('returns object with updated valid when valid is passed', () {
      expect(
        LoginState().copyWith(valid: true),
        LoginState(valid: true),
      );
    });
  });
}
