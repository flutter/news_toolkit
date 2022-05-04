// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  const passwordString = 'password';
  group('LoginPassword', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        final password = LoginPassword.pure();
        expect(password.value, '');
        expect(password.isPure, true);
      });

      test('dirty creates correct instance', () {
        final password = LoginPassword.dirty(passwordString);
        expect(password.value, passwordString);
        expect(password.isPure, false);
      });
    });

    group('validator', () {
      test('returns invalid error when password is empty', () {
        expect(
          LoginPassword.dirty().error,
          LoginPasswordValidationError.empty,
        );
      });

      test('is valid when password is not empty', () {
        expect(
          LoginPassword.dirty(passwordString).error,
          isNull,
        );
      });
    });
  });
}
