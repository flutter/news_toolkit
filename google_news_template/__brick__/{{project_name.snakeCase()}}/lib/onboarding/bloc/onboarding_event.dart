part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

{{#include_ads}}
class EnableAdTrackingRequested extends OnboardingEvent {
  const EnableAdTrackingRequested();

  @override
  List<Object?> get props => [];
}
{{/include_ads}}

class EnableNotificationsRequested extends OnboardingEvent {
  const EnableNotificationsRequested();

  @override
  List<Object?> get props => [];
}
