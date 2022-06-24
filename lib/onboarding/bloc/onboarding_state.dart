part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingEnablingNotifications extends OnboardingState {
  const OnboardingEnablingNotifications();
}

class OnboardingEnablingNotificationsSucceeded extends OnboardingState
    with AnalyticsEventMixin {
  const OnboardingEnablingNotificationsSucceeded();

  @override
  AnalyticsEvent get event => PushNotificationSubscriptionEvent();

  @override
  List<Object> get props => [event];
}

class OnboardingEnablingNotificationsFailed extends OnboardingState {
  const OnboardingEnablingNotificationsFailed();
}
