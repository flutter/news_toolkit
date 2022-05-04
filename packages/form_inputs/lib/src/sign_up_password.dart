import 'package:formz/formz.dart';

/// Password Form Input Validation Error
enum SignUpPasswordValidationError {
  /// Password is invalid (generic validation error)
  invalid
}

/// {@template sign_up_password}
/// Reusable password form input for sign up.
/// {@endtemplate}
class SignUpPassword extends FormzInput<String, SignUpPasswordValidationError> {
  /// {@macro sign_up_password}
  const SignUpPassword.pure() : super.pure('');

  /// {@macro password}
  const SignUpPassword.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  SignUpPasswordValidationError? validator(String value) {
    return _passwordRegExp.hasMatch(value)
        ? null
        : SignUpPasswordValidationError.invalid;
  }
}
