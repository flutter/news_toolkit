// This package is just an abstraction.
// See firebase_authentication_client for a concrete implementation

// ignore_for_file: prefer_const_constructors

import 'package:authentication_client/authentication_client.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

// AuthenticationClient is exported and can be implemented
class FakeAuthenticationClient extends Fake implements AuthenticationClient {}

void main() {
  test('AuthenticationClient can be implemented', () {
    expect(() => FakeAuthenticationClient(), returnsNormally);
  });

  test('exports SignUpFailure', () {
    expect(
      () => SignUpFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports SignUpEmailInUseFailure', () {
    expect(
      () => SignUpEmailInUseFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports SignUpInvalidEmailFailure', () {
    expect(
      () => SignUpInvalidEmailFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports SignUpOperationNotAllowedFailure', () {
    expect(
      () => SignUpOperationNotAllowedFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports SignUpWeakPasswordFailure', () {
    expect(
      () => SignUpWeakPasswordFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports ResetPasswordFailure', () {
    expect(
      () => ResetPasswordFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports ResetPasswordInvalidEmailFailure', () {
    expect(
      () => ResetPasswordInvalidEmailFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports ResetPasswordUserNotFoundFailure', () {
    expect(
      () => ResetPasswordUserNotFoundFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogInWithEmailAndPasswordFailure', () {
    expect(
      () => LogInWithEmailAndPasswordFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports SendLoginEmailLinkFailure', () {
    expect(
      () => SendLoginEmailLinkFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogInWithAppleFailure', () {
    expect(
      () => LogInWithAppleFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogInWithGoogleFailure', () {
    expect(
      () => LogInWithGoogleFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogInWithGoogleCanceled', () {
    expect(
      () => LogInWithGoogleCanceled('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogInWithFacebookFailure', () {
    expect(
      () => LogInWithFacebookFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogInWithFacebookCanceled', () {
    expect(
      () => LogInWithFacebookCanceled('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogOutFailure', () {
    expect(
      () => LogOutFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });
}
