import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:package_info_client/package_info_client.dart';

/// {@template user_repository}
/// Repository which manages the user domain.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required AuthenticationClient authenticationClient,
    required PackageInfoClient packageInfoClient,
  })  : _authenticationClient = authenticationClient,
        _packageInfoClient = packageInfoClient;

  final AuthenticationClient _authenticationClient;
  final PackageInfoClient _packageInfoClient;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.anonymous] if the user is not authenticated.
  Stream<User> get user => _authenticationClient.user;

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a [LogInWithAppleFailure] if an exception occurs.
  Future<void> logInWithApple() async {
    try {
      await _authenticationClient.logInWithApple();
    } on LogInWithAppleFailure {
      rethrow;
    } catch (error, stackTrace) {
      throw LogInWithAppleFailure(error, stackTrace);
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      await _authenticationClient.logInWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      throw LogInWithGoogleFailure(error, stackTrace);
    }
  }

  /// Starts the Sign In with Twitter Flow.
  ///
  /// Throws a [LogInWithTwitterCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithTwitterFailure] if an exception occurs.
  Future<void> logInWithTwitter() async {
    try {
      await _authenticationClient.logInWithTwitter();
    } on LogInWithTwitterFailure {
      rethrow;
    } on LogInWithTwitterCanceled {
      rethrow;
    } catch (error, stackTrace) {
      throw LogInWithTwitterFailure(error, stackTrace);
    }
  }

  /// Starts the Sign In with Facebook Flow.
  ///
  /// Throws a [LogInWithFacebookCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithFacebookFailure] if an exception occurs.
  Future<void> logInWithFacebook() async {
    try {
      await _authenticationClient.logInWithFacebook();
    } on LogInWithFacebookFailure {
      rethrow;
    } on LogInWithFacebookCanceled {
      rethrow;
    } catch (error, stackTrace) {
      throw LogInWithFacebookFailure(error, stackTrace);
    }
  }

  /// Sends an authentication link to the provided [email].
  ///
  /// Throws a [SendLoginEmailLinkFailure] if an exception occurs.
  Future<void> sendLoginEmailLink({
    required String email,
  }) async {
    try {
      await _authenticationClient.sendLoginEmailLink(
        email: email,
        appPackageName: _packageInfoClient.packageName,
      );
    } on SendLoginEmailLinkFailure {
      rethrow;
    } catch (error, stackTrace) {
      throw SendLoginEmailLinkFailure(error, stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (error, stackTrace) {
      throw LogOutFailure(error, stackTrace);
    }
  }
}
