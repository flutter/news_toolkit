import 'dart:async';

import 'package:authentication_client/authentication_client.dart';

/// {@template authentication_exception}
/// Exceptions from the authentication client.
/// {@endtemplate}
abstract class AuthenticationException implements Exception {
  /// {@macro authentication_exception}
  const AuthenticationException(this.error, this.stackTrace);

  /// The error which was caught.
  final Object error;

  /// The stack trace associated with the [error].
  final StackTrace stackTrace;
}

/// {@template sign_up_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpFailure extends AuthenticationException {
  /// {@macro sign_up_failure}
  const SignUpFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template sign_up_email_in_use_failure}
/// Thrown during the sign up process if the email is already in use.
/// {@endtemplate}
class SignUpEmailInUseFailure extends SignUpFailure {
  /// {@macro sign_up_email_in_use_failure}
  const SignUpEmailInUseFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template sign_up_invalid_email_failure}
/// Thrown during the sign up process if the email is not valid.
/// {@endtemplate}
class SignUpInvalidEmailFailure extends SignUpFailure {
  /// {@macro sign_up_invalid_email_failure}
  const SignUpInvalidEmailFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template sign_up_operation_not_allowed_failure}
/// Thrown during the sign up process if the Firebase operation is not allowed.
/// {@endtemplate}
class SignUpOperationNotAllowedFailure extends SignUpFailure {
  /// {@macro sign_up_operation_not_allowed_failure}
  const SignUpOperationNotAllowedFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template sign_up_weak_password_failure}
/// Thrown during the sign up process if the password does not meet strength
/// requirements.
/// {@endtemplate}
class SignUpWeakPasswordFailure extends SignUpFailure {
  /// {@macro sign_up_weak_password_failure}
  const SignUpWeakPasswordFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template reset_password_failure}
/// Thrown during the password reset process if a failure occurs.
/// {@endtemplate}
class ResetPasswordFailure extends AuthenticationException {
  /// {@macro reset_password_failure}
  const ResetPasswordFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template reset_password_invalid_email_failure}
/// Thrown during the reset password process if the email is not valid.
/// {@endtemplate}
class ResetPasswordInvalidEmailFailure extends ResetPasswordFailure {
  /// {@macro reset_password_invalid_email_failure}
  const ResetPasswordInvalidEmailFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template reset_password_user_not_found_failure}
/// Thrown during the reset password process if the email is not valid.
/// {@endtemplate}
class ResetPasswordUserNotFoundFailure extends ResetPasswordFailure {
  /// {@macro reset_password_user_not_found_failure}
  const ResetPasswordUserNotFoundFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login with email and password process if a failure occurs.
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure extends AuthenticationException {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template send_login_email_link_failure}
/// Thrown during the sending login email link process if a failure occurs.
/// {@endtemplate}
class SendLoginEmailLinkFailure extends AuthenticationException {
  /// {@macro send_login_email_link_failure}
  const SendLoginEmailLinkFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template is is_log_in_email_link_failure}
/// Thrown during the validation of the email link process if a failure occurs.
/// {@endtemplate}
class IsLogInWithEmailLinkFailure extends AuthenticationException {
  /// {@macro is_log_in_email_link_failure}
  const IsLogInWithEmailLinkFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_email_link_failure}
/// Thrown during the sign in with email link process if a failure occurs.
/// {@endtemplate}
class LogInWithEmailLinkFailure extends AuthenticationException {
  /// {@macro log_in_with_email_link_failure}
  const LogInWithEmailLinkFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_apple_failure}
/// Thrown during the sign in with apple process if a failure occurs.
/// {@endtemplate}
class LogInWithAppleFailure extends AuthenticationException {
  /// {@macro log_in_with_apple_failure}
  const LogInWithAppleFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with google process if a failure occurs.
/// {@endtemplate}
class LogInWithGoogleFailure extends AuthenticationException {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_google_canceled}
/// Thrown during the sign in with google process if it's canceled.
/// {@endtemplate}
class LogInWithGoogleCanceled extends AuthenticationException {
  /// {@macro log_in_with_google_canceled}
  const LogInWithGoogleCanceled(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_facebook_failure}
/// Thrown during the sign in with Facebook process if a failure occurs.
/// {@endtemplate}
class LogInWithFacebookFailure extends AuthenticationException {
  /// {@macro log_in_with_facebook_failure}
  const LogInWithFacebookFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_facebook_canceled}
/// Thrown during the sign in with Facebook process if it's canceled.
/// {@endtemplate}
class LogInWithFacebookCanceled extends AuthenticationException {
  /// {@macro log_in_with_facebook_canceled}
  const LogInWithFacebookCanceled(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_twitter_failure}
/// Thrown during the sign in with Twitter process if a failure occurs.
/// {@endtemplate}
class LogInWithTwitterFailure extends AuthenticationException {
  /// {@macro log_in_with_twitter_failure}
  const LogInWithTwitterFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_in_with_twitter_canceled}
/// Thrown during the sign in with Twitter process if it's canceled.
/// {@endtemplate}
class LogInWithTwitterCanceled extends AuthenticationException {
  /// {@macro log_in_with_twitter_canceled}
  const LogInWithTwitterCanceled(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// {@template log_out_failure}
/// Thrown during the logout process if a failure occurs.
/// {@endtemplate}
class LogOutFailure extends AuthenticationException {
  /// {@macro log_out_failure}
  const LogOutFailure(Object error, StackTrace stackTrace)
      : super(error, stackTrace);
}

/// A generic Authentication Client Interface.
abstract class AuthenticationClient {
  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.anonymous] if the user is not authenticated.
  Stream<User> get user;

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password});

  /// Sends a password reset link to the provided email
  ///
  /// Throws a [ResetPasswordFailure] if an exception occurs.
  Future<void> sendPasswordResetEmail({required String email});

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a [LogInWithAppleFailure] if an exception occurs.
  Future<void> logInWithApple();

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle();

  /// Starts the Sign In with Facebook Flow.
  ///
  /// Throws a [LogInWithFacebookFailure] if an exception occurs.
  Future<void> logInWithFacebook();

  /// Starts the Sign In with Twitter Flow.
  ///
  /// Throws a [LogInWithTwitterFailure] if an exception occurs.
  Future<void> logInWithTwitter();

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sends an authentication link to the provided [email].
  ///
  /// Opening the link should redirect to the app with [appPackageName]
  /// and authenticate the user based on the provided email link.
  ///
  /// Throws a [SendLoginEmailLinkFailure] if an exception occurs.
  Future<void> sendLoginEmailLink({
    required String email,
    required String appPackageName,
  });

  /// Checks if an incoming [emailLink] is a sign-in with email link.
  ///
  /// Throws a [IsLogInWithEmailLinkFailure] if an exception occurs.
  bool isLogInWithEmailLink({
    required String emailLink,
  });

  /// Signs in with the provided [email] and [emailLink].
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  });

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut();
}
