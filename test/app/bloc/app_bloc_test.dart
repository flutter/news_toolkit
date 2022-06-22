// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockInAppPurchaseRepository extends Mock
    implements InAppPurchaseRepository {}

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    final user = MockUser();
    late UserRepository userRepository;
    late NotificationsRepository notificationsRepository;
    late AnalyticsRepository analyticsRepository;
    late InAppPurchaseRepository inAppPurchaseRepository;

    setUp(() {
      userRepository = MockUserRepository();
      notificationsRepository = MockNotificationsRepository();
      analyticsRepository = MockAnalyticsRepository();
      inAppPurchaseRepository = MockInAppPurchaseRepository();

      when(() => userRepository.user).thenAnswer((_) => Stream.empty());
      when(() => inAppPurchaseRepository.currentSubscriptionPlan)
          .thenAnswer((_) => Stream.empty());
    });

    test('initial state is unauthenticated when user is anonymous', () {
      expect(
        AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          user: User.anonymous,
        ).state,
        AppState.unauthenticated(),
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
        when(() => newUser.isNewUser).thenReturn(true);
        when(() => newUser.id).thenReturn('id');
        when(() => analyticsRepository.setUserId(any()))
            .thenAnswer((_) async {});
      });

      blocTest<AppBloc, AppState>(
        'calls setUserId on AnalyticsRepository '
        'with null when user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          analyticsRepository: analyticsRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        verify: (_) {
          verify(
            () => analyticsRepository.setUserId(null),
          ).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'calls setUserId on AnalyticsRepository '
        'with user id when user is not anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(returningUser),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          analyticsRepository: analyticsRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        verify: (_) {
          verify(
            () => analyticsRepository.setUserId(returningUser.id),
          ).called(1);
        },
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          user: user,
        ),
        expect: () => [AppState.authenticated(returningUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated with correct userSubscriptionPlan '
        'when authenticated user changes',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(returningUser),
          );
        },
        seed: () => AppState.authenticated(
          MockUser(),
          userSubscriptionPlan: SubscriptionPlan.premium,
        ),
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          user: user,
        ),
        expect: () => [
          AppState.authenticated(
            returningUser,
            userSubscriptionPlan: SubscriptionPlan.premium,
          )
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when '
        'user is not anonymous and onboarding is complete',
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );
    });

    group('AppUserSubscriptionPlanChanged', () {
      blocTest<AppBloc, AppState>(
        'emits updated userSubscriptionPlan',
        setUp: () => when(() => inAppPurchaseRepository.currentSubscriptionPlan)
            .thenAnswer((_) => Stream.value(SubscriptionPlan.premium)),
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          user: user,
        ),
        seed: () => AppState.authenticated(user),
        expect: () => <AppState>[
          AppState.authenticated(
            user,
            userSubscriptionPlan: SubscriptionPlan.premium,
          ),
        ],
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
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
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
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
      late StreamController<SubscriptionPlan> currentSubscriptionPlanController;

      setUp(() {
        userController = StreamController<User>();
        currentSubscriptionPlanController =
            StreamController<SubscriptionPlan>();

        when(() => userRepository.user)
            .thenAnswer((_) => userController.stream);
        when(() => inAppPurchaseRepository.currentSubscriptionPlan)
            .thenAnswer((_) => currentSubscriptionPlanController.stream);
      });

      blocTest<AppBloc, AppState>(
        'cancels UserRepository.user subscription',
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          user: user,
        ),
        tearDown: () => expect(userController.hasListener, isFalse),
      );

      blocTest<AppBloc, AppState>(
        'cancels InAppPurchaseRepository.currentSubscriptionPlan subscription',
        build: () => AppBloc(
          userRepository: userRepository,
          notificationsRepository: notificationsRepository,
          analyticsRepository: analyticsRepository,
          inAppPurchaseRepository: inAppPurchaseRepository,
          user: user,
        ),
        tearDown: () =>
            expect(currentSubscriptionPlanController.hasListener, isFalse),
      );
    });
  });
}
