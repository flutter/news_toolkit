// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/login/login.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = LoginPassword.dirty(invalidPasswordString);

  const validPasswordString = 'password';
  const validPassword = LoginPassword.dirty(validPasswordString);

  group('LoginBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
      when(
        () => userRepository.logInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future<void>.value());
      when(
        () => userRepository.logInWithGoogle(),
      ).thenAnswer((_) => Future<void>.value());
      when(
        () => userRepository.logInWithTwitter(),
      ).thenAnswer((_) => Future<void>.value());
      when(
        () => userRepository.logInWithFacebook(),
      ).thenAnswer((_) => Future<void>.value());
      when(
        () => userRepository.logInWithApple(),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is LoginState', () {
      expect(LoginBloc(userRepository).state, LoginState());
    });

    group('EmailChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginEmailChanged(invalidEmailString)),
        expect: () => const <LoginState>[
          LoginState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(password: validPassword),
        act: (bloc) => bloc.add(LoginEmailChanged(validEmailString)),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('PasswordChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginPasswordChanged(invalidPasswordString)),
        expect: () => const <LoginState>[
          LoginState(
            password: invalidPassword,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(email: validEmail),
        act: (bloc) => bloc.add(LoginPasswordChanged(validPasswordString)),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('LogInWithCredentialsSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginCredentialsSubmitted()),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginBloc, LoginState>(
        'calls logInWithEmailAndPassword with correct email/password',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (bloc) => bloc.add(LoginCredentialsSubmitted()),
        verify: (_) {
          verify(
            () => userRepository.logInWithEmailAndPassword(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithEmailAndPassword succeeds',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (bloc) => bloc.add(LoginCredentialsSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
          ),
          LoginState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
            password: validPassword,
          )
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails',
        setUp: () {
          when(
            () => userRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
          password: validPassword,
        ),
        act: (bloc) => bloc.add(LoginCredentialsSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
            password: validPassword,
          ),
          LoginState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
            password: validPassword,
          )
        ],
      );
    });

    group('LoginGoogleSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithGoogle',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithGoogle()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithGoogle succeeds',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionSuccess)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithGoogle fails',
        setUp: () {
          when(
            () => userRepository.logInWithGoogle(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionCanceled] '
        'when logInWithGoogle is canceled',
        setUp: () {
          when(
            () => userRepository.logInWithGoogle(),
          ).thenThrow(LogInWithGoogleCanceled(Exception(), StackTrace.current));
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionCanceled),
        ],
      );
    });

    group('LoginTwitterSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithTwitter',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginTwitterSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithTwitter()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithTwitter succeeds',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginTwitterSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionSuccess)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithTwitter fails',
        setUp: () {
          when(
            () => userRepository.logInWithTwitter(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginTwitterSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionCanceled] '
        'when logInWithTwitter is canceled',
        setUp: () {
          when(
            () => userRepository.logInWithTwitter(),
          ).thenThrow(
            LogInWithTwitterCanceled(Exception(), StackTrace.current),
          );
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginTwitterSubmitted()),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionCanceled),
        ],
      );
    });

    group('LoginFacebookSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithFacebook',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginFacebookSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithFacebook()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithFacebook succeeds',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginFacebookSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionSuccess)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithFacebook fails',
        setUp: () {
          when(
            () => userRepository.logInWithFacebook(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginFacebookSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionCanceled] '
        'when logInWithFacebook is canceled',
        setUp: () {
          when(
            () => userRepository.logInWithFacebook(),
          ).thenThrow(
            LogInWithFacebookCanceled(Exception(), StackTrace.current),
          );
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginFacebookSubmitted()),
        expect: () => <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionCanceled),
        ],
      );
    });

    group('LogInWithAppleSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithApple',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithApple()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithApple succeeds',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionSuccess)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithApple fails',
        setUp: () {
          when(
            () => userRepository.logInWithApple(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );
    });
  });
}
