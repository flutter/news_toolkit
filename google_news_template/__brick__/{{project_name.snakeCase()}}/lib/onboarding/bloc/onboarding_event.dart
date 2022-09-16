part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class EnableAdTrackingRequested extends OnboardingEvent {
  const EnableAdTrackingRequested();

  @override
  List<Object?> get props => [];
}

class EnableNotificationsRequested extends OnboardingEvent {
  const EnableNotificationsRequested();

  @override
  List<Object?> get props => [];
}
