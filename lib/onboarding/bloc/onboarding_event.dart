part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class EnableNotificationsRequested extends OnboardingEvent {
  const EnableNotificationsRequested();

  @override
  List<Object?> get props => [];
}
