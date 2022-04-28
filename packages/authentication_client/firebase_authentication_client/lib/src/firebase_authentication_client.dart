import 'package:authentication_client/authentication_client.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

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
    TwitterLogin? twitterLogin,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _getAppleCredentials =
            getAppleCredentials ?? SignInWithApple.getAppleIDCredential,
        _facebookAuth = facebookAuth ?? FacebookAuth.instance,
        _twitterLogin = twitterLogin ??
            TwitterLogin(
              apiKey: const String.fromEnvironment('TWITTER_API_KEY'),
              apiSecretKey: const String.fromEnvironment('TWITTER_API_SECRET'),
              redirectURI: const String.fromEnvironment('TWITTER_REDIRECT_URI'),
            );

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final GetAppleCredentials _getAppleCredentials;
  final FacebookAuth _facebookAuth;
  final TwitterLogin _twitterLogin;

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

  /// Starts the Sign In with Twitter Flow.
  ///
  /// Throws a [LogInWithTwitterCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithTwitterFailure] if an exception occurs.
  @override
  Future<void> logInWithTwitter() async {
    try {
      final loginResult = await _twitterLogin.loginV2();
      if (loginResult.status == TwitterLoginStatus.cancelledByUser) {
        throw LogInWithTwitterCanceled(
          Exception('Sign in with Twitter canceled'),
          StackTrace.current,
        );
      } else if (loginResult.status == TwitterLoginStatus.error) {
        throw LogInWithTwitterFailure(
          Exception(loginResult.errorMessage),
          StackTrace.current,
        );
      }

      final authToken = loginResult.authToken;
      final authTokenSecret = loginResult.authTokenSecret;
      if (authToken == null || authTokenSecret == null) {
        throw LogInWithTwitterFailure(
          Exception(
            'Sign in with Twitter failed due to invalid auth token or secret',
          ),
          StackTrace.current,
        );
      }

      final credential = firebase_auth.TwitterAuthProvider.credential(
        accessToken: authToken,
        secret: authTokenSecret,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on LogInWithTwitterCanceled {
      rethrow;
    } catch (error, stackTrace) {
      throw LogInWithTwitterFailure(error, stackTrace);
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
