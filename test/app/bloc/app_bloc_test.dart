// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    final user = MockUser();
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();

      when(() => userRepository.user).thenAnswer(
        (_) => Stream.empty(),
      );
    });

    test('initial state is unauthenticated when user is anonymous', () {
      expect(
        AppBloc(
          userRepository: userRepository,
          user: User.anonymous,
        ).state,
        AppState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      late User returningUser;
      late User newUser;

      setUp(() {
        returningUser = MockUser();
        newUser = MockUser();
        when(() => returningUser.isNewUser).thenReturn(false);
        when(() => newUser.isNewUser).thenReturn(true);
      });

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
          user: user,
        ),
        expect: () => [AppState.authenticated(returningUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when '
        'user is not anonymous and onboarding is complete',
        build: () => AppBloc(
          userRepository: userRepository,
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
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );
    });

    group('LogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'invokes logOut',
        setUp: () {
          when(() => userRepository.logOut()).thenAnswer((_) async {});
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => userRepository.logOut()).called(1);
        },
      );
    });
  });
}
