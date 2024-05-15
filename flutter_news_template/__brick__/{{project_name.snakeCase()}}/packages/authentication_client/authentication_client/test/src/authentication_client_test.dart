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
    expect(FakeAuthenticationClient.new, returnsNormally);
  });

  test('exports SendLoginEmailLinkFailure', () {
    expect(
      () => SendLoginEmailLinkFailure('oops'),
      returnsNormally,
    );
  });

  test('exports IsLogInWithEmailLinkFailure', () {
    expect(
      () => IsLogInWithEmailLinkFailure('oops'),
      returnsNormally,
    );
  });

  test('exports LogInWithEmailLinkFailure', () {
    expect(
      () => LogInWithEmailLinkFailure('oops'),
      returnsNormally,
    );
  });

  test('exports LogInWithAppleFailure', () {
    expect(
      () => LogInWithAppleFailure('oops'),
      returnsNormally,
    );
  });

  test('exports LogInWithGoogleFailure', () {
    expect(
      () => LogInWithGoogleFailure('oops'),
      returnsNormally,
    );
  });

  test('exports LogInWithGoogleCanceled', () {
    expect(
      () => LogInWithGoogleCanceled('oops'),
      returnsNormally,
    );
  });

  test('exports LogInWithFacebookFailure', () {
    expect(
      () => LogInWithFacebookFailure('oops'),
      returnsNormally,
    );
  });

  test('exports LogInWithFacebookCanceled', () {
    expect(
      () => LogInWithFacebookCanceled('oops'),
      returnsNormally,
    );
  });

  test('exports LogInWithTwitterFailure', () {
    expect(
      () => LogInWithTwitterFailure('oops'),
      returnsNormally,
    );
  });

  test('exports LogInWithTwitterCanceled', () {
    expect(
      () => LogInWithTwitterCanceled('oops'),
      returnsNormally,
    );
  });

  test('exports LogOutFailure', () {
    expect(
      () => LogOutFailure('oops'),
      returnsNormally,
    );
  });

  test('exports DeleteAccountFailure', () {
    expect(
      () => DeleteAccountFailure('oops'),
      returnsNormally,
    );
  });
}
