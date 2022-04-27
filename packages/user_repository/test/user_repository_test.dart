import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

class MockPackageInfoClient extends Mock implements PackageInfoClient {}

class MockDeepLinkClient extends Mock implements DeepLinkClient {}

class MockUser extends Mock implements User {}

class FakeSignUpFailure extends Fake implements SignUpFailure {}

class FakeResetPasswordFailure extends Fake implements ResetPasswordFailure {}

class FakeLogInWithAppleFailure extends Fake implements LogInWithAppleFailure {}

class FakeLogInWithGoogleFailure extends Fake
    implements LogInWithGoogleFailure {}

class FakeLogInWithGoogleCanceled extends Fake
    implements LogInWithGoogleCanceled {}

class FakeLogInWithTwitterFailure extends Fake
    implements LogInWithTwitterFailure {}

class FakeLogInWithTwitterCanceled extends Fake
    implements LogInWithTwitterCanceled {}

class FakeLogInWithFacebookFailure extends Fake
    implements LogInWithFacebookFailure {}

class FakeLogInWithFacebookCanceled extends Fake
    implements LogInWithFacebookCanceled {}

class FakeLogInWithEmailAndPasswordFailure extends Fake
    implements LogInWithEmailAndPasswordFailure {}

class FakeLogOutFailure extends Fake implements LogOutFailure {}

class FakeSendLoginEmailLinkFailure extends Fake
    implements SendLoginEmailLinkFailure {}

class FakeLogInWithEmailLinkFailure extends Fake
    implements LogInWithEmailLinkFailure {}

void main() {
  group('UserRepository', () {
    late AuthenticationClient authenticationClient;
    late PackageInfoClient packageInfoClient;
    late DeepLinkClient deepLinkClient;
    late StreamController<Uri> deepLinkClientController;
    late UserRepository userRepository;

    setUp(() {
      authenticationClient = MockAuthenticationClient();
      packageInfoClient = MockPackageInfoClient();
      deepLinkClient = MockDeepLinkClient();
      deepLinkClientController = StreamController<Uri>.broadcast();

      when(() => deepLinkClient.deepLinkStream)
          .thenAnswer((_) => deepLinkClientController.stream);

      userRepository = UserRepository(
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        deepLinkClient: deepLinkClient,
      );
    });

    group('user', () {
      test('calls user on AuthenticationClient', () {
        when(() => authenticationClient.user).thenAnswer(
          (_) => const Stream.empty(),
        );
        userRepository.user;
        verify(() => authenticationClient.user).called(1);
      });
    });

    group('incomingEmailLinks', () {
      final validEmailLink = Uri.https('valid.email.link', '');
      final validEmailLink2 = Uri.https('valid.email.link', '');
      final invalidEmailLink = Uri.https('invalid.email.link', '');

      test(
          'emits a new email link '
          'for every valid email link from DeepLinkClient.deepLinkStream', () {
        when(
          () => authenticationClient.isLogInWithEmailLink(
            emailLink: validEmailLink.toString(),
          ),
        ).thenReturn(true);

        when(
          () => authenticationClient.isLogInWithEmailLink(
            emailLink: validEmailLink2.toString(),
          ),
        ).thenReturn(true);

        when(
          () => authenticationClient.isLogInWithEmailLink(
            emailLink: invalidEmailLink.toString(),
          ),
        ).thenReturn(false);

        expectLater(
          userRepository.incomingEmailLinks,
          emitsInOrder(<Uri>[
            validEmailLink,
            validEmailLink2,
          ]),
        );

        deepLinkClientController
          ..add(validEmailLink)
          ..add(invalidEmailLink)
          ..add(validEmailLink2);
      });
    });

    group('signUp', () {
      test(
          'calls AuthenticationClient signUp '
          'with email and password', () async {
        when(
          () => authenticationClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
        await userRepository.signUp(
          email: 'ben_franklin@upenn.edu',
          password: 'BenFranklin123',
        );
        verify(
          () => authenticationClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
      });

      test('rethrows SignUpFailure', () async {
        final exception = FakeSignUpFailure();
        when(
          () => authenticationClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.signUp(
            email: 'ben_franklin@upenn.edu',
            password: 'BenFranklin123',
          ),
          throwsA(exception),
        );
      });

      test('throws SignUpFailure on generic exception', () async {
        when(
          () => authenticationClient.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.signUp(
            email: 'ben_franklin@upenn.edu',
            password: 'BenFranklin123',
          ),
          throwsA(isA<SignUpFailure>()),
        );
      });
    });

    group('sendPasswordResetEmail', () {
      test('calls sendPasswordResetEmail with email on AuthenticationClient',
          () async {
        when(
          () => authenticationClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async {});
        await userRepository.sendPasswordResetEmail(
          email: 'ben_franklin@upenn.edu',
        );
        verify(
          () => authenticationClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).called(1);
      });

      test('rethrows ResetPasswordFailure', () async {
        final exception = FakeResetPasswordFailure();
        when(
          () => authenticationClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.sendPasswordResetEmail(
            email: 'ben_franklin@upenn.edu',
          ),
          throwsA(exception),
        );
      });

      test('throws ResetPasswordFailure on generic exception', () async {
        when(
          () => authenticationClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.sendPasswordResetEmail(
            email: 'ben_franklin@upenn.edu',
          ),
          throwsA(isA<ResetPasswordFailure>()),
        );
      });
    });

    group('logInWithApple', () {
      test('calls logInWithApple on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithApple(),
        ).thenAnswer((_) async {});
        await userRepository.logInWithApple();
        verify(() => authenticationClient.logInWithApple()).called(1);
      });

      test('rethrows LogInWithAppleFailure', () async {
        final exception = FakeLogInWithAppleFailure();
        when(
          () => authenticationClient.logInWithApple(),
        ).thenThrow(exception);
        expect(
          () => userRepository.logInWithApple(),
          throwsA(exception),
        );
      });

      test('throws LogInWithAppleFailure on generic exception', () async {
        when(
          () => authenticationClient.logInWithApple(),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithApple(),
          throwsA(isA<LogInWithAppleFailure>()),
        );
      });
    });

    group('logInWithGoogle', () {
      test('calls logInWithGoogle on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithGoogle(),
        ).thenAnswer((_) async {});
        await userRepository.logInWithGoogle();
        verify(() => authenticationClient.logInWithGoogle()).called(1);
      });

      test('rethrows LogInWithGoogleFailure', () async {
        final exception = FakeLogInWithGoogleFailure();
        when(() => authenticationClient.logInWithGoogle()).thenThrow(exception);
        expect(() => userRepository.logInWithGoogle(), throwsA(exception));
      });

      test('rethrows LogInWithGoogleCanceled', () async {
        final exception = FakeLogInWithGoogleCanceled();
        when(() => authenticationClient.logInWithGoogle()).thenThrow(exception);
        expect(userRepository.logInWithGoogle(), throwsA(exception));
      });

      test('throws LogInWithGoogleFailure on generic exception', () async {
        when(
          () => authenticationClient.logInWithGoogle(),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithGoogle(),
          throwsA(isA<LogInWithGoogleFailure>()),
        );
      });
    });

    group('logInWithTwitter', () {
      test('calls logInWithTwitter on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithTwitter(),
        ).thenAnswer((_) async {});
        await userRepository.logInWithTwitter();
        verify(() => authenticationClient.logInWithTwitter()).called(1);
      });

      test('rethrows LogInWithTwitterFailure', () async {
        final exception = FakeLogInWithTwitterFailure();
        when(() => authenticationClient.logInWithTwitter())
            .thenThrow(exception);
        expect(() => userRepository.logInWithTwitter(), throwsA(exception));
      });

      test('rethrows LogInWithTwitterCanceled', () async {
        final exception = FakeLogInWithTwitterCanceled();
        when(() => authenticationClient.logInWithTwitter())
            .thenThrow(exception);
        expect(userRepository.logInWithTwitter(), throwsA(exception));
      });

      test('throws LogInWithTwitterFailure on generic exception', () async {
        when(
          () => authenticationClient.logInWithTwitter(),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithTwitter(),
          throwsA(isA<LogInWithTwitterFailure>()),
        );
      });
    });

    group('logInWithFacebook', () {
      test('calls logInWithFacebook on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithFacebook(),
        ).thenAnswer((_) async {});
        await userRepository.logInWithFacebook();
        verify(() => authenticationClient.logInWithFacebook()).called(1);
      });

      test('rethrows LogInWithFacebookFailure', () async {
        final exception = FakeLogInWithFacebookFailure();
        when(() => authenticationClient.logInWithFacebook())
            .thenThrow(exception);
        expect(() => userRepository.logInWithFacebook(), throwsA(exception));
      });

      test('rethrows LogInWithFacebookCanceled', () async {
        final exception = FakeLogInWithFacebookCanceled();
        when(() => authenticationClient.logInWithFacebook())
            .thenThrow(exception);
        expect(userRepository.logInWithFacebook(), throwsA(exception));
      });

      test('throws LogInWithFacebookFailure on generic exception', () async {
        when(
          () => authenticationClient.logInWithFacebook(),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithFacebook(),
          throwsA(isA<LogInWithFacebookFailure>()),
        );
      });
    });

    group('logInWithEmailAndPassword', () {
      test(
          'calls logInWithEmailAndPassWord '
          'with email and password on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
        await userRepository.logInWithEmailAndPassword(
          email: 'ben_franklin@upenn.edu',
          password: 'BenFranklin123',
        );
        verify(
          () => authenticationClient.logInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
      });

      test('rethrows LogInWithEmailAndPasswordFailure', () async {
        final exception = FakeLogInWithEmailAndPasswordFailure();
        when(
          () => authenticationClient.logInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.logInWithEmailAndPassword(
            email: 'ben_franklin@upenn.edu',
            password: 'BenFranklin123',
          ),
          throwsA(exception),
        );
      });

      test(
          'throws LogInWithEmailAndPasswordFailure '
          'on generic exception', () async {
        when(
          () => authenticationClient.logInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithEmailAndPassword(
            email: 'ben_franklin@upenn.edu',
            password: 'BenFranklin123',
          ),
          throwsA(isA<LogInWithEmailAndPasswordFailure>()),
        );
      });
    });

    group('sendLoginEmailLink', () {
      const packageName = 'appPackageName';

      setUp(() {
        when(
          () => packageInfoClient.packageName,
        ).thenReturn(packageName);
        when(
          () => authenticationClient.sendLoginEmailLink(
            email: any(named: 'email'),
            appPackageName: any(named: 'appPackageName'),
          ),
        ).thenAnswer((_) async {});
      });

      test(
          'calls sendLoginEmailLink on AuthenticationClient '
          'with email and app package name from PackageInfoClient', () async {
        await userRepository.sendLoginEmailLink(
          email: 'ben_franklin@upenn.edu',
        );

        verify(
          () => authenticationClient.sendLoginEmailLink(
            email: any(named: 'email'),
            appPackageName: packageName,
          ),
        ).called(1);
      });

      test('rethrows SendLoginEmailLinkFailure', () async {
        final exception = FakeSendLoginEmailLinkFailure();
        when(
          () => authenticationClient.sendLoginEmailLink(
            email: any(named: 'email'),
            appPackageName: any(named: 'appPackageName'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.sendLoginEmailLink(
            email: 'ben_franklin@upenn.edu',
          ),
          throwsA(exception),
        );
      });

      test(
          'throws FakeSendLoginEmailLinkFailure '
          'on generic exception', () async {
        when(
          () => authenticationClient.sendLoginEmailLink(
            email: any(named: 'email'),
            appPackageName: any(named: 'appPackageName'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.sendLoginEmailLink(
            email: 'ben_franklin@upenn.edu',
          ),
          throwsA(isA<SendLoginEmailLinkFailure>()),
        );
      });
    });

    group('logInWithEmailLink', () {
      const email = 'email@example.com';
      const emailLink = 'email.link';

      test('calls logInWithEmailLink on AuthenticationClient', () async {
        when(
          () => authenticationClient.logInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenAnswer((_) async {});

        await userRepository.logInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );

        verify(
          () => authenticationClient.logInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
        ).called(1);
      });

      test('rethrows LogInWithEmailLinkFailure', () async {
        final exception = FakeLogInWithEmailLinkFailure();
        when(
          () => authenticationClient.logInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenThrow(exception);
        expect(
          () => userRepository.logInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
          throwsA(exception),
        );
      });

      test('throws LogInWithEmailLinkFailure on generic exception', () async {
        when(
          () => authenticationClient.logInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenThrow(Exception());
        expect(
          () => userRepository.logInWithEmailLink(
            email: email,
            emailLink: emailLink,
          ),
          throwsA(isA<LogInWithEmailLinkFailure>()),
        );
      });
    });

    group('logOut', () {
      test('calls logOut on AuthenticationClient', () async {
        when(() => authenticationClient.logOut()).thenAnswer((_) async {});
        await userRepository.logOut();
        verify(() => authenticationClient.logOut()).called(1);
      });

      test('rethrows LogOutFailure', () async {
        final exception = FakeLogOutFailure();
        when(() => authenticationClient.logOut()).thenThrow(exception);
        expect(() => userRepository.logOut(), throwsA(exception));
      });

      test('throws LogOutFailure on generic exception', () async {
        when(() => authenticationClient.logOut()).thenThrow(Exception());
        expect(() => userRepository.logOut(), throwsA(isA<LogOutFailure>()));
      });
    });
  });
}
