import 'dart:async';

import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required NotificationsRepository notificationsRepository,
    required AdsConsentClient adsConsentClient,
  })  : _notificationsRepository = notificationsRepository,
        _adsConsentClient = adsConsentClient,
        super(const OnboardingInitial()) {
    on<EnableAdTrackingRequested>(
      _onEnableAdTrackingRequested,
      transformer: droppable(),
    );
    on<EnableNotificationsRequested>(_onEnableNotificationsRequested);
  }

  final NotificationsRepository _notificationsRepository;
  final AdsConsentClient _adsConsentClient;

  Future<void> _onEnableAdTrackingRequested(
    EnableAdTrackingRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const EnablingAdTracking());
      final adsConsentDetermined = await _adsConsentClient.requestConsent();
      emit(
        adsConsentDetermined
            ? const EnablingAdTrackingSucceeded()
            : const EnablingAdTrackingFailed(),
      );
    } catch (error, stackTrace) {
      emit(const EnablingAdTrackingFailed());
      addError(error, stackTrace);
    }
  }

  Future<void> _onEnableNotificationsRequested(
    EnableNotificationsRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const EnablingNotifications());
      await _notificationsRepository.toggleNotifications(enable: true);
      emit(const EnablingNotificationsSucceeded());
    } catch (error, stackTrace) {
      emit(const EnablingNotificationsFailed());
      addError(error, stackTrace);
    }
  }
}
