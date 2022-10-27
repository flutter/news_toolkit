// ignore_for_file: prefer_const_constructors

import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_example/onboarding/onboarding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_repository/notifications_repository.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockAdsConsentClient extends Mock implements AdsConsentClient {}

void main() {
  group('OnboardingBloc', () {
    late NotificationsRepository notificationsRepository;
    late AdsConsentClient adsConsentClient;

    setUp(() {
      notificationsRepository = MockNotificationsRepository();
      adsConsentClient = MockAdsConsentClient();
    });

    group('EnableAdTrackingRequested', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'emits '
        '[EnablingAdTracking, EnablingAdTrackingSucceeded] '
        'when AdsConsentClient.requestConsent returns true',
        setUp: () =>
            when(adsConsentClient.requestConsent).thenAnswer((_) async => true),
        build: () => OnboardingBloc(
          notificationsRepository: notificationsRepository,
          adsConsentClient: adsConsentClient,
        ),
        act: (bloc) => bloc.add(EnableAdTrackingRequested()),
        expect: () => <OnboardingState>[
          EnablingAdTracking(),
          EnablingAdTrackingSucceeded(),
        ],
        verify: (bloc) => verify(adsConsentClient.requestConsent).called(1),
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'emits '
        '[EnablingAdTracking, EnablingAdTrackingFailed] '
        'when AdsConsentClient.requestConsent returns false',
        setUp: () => when(adsConsentClient.requestConsent)
            .thenAnswer((_) async => false),
        build: () => OnboardingBloc(
          notificationsRepository: notificationsRepository,
          adsConsentClient: adsConsentClient,
        ),
        act: (bloc) => bloc.add(EnableAdTrackingRequested()),
        expect: () => <OnboardingState>[
          EnablingAdTracking(),
          EnablingAdTrackingFailed(),
        ],
        verify: (bloc) => verify(adsConsentClient.requestConsent).called(1),
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'emits '
        '[EnablingNotifications, EnablingNotificationsFailed] '
        'when AdsConsentClient.requestConsent fails',
        setUp: () =>
            when(adsConsentClient.requestConsent).thenThrow(Exception()),
        build: () => OnboardingBloc(
          notificationsRepository: notificationsRepository,
          adsConsentClient: adsConsentClient,
        ),
        act: (bloc) => bloc.add(EnableAdTrackingRequested()),
        expect: () => <OnboardingState>[
          EnablingAdTracking(),
          EnablingAdTrackingFailed(),
        ],
      );
    });

    group('EnableNotificationsRequested', () {
      setUp(() {
        when(
          () => notificationsRepository.toggleNotifications(
            enable: any(named: 'enable'),
          ),
        ).thenAnswer((_) async {});
      });

      blocTest<OnboardingBloc, OnboardingState>(
        'emits '
        '[EnablingNotifications, EnablingNotificationsSucceeded] '
        'when NotificationsRepository.toggleNotifications succeeds',
        build: () => OnboardingBloc(
          notificationsRepository: notificationsRepository,
          adsConsentClient: adsConsentClient,
        ),
        act: (bloc) => bloc.add(EnableNotificationsRequested()),
        expect: () => <OnboardingState>[
          EnablingNotifications(),
          EnablingNotificationsSucceeded(),
        ],
        verify: (bloc) => verify(
          () => notificationsRepository.toggleNotifications(enable: true),
        ).called(1),
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'emits '
        '[EnablingNotifications, EnablingNotificationsFailed] '
        'when NotificationsRepository.toggleNotifications fails',
        setUp: () => when(
          () => notificationsRepository.toggleNotifications(
            enable: any(named: 'enable'),
          ),
        ).thenThrow(Exception()),
        build: () => OnboardingBloc(
          notificationsRepository: notificationsRepository,
          adsConsentClient: adsConsentClient,
        ),
        act: (bloc) => bloc.add(EnableNotificationsRequested()),
        expect: () => <OnboardingState>[
          EnablingNotifications(),
          EnablingNotificationsFailed(),
        ],
      );
    });
  });
}
