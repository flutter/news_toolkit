part of 'login_with_email_link_bloc.dart';

enum LoginWithEmailLinkStatus {
  initial,
  loading,
  success,
  failure,
}

class LoginWithEmailLinkState extends Equatable {
  const LoginWithEmailLinkState({
    this.status = LoginWithEmailLinkStatus.initial,
  });

  final LoginWithEmailLinkStatus status;

  @override
  List<Object> get props => [status];

  LoginWithEmailLinkState copyWith({
    LoginWithEmailLinkStatus? status,
  }) {
    return LoginWithEmailLinkState(
      status: status ?? this.status,
    );
  }
}
