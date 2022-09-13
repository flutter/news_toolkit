import 'dart:async';
{{#include_ads}}
import 'package:ads_consent_client/ads_consent_client.dart';
{{/include_ads}}
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
{{#include_ads}}
    required AdsConsentClient adsConsentClient,
{{/include_ads}}
  })  : _notificationsRepository = notificationsRepository,
{{#include_ads}}
        _adsConsentClient = adsConsentClient,
{{/include_ads}}
        super(const OnboardingInitial()) {
{{#include_ads}}
    on<EnableAdTrackingRequested>(
      _onEnableAdTrackingRequested,
      transformer: droppable(),
    );
{{/include_ads}}
    on<EnableNotificationsRequested>(_onEnableNotificationsRequested);
  }

  final NotificationsRepository _notificationsRepository;
{{#include_ads}}
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
{{/include_ads}}

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
