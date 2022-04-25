part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginCredentialsSubmitted extends LoginEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('LoginCredentialsSubmitted');
}

class LoginGoogleSubmitted extends LoginEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('LoginGoogleSubmitted');
}

class LoginAppleSubmitted extends LoginEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('LoginAppleSubmitted');
}

class LoginFacebookSubmitted extends LoginEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('LoginFacebookSubmitted');
}
