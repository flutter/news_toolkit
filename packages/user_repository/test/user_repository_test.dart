import 'package:authentication_client/authentication_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

class FakeSignUpFailure extends Fake implements SignUpFailure {}

class FakeResetPasswordFailure extends Fake implements ResetPasswordFailure {}

class FakeLogInWithAppleFailure extends Fake implements LogInWithAppleFailure {}

class FakeLogInWithGoogleFailure extends Fake
    implements LogInWithGoogleFailure {}

class FakeLogInWithGoogleCanceled extends Fake
    implements LogInWithGoogleCanceled {}

class FakeLogInWithEmailAndPasswordFailure extends Fake
    implements LogInWithEmailAndPasswordFailure {}

class FakeLogOutFailure extends Fake implements LogOutFailure {}

void main() {
  group('UserRepository', () {
    late AuthenticationClient authenticationClient;
    late UserRepository userRepository;

    setUp(() {
      authenticationClient = MockAuthenticationClient();
      userRepository = UserRepository(
        authenticationClient: authenticationClient,
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

    group('logInWithEmailAndPassWord', () {
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
