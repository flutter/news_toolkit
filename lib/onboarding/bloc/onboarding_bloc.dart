import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required NotificationsRepository notificationsRepository,
  })  : _notificationsRepository = notificationsRepository,
        super(const OnboardingInitial()) {
    on<EnableNotificationsRequested>(_onEnableNotificationsRequested);
  }

  final NotificationsRepository _notificationsRepository;

  FutureOr<void> _onEnableNotificationsRequested(
    EnableNotificationsRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(const OnboardingEnablingNotifications());
      await _notificationsRepository.toggleNotifications(enable: true);
      emit(const OnboardingEnablingNotificationsSucceeded());
    } catch (error, stackTrace) {
      emit(const OnboardingEnablingNotificationsFailed());
      addError(error, stackTrace);
    }
  }
}
