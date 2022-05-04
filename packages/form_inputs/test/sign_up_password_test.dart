// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  const passwordString = 'T0pS3cr3t123';
  group('SignUpPassword', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        final password = SignUpPassword.pure();
        expect(password.value, '');
        expect(password.isPure, true);
      });

      test('dirty creates correct instance', () {
        final password = SignUpPassword.dirty(passwordString);
        expect(password.value, passwordString);
        expect(password.isPure, false);
      });
    });

    group('validator', () {
      test('returns invalid error when password is empty', () {
        expect(
          SignUpPassword.dirty().error,
          SignUpPasswordValidationError.invalid,
        );
      });

      test('is valid when password is not empty', () {
        expect(
          SignUpPassword.dirty(passwordString).error,
          isNull,
        );
      });
    });
  });
}
