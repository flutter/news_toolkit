// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/login/login.dart';
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
    late StreamController<Uri> incomingEmailLinksController;

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

      incomingEmailLinksController = StreamController<Uri>();
      when(() => userRepository.incomingEmailLinks)
          .thenAnswer((_) => incomingEmailLinksController.stream);
    });

    test('initial state is LoginState', () {
      expect(LoginBloc(userRepository).state, LoginState());
    });

    group('EmailChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when email is invalid',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginEmailChanged(invalidEmailString)),
        expect: () => const <LoginState>[
          LoginState(email: invalidEmail, status: FormzStatus.invalid),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when email is valid',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginEmailChanged(validEmailString)),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('LoginEmailLinkSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginEmailLinkSubmitted()),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginBloc, LoginState>(
        'calls sendLoginEmailLink with correct email',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(LoginEmailLinkSubmitted()),
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
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(LoginEmailLinkSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          LoginState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
          )
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
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(LoginEmailLinkSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          LoginState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
          )
        ],
      );
    });

    group('SendEmailLinkSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(SendEmailLinkSubmitted()),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginBloc, LoginState>(
        'calls sendLoginEmailLink with correct email',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
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
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(SendEmailLinkSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          LoginState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
          )
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
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(SendEmailLinkSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          LoginState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
          )
        ],
      );
    });

    group('on incomingEmailLinks stream update', () {
      const email = 'email@example.com';

      final user = MockUser();
      final continueUrl =
          Uri.https('continue.link', '', <String, String>{'email': email});

      final validEmailLink = Uri.https(
        'email.link',
        '/email_login',
        <String, String>{'continueUrl': continueUrl.toString()},
      );

      final emailLinkWithoutContinueUrl = Uri.https(
        'email.link',
        '/email_login',
      );

      final emailLinkWithInvalidContinueUrl = Uri.https(
        'email.link',
        '/email_login',
        <String, String>{'continueUrl': Uri.https('', '').toString()},
      );

      setUp(() {
        when(() => userRepository.user)
            .thenAnswer((invocation) => Stream.value(user));

        when(
          () => userRepository.logInWithEmailLink(
            email: any(named: 'email'),
            emailLink: any(named: 'emailLink'),
          ),
        ).thenAnswer((_) async {});
      });

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when the user is already logged in',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(false);
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => incomingEmailLinksController.add(validEmailLink),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when the user is anonymous and '
        'continueUrl is missing in the email link',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) =>
            incomingEmailLinksController.add(emailLinkWithoutContinueUrl),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when the user is anonymous and '
        'invalid continueUrl is provided in the email link',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) =>
            incomingEmailLinksController.add(emailLinkWithInvalidContinueUrl),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when the user is anonymous and '
        'valid continueUrl is provided in the email link and '
        'logInWithEmailLink fails',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
          when(
            () => userRepository.logInWithEmailLink(
              email: any(named: 'email'),
              emailLink: any(named: 'emailLink'),
            ),
          ).thenThrow(Exception());
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => incomingEmailLinksController.add(validEmailLink),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionFailure)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when the user is anonymous and '
        'valid continueUrl is provided in the email link and '
        'logInWithEmailLink succeeds',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => incomingEmailLinksController.add(validEmailLink),
        expect: () => const <LoginState>[
          LoginState(status: FormzStatus.submissionInProgress),
          LoginState(status: FormzStatus.submissionSuccess)
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'calls logInWithEmailLink',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => incomingEmailLinksController.add(validEmailLink),
        verify: (_) {
          verify(
            () => userRepository.logInWithEmailLink(
              email: email,
              emailLink: validEmailLink.toString(),
            ),
          ).called(1);
        },
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

    group('close', () {
      blocTest<LoginBloc, LoginState>(
        'cancels UserRepository.incomingEmailLinks subscription',
        build: () => LoginBloc(userRepository),
        tearDown: () {
          expect(incomingEmailLinksController.hasListener, isFalse);
        },
      );
    });
  });
}
