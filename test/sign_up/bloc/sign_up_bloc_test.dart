// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/sign_up/sign_up.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  group('SignUpBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();
      when(
        () => userRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is SignUpState', () {
      expect(SignUpBloc(userRepository).state, SignUpState());
    });

    group('SignUpEmailChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits [invalid] when email is invalid',
        build: () => SignUpBloc(userRepository),
        act: (bloc) => bloc.add(SignUpEmailChanged(invalidEmailString)),
        expect: () => const <SignUpState>[
          SignUpState(
            email: invalidEmail,
            status: FormzStatus.invalid,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [valid] when email is valid and show delete icon',
        build: () => SignUpBloc(userRepository),
        act: (bloc) => bloc.add(SignUpEmailChanged(validEmailString)),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            status: FormzStatus.valid,
          ),
        ],
      );
    });

    group('SignUpSubmitted', () {
      blocTest<SignUpBloc, SignUpState>(
        'does nothing when status is not validated',
        build: () => SignUpBloc(userRepository),
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => const <SignUpState>[],
      );

      blocTest<SignUpBloc, SignUpState>(
        'calls signUp with correct email',
        build: () => SignUpBloc(userRepository),
        seed: () => SignUpState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(SignUpSubmitted()),
        verify: (_) {
          verify(
            () => userRepository.signUp(
              email: validEmailString,
              password: '',
            ),
          ).called(1);
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when signUp succeeds',
        build: () => SignUpBloc(userRepository),
        seed: () => SignUpState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => const <SignUpState>[
          SignUpState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          SignUpState(
            status: FormzStatus.submissionSuccess,
            email: validEmail,
          )
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [submissionInProgress, submissionFailure] '
        'when signUp fails',
        setUp: () {
          when(
            () => userRepository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => SignUpBloc(userRepository),
        seed: () => SignUpState(
          status: FormzStatus.valid,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => const <SignUpState>[
          SignUpState(
            status: FormzStatus.submissionInProgress,
            email: validEmail,
          ),
          SignUpState(
            status: FormzStatus.submissionFailure,
            email: validEmail,
          )
        ],
      );
    });
  });
}
