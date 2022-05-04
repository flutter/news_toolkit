// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/user_profile/user_profile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

void main() {
  group('UserProfileBloc', () {
    late UserRepository userRepository;

    const user1 = User(id: '1');
    const user2 = User(id: '2');

    late StreamController<User> userController;

    setUp(() {
      userRepository = MockUserRepository();
      userController = StreamController<User>();

      when(() => userRepository.user).thenAnswer((_) => userController.stream);
    });

    test('initial state is UserProfileInitial', () {
      expect(
        UserProfileBloc(userRepository).state,
        equals(UserProfileInitial()),
      );
    });

    blocTest<UserProfileBloc, UserProfileState>(
      'emits populated user '
      'when user is added to user stream',
      build: () => UserProfileBloc(
        userRepository,
      ),
      act: (_) => userController
        ..add(user1)
        ..add(user2),
      expect: () => <UserProfileState>[
        UserProfilePopulated(user1),
        UserProfilePopulated(user2),
      ],
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'adds error '
      'when user stream throws an error',
      build: () => UserProfileBloc(
        userRepository,
      ),
      act: (_) => userController.addError(Exception()),
      expect: () => <UserProfileState>[],
      errors: () => [isA<Exception>()],
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'emits populated user '
      'when user is added to user stream after it throws an error',
      build: () => UserProfileBloc(
        userRepository,
      ),
      act: (_) {
        userController
          ..addError(Exception())
          ..add(user1);
      },
      expect: () => <UserProfileState>[
        UserProfilePopulated(user1),
      ],
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'closes subscriptions',
      build: () => UserProfileBloc(
        userRepository,
      ),
      tearDown: () {
        expect(userController.hasListener, isFalse);
      },
    );
  });
}
