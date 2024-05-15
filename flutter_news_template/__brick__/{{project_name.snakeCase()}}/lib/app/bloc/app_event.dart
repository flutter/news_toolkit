part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class AppDeleteAccountRequested extends AppEvent {
  const AppDeleteAccountRequested();
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AppOnboardingCompleted extends AppEvent {
  const AppOnboardingCompleted();
}

class AppOpened extends AppEvent {
  const AppOpened();
}
