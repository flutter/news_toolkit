// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:flutter_news_example_api/client.dart' as api;
import 'package:mocktail/mocktail.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

class MockPackageInfoClient extends Mock implements PackageInfoClient {}

class MockDeepLinkClient extends Mock implements DeepLinkClient {}

class MockUserStorage extends Mock implements UserStorage {}

class MockUser extends Mock implements AuthenticationUser {}

class MockFlutterNewsExampleApiClient extends Mock
    implements api.FlutterNewsExampleApiClient {}

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

class FakeLogOutFailure extends Fake implements LogOutFailure {}

class FakeDeleteAccountFailure extends Fake implements DeleteAccountFailure {}

class FakeSendLoginEmailLinkFailure extends Fake
    implements SendLoginEmailLinkFailure {}

class FakeLogInWithEmailLinkFailure extends Fake
    implements LogInWithEmailLinkFailure {}

void main() {
  group('UserRepository', () {
    late AuthenticationClient authenticationClient;
    late PackageInfoClient packageInfoClient;
    late DeepLinkClient deepLinkClient;
    late UserStorage storage;
    late StreamController<Uri> deepLinkClientController;
    late UserRepository userRepository;
    late MockFlutterNewsExampleApiClient apiClient;

    setUp(() {
      authenticationClient = MockAuthenticationClient();
      packageInfoClient = MockPackageInfoClient();
      deepLinkClient = MockDeepLinkClient();
      storage = MockUserStorage();
      deepLinkClientController = StreamController<Uri>.broadcast();
      apiClient = MockFlutterNewsExampleApiClient();

      when(() => deepLinkClient.deepLinkStream)
          .thenAnswer((_) => deepLinkClientController.stream);

      userRepository = UserRepository(
        apiClient: apiClient,
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        deepLinkClient: deepLinkClient,
        storage: storage,
      );
    });

    test(
        'currentSubscriptionPlan emits none '
        'when initialized and authenticationClient.user is anonymous',
        () async {
      when(() => authenticationClient.user).thenAnswer(
        (invocation) => Stream.value(AuthenticationUser.anonymous),
      );
      final response = await userRepository.user.first;
      expect(
        response.subscriptionPlan,
        equals(api.SubscriptionPlan.none),
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
      final validEmailLink = Uri.https('valid.email.link');
      final validEmailLink2 = Uri.https('valid.email.link');
      final invalidEmailLink = Uri.https('invalid.email.link');

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

    group('deleteAccount', () {
      test('calls logOut on AuthenticationClient', () async {
        when(() => authenticationClient.deleteAccount())
            .thenAnswer((_) async {});
        await userRepository.deleteAccount();
        verify(() => authenticationClient.deleteAccount()).called(1);
      });

      test('rethrows DeleteAccountFailure', () async {
        final exception = FakeDeleteAccountFailure();
        when(() => authenticationClient.deleteAccount()).thenThrow(exception);
        expect(() => userRepository.deleteAccount(), throwsA(exception));
      });

      test('throws DeleteAccountFailure on generic exception', () async {
        when(() => authenticationClient.deleteAccount()).thenThrow(Exception());
        expect(
          () => userRepository.deleteAccount(),
          throwsA(isA<DeleteAccountFailure>()),
        );
      });
    });

    group('UserFailure', () {
      final error = Exception('errorMessage');

      group('FetchAppOpenedCountFailure', () {
        test('has correct props', () {
          expect(FetchAppOpenedCountFailure(error).props, [error]);
        });
      });

      group('IncrementAppOpenedCountFailure', () {
        test('has correct props', () {
          expect(IncrementAppOpenedCountFailure(error).props, [error]);
        });
      });
    });

    group('fetchAppOpenedCount', () {
      test('returns the app opened count from UserStorage ', () async {
        when(storage.fetchAppOpenedCount).thenAnswer((_) async => 1);

        final result = await UserRepository(
          apiClient: apiClient,
          authenticationClient: authenticationClient,
          packageInfoClient: packageInfoClient,
          deepLinkClient: deepLinkClient,
          storage: storage,
        ).fetchAppOpenedCount();
        expect(result, 1);
      });

      test(
          'throws a FetchAppOpenedCountFailure '
          'when fetching app opened count fails', () async {
        when(() => storage.fetchAppOpenedCount()).thenThrow(Exception());

        expect(
          UserRepository(
            apiClient: apiClient,
            authenticationClient: authenticationClient,
            packageInfoClient: packageInfoClient,
            deepLinkClient: deepLinkClient,
            storage: storage,
          ).fetchAppOpenedCount(),
          throwsA(isA<FetchAppOpenedCountFailure>()),
        );
      });
    });

    group('setAppOpenedCount', () {
      test('increments app opened count by 1 in UserStorage', () async {
        when(() => storage.fetchAppOpenedCount()).thenAnswer((_) async => 3);

        when(
          () => storage.setAppOpenedCount(count: 4),
        ).thenAnswer((_) async {});

        await expectLater(
          UserRepository(
            apiClient: apiClient,
            authenticationClient: authenticationClient,
            packageInfoClient: packageInfoClient,
            deepLinkClient: deepLinkClient,
            storage: storage,
          ).incrementAppOpenedCount(),
          completes,
        );
      });

      test(
          'throws a IncrementAppOpenedCountFailure '
          'when setting app opened count fails', () async {
        when(
          () => storage.setAppOpenedCount(count: any(named: 'count')),
        ).thenThrow(Exception());

        expect(
          UserRepository(
            apiClient: apiClient,
            authenticationClient: authenticationClient,
            packageInfoClient: packageInfoClient,
            deepLinkClient: deepLinkClient,
            storage: storage,
          ).incrementAppOpenedCount(),
          throwsA(isA<IncrementAppOpenedCountFailure>()),
        );
      });
    });

    group('updateSubscriptionPlan', () {
      test('calls getCurrentUser on ApiClient', () async {
        when(() => apiClient.getCurrentUser()).thenAnswer(
          (_) async => api.CurrentUserResponse(
            user: api.User(
              id: 'id',
              subscription: api.SubscriptionPlan.none,
            ),
          ),
        );
        await userRepository.updateSubscriptionPlan();
        verify(() => apiClient.getCurrentUser()).called(1);
      });

      test('throws FetchCurrentSubscriptionFailure on failure', () async {
        when(
          () => apiClient.getCurrentUser(),
        ).thenThrow(Exception());
        expect(
          () => userRepository.updateSubscriptionPlan(),
          throwsA(isA<FetchCurrentSubscriptionFailure>()),
        );
      });
    });
  });
}
