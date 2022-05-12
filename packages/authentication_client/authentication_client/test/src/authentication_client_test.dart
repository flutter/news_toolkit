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
    expect(FakeAuthenticationClient, returnsNormally);
  });

  test('exports SendLoginEmailLinkFailure', () {
    expect(
      () => SendLoginEmailLinkFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports IsLogInWithEmailLinkFailure', () {
    expect(
      () => IsLogInWithEmailLinkFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogInWithEmailLinkFailure', () {
    expect(
      () => LogInWithEmailLinkFailure('oops', StackTrace.empty),
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

  test('exports LogInWithTwitterFailure', () {
    expect(
      () => LogInWithTwitterFailure('oops', StackTrace.empty),
      returnsNormally,
    );
  });

  test('exports LogInWithTwitterCanceled', () {
    expect(
      () => LogInWithTwitterCanceled('oops', StackTrace.empty),
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
