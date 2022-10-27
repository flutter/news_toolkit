// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart' as analytics;
import 'package:bloc_test/bloc_test.dart';
import 'package:{{project_name.snakeCase()}}/analytics/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockAnalyticsRepository extends Mock
    implements analytics.AnalyticsRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

class MockAnalyticsEvent extends Mock implements analytics.AnalyticsEvent {}

void main() {
  group('AnalyticsBloc', () {
    late analytics.AnalyticsRepository analyticsRepository;
    late UserRepository userRepository;

    setUp(() {
      analyticsRepository = MockAnalyticsRepository();
      userRepository = MockUserRepository();

      when(() => userRepository.user).thenAnswer((_) => Stream.empty());
    });

    group('on UserRepository.user changed', () {
      late User user;

      setUp(() {
        user = MockUser();
        when(() => user.id).thenReturn('id');
        when(() => analyticsRepository.setUserId(any()))
            .thenAnswer((_) async {});
      });

      blocTest<AnalyticsBloc, AnalyticsState>(
        'calls AnalyticsRepository.setUserId '
        'with null when user is anonymous',
        setUp: () => when(() => userRepository.user)
            .thenAnswer((_) => Stream.value(User.anonymous)),
        build: () => AnalyticsBloc(
          analyticsRepository: analyticsRepository,
          userRepository: userRepository,
        ),
        verify: (_) {
          verify(() => analyticsRepository.setUserId(null)).called(1);
        },
      );

      blocTest<AnalyticsBloc, AnalyticsState>(
        'calls AnalyticsRepository.setUserId '
        'with user id when user is not anonymous',
        setUp: () => when(() => userRepository.user)
            .thenAnswer((_) => Stream.value(user)),
        build: () => AnalyticsBloc(
          analyticsRepository: analyticsRepository,
          userRepository: userRepository,
        ),
        verify: (_) {
          verify(() => analyticsRepository.setUserId(user.id)).called(1);
        },
      );

      blocTest<AnalyticsBloc, AnalyticsState>(
        'adds error '
        'when AnalyticsRepository.setUserId throws',
        setUp: () {
          when(() => userRepository.user).thenAnswer((_) => Stream.value(user));
          when(() => analyticsRepository.setUserId(any()))
              .thenThrow(Exception());
        },
        build: () => AnalyticsBloc(
          analyticsRepository: analyticsRepository,
          userRepository: userRepository,
        ),
        errors: () => [isA<Exception>()],
      );
    });

    group('on TrackAnalyticsEvent', () {
      final event = MockAnalyticsEvent();

      setUp(() {
        when(() => analyticsRepository.track(any())).thenAnswer((_) async {});
      });

      setUpAll(() {
        registerFallbackValue(MockAnalyticsEvent());
      });

      blocTest<AnalyticsBloc, AnalyticsState>(
        'calls AnalyticsRepository.track',
        build: () => AnalyticsBloc(
          analyticsRepository: analyticsRepository,
          userRepository: userRepository,
        ),
        act: (bloc) => bloc.add(TrackAnalyticsEvent(event)),
        verify: (_) {
          verify(() => analyticsRepository.track(event)).called(1);
        },
      );

      blocTest<AnalyticsBloc, AnalyticsState>(
        'adds error '
        'when AnalyticsRepository.track throws',
        setUp: () =>
            when(() => analyticsRepository.track(any())).thenThrow(Exception()),
        build: () => AnalyticsBloc(
          analyticsRepository: analyticsRepository,
          userRepository: userRepository,
        ),
        act: (bloc) => bloc.add(TrackAnalyticsEvent(event)),
        errors: () => [isA<Exception>()],
      );
    });

    group('close', () {
      late StreamController<User> userController;

      setUp(() {
        userController = StreamController<User>();
        when(() => userRepository.user)
            .thenAnswer((_) => userController.stream);
      });

      blocTest<AnalyticsBloc, AnalyticsState>(
        'cancels UserRepository.user subscription',
        build: () => AnalyticsBloc(
          analyticsRepository: analyticsRepository,
          userRepository: userRepository,
        ),
        tearDown: () => expect(userController.hasListener, isFalse),
      );
    });
  });
}
