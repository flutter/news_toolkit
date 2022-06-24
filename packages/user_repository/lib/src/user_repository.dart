import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:storage/storage.dart';

part 'user_storage.dart';

/// {@template user_failure}
/// A base failure for the user repository failures.
/// {@endtemplate}
abstract class UserFailure with EquatableMixin implements Exception {
  /// {@macro user_failure}
  const UserFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template fetch_number_of_times_app_opened_failure}
/// Thrown when fetching the number of times open app fails.
/// {@endtemplate}
class FetchNumberOfTimesAppOpenedFailure extends UserFailure {
  /// {@macro fetch_number_of_times_app_opened_failure}
  const FetchNumberOfTimesAppOpenedFailure(super.error);
}

/// {@template increment_number_of_times_app_opened_failure}
/// Thrown when incrementing the number of times open app fails.
/// {@endtemplate}
class IncrementNumberOfTimesAppOpenedFailure extends UserFailure {
  /// {@macro increment_number_of_times_app_opened_failure}
  const IncrementNumberOfTimesAppOpenedFailure(super.error);
}

/// {@template user_repository}
/// Repository which manages the user domain.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required AuthenticationClient authenticationClient,
    required PackageInfoClient packageInfoClient,
    required DeepLinkClient deepLinkClient,
    required UserStorage storage,
  })  : _authenticationClient = authenticationClient,
        _packageInfoClient = packageInfoClient,
        _deepLinkClient = deepLinkClient,
        _storage = storage;

  final AuthenticationClient _authenticationClient;
  final PackageInfoClient _packageInfoClient;
  final DeepLinkClient _deepLinkClient;
  final UserStorage _storage;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.anonymous] if the user is not authenticated.
  Stream<User> get user => _authenticationClient.user;

  /// A stream of incoming email links used to authenticate the user.
  ///
  /// Emits when a new email link is emitted on [DeepLinkClient.deepLinkStream],
  /// which is validated using [AuthenticationClient.isLogInWithEmailLink].
  Stream<Uri> get incomingEmailLinks => _deepLinkClient.deepLinkStream.where(
        (deepLink) => _authenticationClient.isLogInWithEmailLink(
          emailLink: deepLink.toString(),
        ),
      );

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a [LogInWithAppleFailure] if an exception occurs.
  Future<void> logInWithApple() async {
    try {
      await _authenticationClient.logInWithApple();
    } on LogInWithAppleFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithAppleFailure(error), stackTrace);
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
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
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
      Error.throwWithStackTrace(LogInWithTwitterFailure(error), stackTrace);
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
      Error.throwWithStackTrace(LogInWithFacebookFailure(error), stackTrace);
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
      Error.throwWithStackTrace(SendLoginEmailLinkFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [email] and [emailLink].
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    try {
      await _authenticationClient.logInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );
    } on LogInWithEmailLinkFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
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
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Returns the number of times app is opened.
  ///
  /// This method will only be used when the user is anonymous.
  Future<int> fetchNumberOfTimesAppOpened() async {
    try {
      return await _storage.fetchAppOpenedCount();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchNumberOfTimesAppOpenedFailure(error),
        stackTrace,
      );
    }
  }

  /// Set the value of number of times the app is opened
  /// when this value is less or equal to five.
  ///
  /// This method will only be used when the user is anonymous.
  Future<void> incrementNumberOfTimesAppOpened() async {
    try {
      final value = await fetchNumberOfTimesAppOpened();
      final result = value + 1;

      await _storage.setAppOpenedCount(count: result);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        IncrementNumberOfTimesAppOpenedFailure(error),
        stackTrace,
      );
    }
  }
}
