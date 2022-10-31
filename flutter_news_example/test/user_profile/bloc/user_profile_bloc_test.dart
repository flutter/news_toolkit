// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:flutter_news_example_api/client.dart' hide User;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

void main() {
  group('UserProfileBloc', () {
    late UserRepository userRepository;
    late NotificationsRepository notificationsRepository;

    const user1 = User(id: '1', subscriptionPlan: SubscriptionPlan.none);
    const user2 = User(id: '2', subscriptionPlan: SubscriptionPlan.none);

    late StreamController<User> userController;

    setUp(() {
      userRepository = MockUserRepository();
      userController = StreamController<User>();
      notificationsRepository = MockNotificationsRepository();

      when(() => userRepository.user).thenAnswer((_) => userController.stream);
    });

    test('initial state is UserProfileState.initial', () {
      expect(
        UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ).state,
        equals(UserProfileState.initial()),
      );
    });

    group('on user changes', () {
      blocTest<UserProfileBloc, UserProfileState>(
        'emits populated user '
        'when user is added to user stream',
        build: () => UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ),
        act: (_) => userController
          ..add(user1)
          ..add(user2),
        expect: () => <UserProfileState>[
          UserProfileState.initial().copyWith(
            user: user1,
            status: UserProfileStatus.userUpdated,
          ),
          UserProfileState.initial().copyWith(
            user: user2,
            status: UserProfileStatus.userUpdated,
          ),
        ],
      );

      blocTest<UserProfileBloc, UserProfileState>(
        'adds error '
        'when user stream throws an error',
        build: () => UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ),
        act: (_) => userController.addError(Exception()),
        expect: () => <UserProfileState>[],
        errors: () => [isA<Exception>()],
      );

      blocTest<UserProfileBloc, UserProfileState>(
        'emits populated user '
        'when user is added to user stream after it throws an error',
        build: () => UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ),
        act: (_) {
          userController
            ..addError(Exception())
            ..add(user1);
        },
        expect: () => <UserProfileState>[
          UserProfileState.initial().copyWith(
            user: user1,
            status: UserProfileStatus.userUpdated,
          ),
        ],
      );
    });

    group('on FetchNotificationsEnabled', () {
      blocTest<UserProfileBloc, UserProfileState>(
        'emits '
        '[fetchingNotificationsEnabled, fetchingNotificationsEnabledSucceeded] '
        'when fetchNotificationsEnabled succeeds',
        setUp: () => when(notificationsRepository.fetchNotificationsEnabled)
            .thenAnswer((_) async => true),
        build: () => UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ),
        act: (bloc) => bloc.add(FetchNotificationsEnabled()),
        expect: () => <UserProfileState>[
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.fetchingNotificationsEnabled,
          ),
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.fetchingNotificationsEnabledSucceeded,
            notificationsEnabled: true,
          ),
        ],
      );

      blocTest<UserProfileBloc, UserProfileState>(
        'emits '
        '[fetchingNotificationsEnabled, fetchingNotificationsEnabledFailed] '
        'when fetchNotificationsEnabled fails',
        setUp: () => when(notificationsRepository.fetchNotificationsEnabled)
            .thenThrow(Exception()),
        build: () => UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ),
        act: (bloc) => bloc.add(FetchNotificationsEnabled()),
        expect: () => <UserProfileState>[
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.fetchingNotificationsEnabled,
          ),
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.fetchingNotificationsEnabledFailed,
          ),
        ],
      );
    });

    group('on ToggleNotifications', () {
      setUp(() {
        when(
          () => notificationsRepository.toggleNotifications(
            enable: any(named: 'enable'),
          ),
        ).thenAnswer((_) async {});
      });

      blocTest<UserProfileBloc, UserProfileState>(
        'emits '
        '[togglingNotifications, togglingNotificationsSucceeded] '
        'when notifications are enabled '
        'and toggleNotifications succeeds',
        seed: () => UserProfileState.initial().copyWith(
          notificationsEnabled: true,
        ),
        build: () => UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ),
        act: (bloc) => bloc.add(ToggleNotifications()),
        expect: () => <UserProfileState>[
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.togglingNotifications,
            notificationsEnabled: false,
          ),
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.togglingNotificationsSucceeded,
            notificationsEnabled: false,
          ),
        ],
        verify: (bloc) => verify(
          () => notificationsRepository.toggleNotifications(enable: false),
        ).called(1),
      );

      blocTest<UserProfileBloc, UserProfileState>(
        'emits '
        '[togglingNotifications, togglingNotificationsSucceeded] '
        'when notifications are disabled '
        'and toggleNotifications succeeds',
        seed: () => UserProfileState.initial().copyWith(
          notificationsEnabled: false,
        ),
        build: () => UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ),
        act: (bloc) => bloc.add(ToggleNotifications()),
        expect: () => <UserProfileState>[
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.togglingNotifications,
            notificationsEnabled: true,
          ),
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.togglingNotificationsSucceeded,
            notificationsEnabled: true,
          ),
        ],
        verify: (bloc) => verify(
          () => notificationsRepository.toggleNotifications(enable: true),
        ).called(1),
      );

      blocTest<UserProfileBloc, UserProfileState>(
        'emits '
        '[togglingNotifications, togglingNotificationsFailed] '
        'when toggleNotifications fails',
        setUp: () => when(
          () => notificationsRepository.toggleNotifications(
            enable: any(named: 'enable'),
          ),
        ).thenThrow(Exception()),
        build: () => UserProfileBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
        ),
        act: (bloc) => bloc.add(ToggleNotifications()),
        expect: () => <UserProfileState>[
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.togglingNotifications,
            notificationsEnabled: true,
          ),
          UserProfileState.initial().copyWith(
            status: UserProfileStatus.togglingNotificationsFailed,
            notificationsEnabled: false,
          ),
        ],
      );
    });

    blocTest<UserProfileBloc, UserProfileState>(
      'closes subscriptions',
      build: () => UserProfileBloc(
        userRepository: userRepository,
        notificationsRepository: notificationsRepository,
      ),
      tearDown: () {
        expect(userController.hasListener, isFalse);
      },
    );
  });
}
