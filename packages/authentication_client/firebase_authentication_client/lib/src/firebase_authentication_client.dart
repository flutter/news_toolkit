import 'package:authentication_client/authentication_client.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Signature for [SignInWithApple.getAppleIDCredential].
typedef GetAppleCredentials = Future<AuthorizationCredentialAppleID> Function({
  required List<AppleIDAuthorizationScopes> scopes,
  WebAuthenticationOptions webAuthenticationOptions,
  String nonce,
  String state,
});

/// {@template firebase_authentication_client}
/// A Firebase implementation of the [AuthenticationClient] interface.
/// {@endtemplate}
class FirebaseAuthenticationClient implements AuthenticationClient {
  /// {@macro firebase_authentication_client}
  FirebaseAuthenticationClient({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    GetAppleCredentials? getAppleCredentials,
    FacebookAuth? facebookAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _getAppleCredentials =
            getAppleCredentials ?? SignInWithApple.getAppleIDCredential,
        _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final GetAppleCredentials _getAppleCredentials;
  final FacebookAuth _facebookAuth;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.anonymous] if the user is not authenticated.
  @override
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.anonymous : firebaseUser.toUser;
    });
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws:
  /// - [SignUpEmailInUseFailure] when [email] is already in use.
  /// - [SignUpInvalidEmailFailure] when [email] is invalid.
  /// - [SignUpOperationNotAllowedFailure] when operation is not allowed.
  /// - [SignUpWeakPasswordFailure] when [password] is too weak.
  /// - [SignUpFailure] when unknown error occurs.
  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      switch (error.code) {
        case 'email-already-in-use':
          throw SignUpEmailInUseFailure(error, stackTrace);
        case 'invalid-email':
          throw SignUpInvalidEmailFailure(error, stackTrace);
        case 'operation-not-allowed':
          throw SignUpOperationNotAllowedFailure(error, stackTrace);
        case 'weak-password':
          throw SignUpWeakPasswordFailure(error, stackTrace);
        default:
          throw SignUpFailure(error, stackTrace);
      }
    } catch (error, stackTrace) {
      throw SignUpFailure(error, stackTrace);
    }
  }

  /// Sends a password reset link to the provided [email].
  ///
  /// Throws:
  /// - [ResetPasswordInvalidEmailFailure] when [email] is invalid.
  /// - [ResetPasswordUserNotFoundFailure] when user with [email] is not found.
  /// - [ResetPasswordFailure] when unknown error occurs.
  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      switch (error.code) {
        case 'invalid-email':
          throw ResetPasswordInvalidEmailFailure(error, stackTrace);
        case 'user-not-found':
          throw ResetPasswordUserNotFoundFailure(error, stackTrace);
        default:
          throw ResetPasswordFailure(error, stackTrace);
      }
    } catch (error, stackTrace) {
      throw ResetPasswordFailure(error, stackTrace);
    }
  }

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a [LogInWithAppleFailure] if an exception occurs.
  @override
  Future<void> logInWithApple() async {
    try {
      final appleIdCredential = await _getAppleCredentials(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = firebase_auth.OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (error, stackTrace) {
      throw LogInWithAppleFailure(error, stackTrace);
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  @override
  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw LogInWithGoogleCanceled(
          Exception('Sign in with Google canceled'),
          StackTrace.current,
        );
      }
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
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
  @override
  Future<void> logInWithFacebook() async {
    try {
      final loginResult = await _facebookAuth.login();
      if (loginResult.status == LoginStatus.cancelled) {
        throw LogInWithFacebookCanceled(
          Exception('Sign in with Facebook canceled'),
          StackTrace.current,
        );
      } else if (loginResult.status == LoginStatus.failed) {
        throw LogInWithFacebookFailure(
          Exception(loginResult.message),
          StackTrace.current,
        );
      }

      final accessToken = loginResult.accessToken?.token;
      if (accessToken == null) {
        throw LogInWithFacebookFailure(
          Exception(
            'Sign in with Facebook failed due to an empty access token',
          ),
          StackTrace.current,
        );
      }

      final credential =
          firebase_auth.FacebookAuthProvider.credential(accessToken);

      await _firebaseAuth.signInWithCredential(credential);
    } on LogInWithFacebookCanceled {
      rethrow;
    } catch (error, stackTrace) {
      throw LogInWithFacebookFailure(error, stackTrace);
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error, stackTrace) {
      throw LogInWithEmailAndPasswordFailure(error, stackTrace);
    }
  }

  /// Sends an authentication link to the provided [email].
  ///
  /// Opening the link redirects to the app with [appPackageName]
  /// using Firebase Dynamic Links and authenticates the user
  /// based on the provided email link.
  ///
  /// Throws a [SendLoginEmailLinkFailure] if an exception occurs.
  @override
  Future<void> sendLoginEmailLink({
    required String email,
    required String appPackageName,
  }) async {
    try {
      final redirectUrl = Uri.https(
        const String.fromEnvironment('FLAVOR_DEEP_LINK_DOMAIN'),
        const String.fromEnvironment('FLAVOR_DEEP_LINK_PATH'),
        <String, String>{'email': email},
      );

      final actionCodeSettings = firebase_auth.ActionCodeSettings(
        url: redirectUrl.toString(),
        handleCodeInApp: true,
        iOSBundleId: appPackageName,
        androidPackageName: appPackageName,
        androidInstallApp: true,
      );

      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
    } catch (error, stackTrace) {
      throw SendLoginEmailLinkFailure(error, stackTrace);
    }
  }

  /// Checks if an incoming [emailLink] is a sign-in with email link.
  ///
  /// Throws a [IsLogInWithEmailLinkFailure] if an exception occurs.
  @override
  bool isLogInWithEmailLink({required String emailLink}) {
    try {
      return _firebaseAuth.isSignInWithEmailLink(emailLink);
    } catch (error, stackTrace) {
      throw IsLogInWithEmailLinkFailure(error, stackTrace);
    }
  }

  /// Signs in with the provided [emailLink].
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  @override
  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );
    } catch (error, stackTrace) {
      throw LogInWithEmailLinkFailure(error, stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  @override
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (error, stackTrace) {
      throw LogOutFailure(error, stackTrace);
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      photo: photoURL,
      isNewUser: metadata.creationTime == metadata.lastSignInTime,
    );
  }
}
