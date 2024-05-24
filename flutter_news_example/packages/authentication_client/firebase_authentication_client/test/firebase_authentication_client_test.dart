// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/src/method_channel/method_channel_firebase_auth.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'
    as facebook_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:token_storage/token_storage.dart';
import 'package:twitter_login/entity/auth_result.dart' as twitter_auth;
import 'package:twitter_login/twitter_login.dart' as twitter_auth;

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase_auth.User {}

class MockUserMetadata extends Mock implements firebase_auth.UserMetadata {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

@immutable
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => 0;
}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockAuthorizationCredentialAppleID extends Mock
    implements AuthorizationCredentialAppleID {}

class MockFacebookAuth extends Mock implements facebook_auth.FacebookAuth {}

class MockFacebookLoginResult extends Mock
    implements facebook_auth.LoginResult {}

class MockFacebookAccessToken extends Mock
    implements facebook_auth.AccessToken {}

class MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

class FakeActionCodeSettings extends Fake
    implements firebase_auth.ActionCodeSettings {}

class MockTwitterLogin extends Mock implements twitter_auth.TwitterLogin {}

class MockTwitterAuthResult extends Mock implements twitter_auth.AuthResult {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const options = FirebaseOptions(
    apiKey: 'apiKey',
    appId: 'appId',
    messagingSenderId: 'messagingSenderId',
    projectId: 'projectId',
  );

  const email = 'test@gmail.com';
  const emailLink = 'https://email.page.link';
  const appPackageName = 'app.package.name';

  group('FirebaseAuthenticationClient', () {
    late TokenStorage tokenStorage;
    late firebase_auth.FirebaseAuth firebaseAuth;
    late GoogleSignIn googleSignIn;
    late FirebaseAuthenticationClient firebaseAuthenticationClient;
    late AuthorizationCredentialAppleID authorizationCredentialAppleID;
    late GetAppleCredentials getAppleCredentials;
    late List<List<AppleIDAuthorizationScopes>> getAppleCredentialsCalls;
    late facebook_auth.FacebookAuth facebookAuth;
    late twitter_auth.TwitterLogin twitterLogin;

    late StreamController<firebase_auth.User?> authStateChangesController;

    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
      registerFallbackValue(FakeActionCodeSettings());
    });

    setUp(() {
      final platformApp = FirebaseAppPlatform(defaultFirebaseAppName, options);
      final firebaseCore = MockFirebaseCore();

      when(() => firebaseCore.apps).thenReturn([platformApp]);
      when(firebaseCore.app).thenReturn(platformApp);
      when(
        () => firebaseCore.initializeApp(
          name: defaultFirebaseAppName,
          options: options,
        ),
      ).thenAnswer((_) async => platformApp);

      Firebase.delegatePackingProperty = firebaseCore;

      tokenStorage = MockTokenStorage();
      firebaseAuth = MockFirebaseAuth();
      googleSignIn = MockGoogleSignIn();
      authorizationCredentialAppleID = MockAuthorizationCredentialAppleID();
      getAppleCredentialsCalls = <List<AppleIDAuthorizationScopes>>[];
      getAppleCredentials = ({
        List<AppleIDAuthorizationScopes> scopes = const [],
        WebAuthenticationOptions? webAuthenticationOptions,
        String? nonce,
        String? state,
      }) async {
        getAppleCredentialsCalls.add(scopes);
        return authorizationCredentialAppleID;
      };
      facebookAuth = MockFacebookAuth();
      twitterLogin = MockTwitterLogin();

      authStateChangesController =
          StreamController<firebase_auth.User?>.broadcast();
      when(firebaseAuth.authStateChanges)
          .thenAnswer((_) => authStateChangesController.stream);

      when(() => tokenStorage.saveToken(any())).thenAnswer((_) async {});
      when(tokenStorage.clearToken).thenAnswer((_) async {});

      firebaseAuthenticationClient = FirebaseAuthenticationClient(
        tokenStorage: tokenStorage,
        firebaseAuth: firebaseAuth,
        googleSignIn: googleSignIn,
        getAppleCredentials: getAppleCredentials,
        facebookAuth: facebookAuth,
        twitterLogin: twitterLogin,
      );
    });

    testWidgets(
      'creates FirebaseAuth instance internally when not injected',
      (tester) async {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          MethodChannelFirebaseAuth.channel,
          (call) async {
            if (call.method == 'Auth#registerIdTokenListener' ||
                call.method == 'Auth#registerAuthStateListener') {
              return 'mockAuthChannel';
            }
            return null;
          },
        );

        expect(
          () => FirebaseAuthenticationClient(tokenStorage: tokenStorage),
          isNot(throwsException),
        );
      },
    );

    group('logInWithApple', () {
      setUp(() {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(MockUserCredential()));
        when(() => authorizationCredentialAppleID.identityToken).thenReturn('');
        when(() => authorizationCredentialAppleID.authorizationCode)
            .thenReturn('');
      });

      test('calls getAppleCredentials with correct scopes', () async {
        await firebaseAuthenticationClient.logInWithApple();
        expect(getAppleCredentialsCalls, [
          [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ]
        ]);
      });

      test('calls signInWithCredential with correct credential', () async {
        const identityToken = 'identity-token';
        const accessToken = 'access-token';
        when(() => authorizationCredentialAppleID.identityToken)
            .thenReturn(identityToken);
        when(() => authorizationCredentialAppleID.authorizationCode)
            .thenReturn(accessToken);
        await firebaseAuthenticationClient.logInWithApple();
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('throws LogInWithAppleFailure when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(
          () => firebaseAuthenticationClient.logInWithApple(),
          throwsA(isA<LogInWithAppleFailure>()),
        );
      });
    });

    group('logInWithGoogle', () {
      const accessToken = 'access-token';
      const idToken = 'id-token';

      setUp(() {
        final googleSignInAuthentication = MockGoogleSignInAuthentication();
        final googleSignInAccount = MockGoogleSignInAccount();
        when(() => googleSignInAuthentication.accessToken)
            .thenReturn(accessToken);
        when(() => googleSignInAuthentication.idToken).thenReturn(idToken);
        when(() => googleSignInAccount.authentication)
            .thenAnswer((_) async => googleSignInAuthentication);
        when(() => googleSignIn.signIn())
            .thenAnswer((_) async => googleSignInAccount);
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signIn authentication, and signInWithCredential', () async {
        await firebaseAuthenticationClient.logInWithGoogle();
        verify(() => googleSignIn.signIn()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('succeeds when signIn succeeds', () {
        expect(firebaseAuthenticationClient.logInWithGoogle(), completes);
      });

      test('throws LogInWithGoogleFailure when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(
          firebaseAuthenticationClient.logInWithGoogle(),
          throwsA(isA<LogInWithGoogleFailure>()),
        );
      });

      test('throws LogInWithGoogleCanceled when signIn returns null', () async {
        when(() => googleSignIn.signIn()).thenAnswer((_) async => null);
        expect(
          firebaseAuthenticationClient.logInWithGoogle(),
          throwsA(isA<LogInWithGoogleCanceled>()),
        );
      });
    });

    group('logInWithFacebook', () {
      late facebook_auth.LoginResult loginResult;
      late facebook_auth.AccessToken accessTokenResult;
      const accessToken = 'access-token';

      setUp(() {
        loginResult = MockFacebookLoginResult();
        accessTokenResult = MockFacebookAccessToken();

        when(() => accessTokenResult.tokenString).thenReturn(accessToken);
        when(() => loginResult.accessToken).thenReturn(accessTokenResult);
        when(() => loginResult.status)
            .thenReturn(facebook_auth.LoginStatus.success);
        when(() => facebookAuth.login()).thenAnswer((_) async => loginResult);
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls login authentication and signInWithCredential', () async {
        await firebaseAuthenticationClient.logInWithFacebook();
        verify(() => facebookAuth.login()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('succeeds when login succeeds', () {
        expect(firebaseAuthenticationClient.logInWithFacebook(), completes);
      });

      test(
          'throws LogInWithFacebookFailure '
          'when signInWithCredential throws', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(
          firebaseAuthenticationClient.logInWithFacebook(),
          throwsA(isA<LogInWithFacebookFailure>()),
        );
      });

      test(
          'throws LogInWithFacebookFailure '
          'when login result status is failed', () async {
        when(() => loginResult.status)
            .thenReturn(facebook_auth.LoginStatus.failed);
        expect(
          firebaseAuthenticationClient.logInWithFacebook(),
          throwsA(isA<LogInWithFacebookFailure>()),
        );
      });

      test(
          'throws LogInWithFacebookFailure '
          'when login result access token is empty', () async {
        when(() => loginResult.accessToken).thenReturn(null);
        expect(
          firebaseAuthenticationClient.logInWithFacebook(),
          throwsA(isA<LogInWithFacebookFailure>()),
        );
      });

      test(
          'throws LogInWithFacebookCanceled '
          'when login result status is cancelled', () async {
        when(() => loginResult.status)
            .thenReturn(facebook_auth.LoginStatus.cancelled);
        expect(
          firebaseAuthenticationClient.logInWithFacebook(),
          throwsA(isA<LogInWithFacebookCanceled>()),
        );
      });
    });

    group('logInWithTwitter', () {
      late twitter_auth.AuthResult loginResult;
      const accessToken = 'access-token';
      const secret = 'secret';

      setUp(() {
        loginResult = MockTwitterAuthResult();

        when(() => loginResult.authToken).thenReturn(accessToken);
        when(() => loginResult.authTokenSecret).thenReturn(secret);
        when(() => loginResult.status)
            .thenReturn(twitter_auth.TwitterLoginStatus.loggedIn);
        when(() => twitterLogin.loginV2()).thenAnswer((_) async => loginResult);
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls loginV2 authentication and signInWithCredential', () async {
        await firebaseAuthenticationClient.logInWithTwitter();
        verify(() => twitterLogin.loginV2()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('succeeds when login succeeds', () {
        expect(firebaseAuthenticationClient.logInWithTwitter(), completes);
      });

      test(
          'throws LogInWithTwitterFailure '
          'when signInWithCredential throws', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(
          firebaseAuthenticationClient.logInWithTwitter(),
          throwsA(isA<LogInWithTwitterFailure>()),
        );
      });

      test(
          'throws LogInWithTwitterFailure '
          'when login result status is error', () async {
        when(() => loginResult.status)
            .thenReturn(twitter_auth.TwitterLoginStatus.error);
        expect(
          firebaseAuthenticationClient.logInWithTwitter(),
          throwsA(isA<LogInWithTwitterFailure>()),
        );
      });

      test(
          'throws LogInWithTwitterFailure '
          'when login result auth token is empty', () async {
        when(() => loginResult.authToken).thenReturn(null);
        expect(
          firebaseAuthenticationClient.logInWithTwitter(),
          throwsA(isA<LogInWithTwitterFailure>()),
        );
      });

      test(
          'throws LogInWithTwitterFailure '
          'when login result auth token secret is empty', () async {
        when(() => loginResult.authTokenSecret).thenReturn(null);
        expect(
          firebaseAuthenticationClient.logInWithTwitter(),
          throwsA(isA<LogInWithTwitterFailure>()),
        );
      });

      test(
          'throws LogInWithTwitterCanceled '
          'when login result status is cancelledByUser', () async {
        when(() => loginResult.status)
            .thenReturn(twitter_auth.TwitterLoginStatus.cancelledByUser);
        expect(
          firebaseAuthenticationClient.logInWithTwitter(),
          throwsA(isA<LogInWithTwitterCanceled>()),
        );
      });
    });

    group('sendLoginEmailLink', () {
      setUp(() {
        when(
          () => firebaseAuth.sendSignInLinkToEmail(
            email: any(named: 'email'),
            actionCodeSettings: any(named: 'actionCodeSettings'),
          ),
        ).thenAnswer((_) async {});
      });

      test('calls sendSignInLinkToEmail', () async {
        await firebaseAuthenticationClient.sendLoginEmailLink(
          email: email,
          appPackageName: appPackageName,
        );

        verify(
          () => firebaseAuth.sendSignInLinkToEmail(
            email: email,
            actionCodeSettings: any(
              named: 'actionCodeSettings',
              that: isA<firebase_auth.ActionCodeSettings>()
                  .having(
                    (settings) => settings.androidPackageName,
                    'androidPackageName',
                    equals(appPackageName),
                  )
                  .having(
                    (settings) => settings.iOSBundleId,
                    'iOSBundleId',
                    equals(appPackageName),
                  )
                  .having(
                    (settings) => settings.androidInstallApp,
                    'androidInstallApp',
                    isTrue,
                  )
                  .having(
                    (settings) => settings.handleCodeInApp,
                    'handleCodeInApp',
                    isTrue,
                  ),
            ),
          ),
        ).called(1);
      });

      test('succeeds when sendSignInLinkToEmail succeeds', () async {
        expect(
          firebaseAuthenticationClient.sendLoginEmailLink(
            email: email,
            appPackageName: appPackageName,
          ),
          completes,
        );
      });

      test(
          'throws SendLoginEmailLinkFailure '
          'when sendSignInLinkToEmail throws', () async {
        when(
          () => firebaseAuth.sendSignInLinkToEmail(
            email: any(named: 'email'),
            actionCodeSettings: any(named: 'actionCodeSettings'),
          ),
        ).thenThrow(Exception());
        expect(
          firebaseAuthenticationClient.sendLoginEmailLink(
            email: email,
            appPackageName: appPackageName,
          ),
          throwsA(isA<SendLoginEmailLinkFailure>()),
        );
      });
    });

    group('isLogInWithEmailLink', () {
      setUp(() {
        when(
          () => firebaseAuth.isSignInWithEmailLink(any()),
        ).thenAnswer((_) => true);
      });

      test('calls isSignInWithEmailLink', () {
        firebaseAuthenticationClient.isLogInWithEmailLink(
          emailLink: emailLink,
        );
        verify(
          () => firebaseAuth.isSignInWithEmailLink(emailLink),
        ).called(1);
      });

      test('succeeds when isSignInWithEmailLink succeeds', () async {
        expect(
          firebaseAuthenticationClient.isLogInWithEmailLink(
            emailLink: emailLink,
          ),
          isTrue,
        );
      });

      test(
          'throws IsLogInWithEmailLinkFailure '
          'when isSignInWithEmailLink throws', () async {
        when(
          () => firebaseAuth.isSignInWithEmailLink(any()),
        ).thenThrow(Exception());
        expect(
          () => firebaseAuthenticationClient.isLogInWithEmailLink(
            emailLink: emailLink,
          ),
          throwsA(isA<IsLogInWithEmailLinkFailure>()),
        );
      });
    });

    group('logInWithEmailLink', () {
      setUp(() {
        when(
          () => firebaseAuth.signInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signInWithEmailLink', () async {
        await firebaseAuthenticationClient.logInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );
        verify(
          () => firebaseAuth.signInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
        ).called(1);
      });

      test('succeeds when signInWithEmailLink succeeds', () async {
        expect(
          firebaseAuthenticationClient.logInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
          completes,
        );
      });

      test(
          'throws LogInWithEmailLinkFailure '
          'when signInWithEmailLink throws', () async {
        when(
          () => firebaseAuth.signInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenThrow(Exception());
        expect(
          firebaseAuthenticationClient.logInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
          throwsA(isA<LogInWithEmailLinkFailure>()),
        );
      });
    });

    group('logOut', () {
      test('calls signOut', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
        await firebaseAuthenticationClient.logOut();
        verify(() => firebaseAuth.signOut()).called(1);
        verify(() => googleSignIn.signOut()).called(1);
      });

      test('throws LogOutFailure when signOut throws', () async {
        when(() => firebaseAuth.signOut()).thenThrow(Exception());
        expect(
          firebaseAuthenticationClient.logOut(),
          throwsA(isA<LogOutFailure>()),
        );
      });
    });

    group('deleteAccount', () {
      test('calls deleteAccount', () async {
        final firebaseUser = MockFirebaseUser();
        when(firebaseUser.delete).thenAnswer((_) async {});
        when(() => firebaseAuth.currentUser).thenReturn(firebaseUser);

        await firebaseAuthenticationClient.deleteAccount();
        verify(() => firebaseAuth.currentUser).called(1);
        verify(firebaseUser.delete).called(1);
      });

      test('throws DeleteAccountFailure if current user is null', () async {
        when(() => firebaseAuth.currentUser).thenReturn(null);

        expect(
          firebaseAuthenticationClient.deleteAccount(),
          throwsA(isA<DeleteAccountFailure>()),
        );
      });

      test('throws DeleteAccountFailure when deleteAccount throws', () async {
        final firebaseUser = MockFirebaseUser();
        when(firebaseUser.delete).thenThrow(Exception());
        when(() => firebaseAuth.currentUser).thenReturn(firebaseUser);

        expect(
          firebaseAuthenticationClient.deleteAccount(),
          throwsA(isA<DeleteAccountFailure>()),
        );
      });
    });

    group('user', () {
      const userId = 'mock-uid';
      const email = 'mock-email';
      const newUser = AuthenticationUser(id: userId, email: email);
      const returningUser =
          AuthenticationUser(id: userId, email: email, isNewUser: false);

      test('emits anonymous user when firebase user is null', () async {
        when(firebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.value(null));
        await expectLater(
          firebaseAuthenticationClient.user,
          emitsInOrder(
            const <AuthenticationUser>[AuthenticationUser.anonymous],
          ),
        );
      });

      test('emits new user when firebase user is not null', () async {
        final firebaseUser = MockFirebaseUser();
        final userMetadata = MockUserMetadata();
        final creationTime = DateTime(2020);
        when(() => firebaseUser.uid).thenReturn(userId);
        when(() => firebaseUser.email).thenReturn(email);
        when(() => userMetadata.creationTime).thenReturn(creationTime);
        when(() => userMetadata.lastSignInTime).thenReturn(creationTime);
        when(() => firebaseUser.photoURL).thenReturn(null);
        when(() => firebaseUser.metadata).thenReturn(userMetadata);
        when(firebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.value(firebaseUser));
        await expectLater(
          firebaseAuthenticationClient.user,
          emitsInOrder(const <AuthenticationUser>[newUser]),
        );
      });

      test('emits returningUser user when firebase user is not null', () async {
        final firebaseUser = MockFirebaseUser();
        final userMetadata = MockUserMetadata();
        final creationTime = DateTime(2020);
        final lastSignInTime = DateTime(2019);
        when(() => firebaseUser.uid).thenReturn(userId);
        when(() => firebaseUser.email).thenReturn(email);
        when(() => userMetadata.creationTime).thenReturn(creationTime);
        when(() => userMetadata.lastSignInTime).thenReturn(lastSignInTime);
        when(() => firebaseUser.photoURL).thenReturn(null);
        when(() => firebaseUser.metadata).thenReturn(userMetadata);
        when(firebaseAuth.authStateChanges)
            .thenAnswer((_) => Stream.value(firebaseUser));
        await expectLater(
          firebaseAuthenticationClient.user,
          emitsInOrder(const <AuthenticationUser>[returningUser]),
        );
      });

      test(
          'calls saveToken on TokenStorage '
          'when user changes to authenticated', () async {
        final firebaseUser = MockFirebaseUser();
        final userMetadata = MockUserMetadata();
        final creationTime = DateTime(2020);
        final lastSignInTime = DateTime(2019);
        when(() => firebaseUser.uid).thenReturn(userId);
        when(() => firebaseUser.email).thenReturn(email);
        when(() => userMetadata.creationTime).thenReturn(creationTime);
        when(() => userMetadata.lastSignInTime).thenReturn(lastSignInTime);
        when(() => firebaseUser.photoURL).thenReturn(null);
        when(() => firebaseUser.metadata).thenReturn(userMetadata);

        authStateChangesController.add(firebaseUser);
        await Future.microtask(() {});
        verify(() => tokenStorage.saveToken(userId)).called(1);
        verifyNever(tokenStorage.clearToken);
      });

      test(
          'calls clearToken on TokenStorage '
          'when user changes to unauthenticated', () async {
        authStateChangesController.add(null);
        await Future.microtask(() {});
        verify(tokenStorage.clearToken).called(1);
        verifyNever(() => tokenStorage.saveToken(any()));
      });
    });
  });
}
