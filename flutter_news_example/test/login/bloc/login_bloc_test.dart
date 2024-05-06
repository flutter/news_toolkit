// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  group('LoginBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
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
      when(
        () => userRepository.sendLoginEmailLink(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is LoginState', () {
      expect(LoginBloc(userRepository: userRepository).state, LoginState());
    });

    group('EmailChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when email is invalid',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginEmailChanged(invalidEmailString)),
        expect: () => const <LoginState>[
          LoginState(email: invalidEmail),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when email is valid',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginEmailChanged(validEmailString)),
        expect: () => const <LoginState>[
          LoginState(email: validEmail, valid: true),
        ],
      );
    });

    group('SendEmailLinkSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SendEmailLinkSubmitted()),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginBloc, LoginState>(
        'calls sendLoginEmailLink with correct email',
        build: () => LoginBloc(userRepository: userRepository),
        seed: () => LoginState(email: validEmail, valid: true),
        act: (bloc) => bloc.add(SendEmailLinkSubmitted()),
        verify: (_) {
          verify(
            () => userRepository.sendLoginEmailLink(
              email: validEmailString,
            ),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when sendLoginEmailLink succeeds',
        build: () => LoginBloc(userRepository: userRepository),
        seed: () => LoginState(email: validEmail, valid: true),
        act: (bloc) => bloc.add(SendEmailLinkSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            valid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.success,
            email: validEmail,
            valid: true,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when sendLoginEmailLink fails',
        setUp: () {
          when(
            () => userRepository.sendLoginEmailLink(
              email: any(named: 'email'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository: userRepository),
        seed: () => LoginState(email: validEmail, valid: true),
        act: (bloc) => bloc.add(SendEmailLinkSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            valid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.failure,
            email: validEmail,
            valid: true,
          ),
        ],
      );
    });

    group('LoginGoogleSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithGoogle',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithGoogle()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithGoogle succeeds',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success),
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
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionCanceled] '
        'when logInWithGoogle is canceled',
        setUp: () {
          when(
            () => userRepository.logInWithGoogle(),
          ).thenThrow(LogInWithGoogleCanceled(Exception()));
        },
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.canceled),
        ],
      );
    });

    group('LoginTwitterSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithTwitter',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginTwitterSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithTwitter()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithTwitter succeeds',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginTwitterSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success),
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
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginTwitterSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionCanceled] '
        'when logInWithTwitter is canceled',
        setUp: () {
          when(
            () => userRepository.logInWithTwitter(),
          ).thenThrow(
            LogInWithTwitterCanceled(Exception()),
          );
        },
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginTwitterSubmitted()),
        expect: () => <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.canceled),
        ],
      );
    });

    group('LoginFacebookSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithFacebook',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginFacebookSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithFacebook()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithFacebook succeeds',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginFacebookSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success),
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
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginFacebookSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionCanceled] '
        'when logInWithFacebook is canceled',
        setUp: () {
          when(
            () => userRepository.logInWithFacebook(),
          ).thenThrow(
            LogInWithFacebookCanceled(Exception()),
          );
        },
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginFacebookSubmitted()),
        expect: () => <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.canceled),
        ],
      );
    });

    group('LogInWithAppleSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithApple',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithApple()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithApple succeeds',
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success),
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
        build: () => LoginBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure),
        ],
      );
    });
  });
}
