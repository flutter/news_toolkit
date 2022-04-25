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

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _authenticationClient.signUp(
        email: email,
        password: password,
      );
    } on SignUpFailure {
      rethrow;
    } catch (error, stackTrace) {
      throw SignUpFailure(error, stackTrace);
    }
  }

  /// Sends a password reset link to the provided [email].
  ///
  /// Throws a [ResetPasswordFailure] if an exception occurs.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _authenticationClient.sendPasswordResetEmail(email: email);
    } on ResetPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      throw ResetPasswordFailure(error, stackTrace);
    }
  }

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

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on LogInWithEmailAndPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      throw LogInWithEmailAndPasswordFailure(error, stackTrace);
    }
  }

  /// Sends an authentication link to the provided [email].
  ///
  /// Throws a [SendLoginEmailLinkFailure] if an exception occurs.
  Future<void> sendLoginEmailLink({
    required String email,
  }) async {
    try {
      final packageInfo = await _packageInfoClient.fetchPackageInfo();
      await _authenticationClient.sendLoginEmailLink(
        email: email,
        appPackageName: packageInfo.packageName,
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
