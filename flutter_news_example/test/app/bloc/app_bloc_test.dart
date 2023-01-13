// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    late User user;
    late UserRepository userRepository;
    late NotificationsRepository notificationsRepository;

    setUp(() {
      userRepository = MockUserRepository();
      notificationsRepository = MockNotificationsRepository();
      user = MockUser();

      when(() => userRepository.user).thenAnswer((_) => Stream.empty());
      when(() => user.isNewUser).thenReturn(User.anonymous.isNewUser);
      when(() => user.id).thenReturn(User.anonymous.id);
      when(() => user.subscriptionPlan)
          .thenReturn(User.anonymous.subscriptionPlan);
    });

    test('initial state is unauthenticated when user is anonymous', () {
      expect(
        AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: User.anonymous,
        ).state.status,
        equals(AppStatus.unauthenticated),
      );
    });

    group('AppUserChanged', () {
      late User returningUser;
      late User newUser;

      setUp(() {
        returningUser = MockUser();
        newUser = MockUser();
        when(() => returningUser.isNewUser).thenReturn(false);
        when(() => returningUser.id).thenReturn('id');
        when(() => returningUser.subscriptionPlan)
            .thenReturn(SubscriptionPlan.none);
        when(() => newUser.isNewUser).thenReturn(true);
        when(() => newUser.id).thenReturn('id');
        when(() => newUser.subscriptionPlan).thenReturn(SubscriptionPlan.none);
      });

      blocTest<AppBloc, AppState>(
        'emits nothing when '
        'state is unauthenticated and user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when '
        'state is onboardingRequired and user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        seed: () => AppState.onboardingRequired(user),
        expect: () => <AppState>[AppState.unauthenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits onboardingRequired when user is new and not anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(newUser),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        expect: () => [AppState.onboardingRequired(newUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when user is returning and not anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(returningUser),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        expect: () => [AppState.authenticated(returningUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated '
        'when authenticated user changes',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(returningUser),
          );
        },
        seed: () => AppState.authenticated(user),
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        expect: () => [AppState.authenticated(returningUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when '
        'user is not anonymous and onboarding is complete',
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        seed: () => AppState.onboardingRequired(user),
        act: (bloc) => bloc.add(AppOnboardingCompleted()),
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when '
        'user is anonymous and onboarding is complete',
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: User.anonymous,
        ),
        seed: () => AppState.onboardingRequired(User.anonymous),
        act: (bloc) => bloc.add(AppOnboardingCompleted()),
        expect: () => [AppState.unauthenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        expect: () => [AppState.unauthenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits nothing when '
        'state is unauthenticated and user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );
    });

    group('AppLogoutRequested', () {
      setUp(() {
        when(
          () => notificationsRepository.toggleNotifications(
            enable: any(named: 'enable'),
          ),
        ).thenAnswer((_) async {});

        when(() => userRepository.logOut()).thenAnswer((_) async {});
      });

      blocTest<AppBloc, AppState>(
        'calls toggleNotifications off on NotificationsRepository',
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(
            () => notificationsRepository.toggleNotifications(enable: false),
          ).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'calls logOut on UserRepository',
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => userRepository.logOut()).called(1);
        },
      );
    });

    group('close', () {
      late StreamController<User> userController;

      setUp(() {
        userController = StreamController<User>();

        when(() => userRepository.user)
            .thenAnswer((_) => userController.stream);
      });

      blocTest<AppBloc, AppState>(
        'cancels UserRepository.user subscription',
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        tearDown: () => expect(userController.hasListener, isFalse),
      );
    });

    group('AppOpened', () {
      blocTest<AppBloc, AppState>(
        'calls UserRepository.incrementAppOpenedCount '
        'and emits showLoginOverlay as true '
        'when fetchAppOpenedCount returns a count value of 4 '
        'and user is anonymous',
        setUp: () {
          when(() => userRepository.fetchAppOpenedCount())
              .thenAnswer((_) async => 4);
          when(() => userRepository.incrementAppOpenedCount())
              .thenAnswer((_) async {});
          when(() => userRepository.fetchOverallArticleViews())
              .thenAnswer((_) async => 0);
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppOpened()),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[
          AppState(
            showLoginOverlay: true,
            status: AppStatus.unauthenticated,
          )
        ],
        verify: (_) {
          verify(
            () => userRepository.incrementAppOpenedCount(),
          ).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'calls UserRepository.incrementAppOpenedCount '
        'when fetchAppOpenedCount returns a count value of 3 '
        'and user is anonymous',
        setUp: () {
          when(() => userRepository.fetchAppOpenedCount())
              .thenAnswer((_) async => 3);
          when(() => userRepository.incrementAppOpenedCount())
              .thenAnswer((_) async {});
          when(() => userRepository.fetchOverallArticleViews())
              .thenAnswer((_) async => 0);
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppOpened()),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
        verify: (_) {
          verify(
            () => userRepository.incrementAppOpenedCount(),
          ).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'does not call UserRepository.incrementAppOpenedCount '
        'when fetchAppOpenedCount returns a count value of 6 '
        'and user is anonymous',
        setUp: () {
          when(() => userRepository.fetchAppOpenedCount())
              .thenAnswer((_) async => 6);
          when(() => userRepository.fetchOverallArticleViews())
              .thenAnswer((_) async => 0);
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppOpened()),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
        verify: (_) {
          verifyNever(
            () => userRepository.incrementAppOpenedCount(),
          );
        },
      );

      blocTest<AppBloc, AppState>(
        'fetches overall articles views and emits state with updated value',
        setUp: () {
          when(() => userRepository.fetchAppOpenedCount())
              .thenAnswer((_) async => 6);
          when(() => userRepository.fetchOverallArticleViews())
              .thenAnswer((_) async => 2);
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppOpened()),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[
          AppState.unauthenticated().copyWith(
            overallArticleViews: 2,
          )
        ],
      );
    });

    group('ArticleOpened', () {
      blocTest<AppBloc, AppState>(
        'calls incrementOverallArticleViews and '
        'emits state with the new value of overallArticlesViews ',
        setUp: () {
          when(() => userRepository.incrementOverallArticleViews())
              .thenAnswer((_) async => {});
          when(() => userRepository.fetchOverallArticleViews())
              .thenAnswer((_) async => 2);
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(ArticleOpened()),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[
          AppState.unauthenticated().copyWith(
            overallArticleViews: 2,
          )
        ],
        verify: (bloc) {
          verify(
            () => userRepository.incrementOverallArticleViews(),
          ).called(1);
          verify(
            () => userRepository.fetchOverallArticleViews(),
          ).called(1);
        },
      );
    });
  });
}
