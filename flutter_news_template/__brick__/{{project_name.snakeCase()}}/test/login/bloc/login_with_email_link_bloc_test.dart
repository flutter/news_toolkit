// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('LoginWithEmailLinkBloc', () {
    late UserRepository userRepository;
    late StreamController<Uri> incomingEmailLinksController;

    setUp(() {
      userRepository = MockUserRepository();

      incomingEmailLinksController = StreamController<Uri>();
      when(() => userRepository.incomingEmailLinks)
          .thenAnswer((_) => incomingEmailLinksController.stream);
    });

    test('initial state is LoginWithEmailLinkState', () {
      expect(
        LoginWithEmailLinkBloc(
          userRepository: userRepository,
        ).state,
        LoginWithEmailLinkState(),
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
        <String, String>{'continueUrl': Uri.https('').toString()},
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

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] '
        'when the user is already logged in',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(false);
        },
        build: () => LoginWithEmailLinkBloc(userRepository: userRepository),
        act: (bloc) => incomingEmailLinksController.add(validEmailLink),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] '
        'when the user is anonymous and '
        'continueUrl is missing in the email link',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
        },
        build: () => LoginWithEmailLinkBloc(userRepository: userRepository),
        act: (bloc) =>
            incomingEmailLinksController.add(emailLinkWithoutContinueUrl),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] '
        'when the user is anonymous and '
        'invalid continueUrl is provided in the email link',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
        },
        build: () => LoginWithEmailLinkBloc(userRepository: userRepository),
        act: (bloc) =>
            incomingEmailLinksController.add(emailLinkWithInvalidContinueUrl),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, failure] '
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
        build: () => LoginWithEmailLinkBloc(userRepository: userRepository),
        act: (bloc) => incomingEmailLinksController.add(validEmailLink),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.failure),
        ],
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'emits [loading, success] '
        'when the user is anonymous and '
        'valid continueUrl is provided in the email link and '
        'logInWithEmailLink succeeds',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
        },
        build: () => LoginWithEmailLinkBloc(userRepository: userRepository),
        act: (bloc) => incomingEmailLinksController.add(validEmailLink),
        expect: () => const <LoginWithEmailLinkState>[
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.loading),
          LoginWithEmailLinkState(status: LoginWithEmailLinkStatus.success),
        ],
      );

      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'calls logInWithEmailLink',
        setUp: () {
          when(() => user.isAnonymous).thenReturn(true);
        },
        build: () => LoginWithEmailLinkBloc(userRepository: userRepository),
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

    group('close', () {
      blocTest<LoginWithEmailLinkBloc, LoginWithEmailLinkState>(
        'cancels UserRepository.incomingEmailLinks subscription',
        build: () => LoginWithEmailLinkBloc(
          userRepository: userRepository,
        ),
        tearDown: () {
          expect(incomingEmailLinksController.hasListener, isFalse);
        },
      );
    });
  });
}
