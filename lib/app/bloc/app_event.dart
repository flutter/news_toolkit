part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AppUserSubscriptionPlanChanged extends AppEvent {
  const AppUserSubscriptionPlanChanged(this.plan);

  final SubscriptionPlan plan;

  @override
  List<Object> get props => [plan];
}

class AppOnboardingCompleted extends AppEvent {}

class AppOpened extends AppEvent {
  const AppOpened();
}
