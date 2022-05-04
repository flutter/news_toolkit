part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const LoginPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.valid = false,
  });

  final Email email;
  final LoginPassword password;
  final FormzSubmissionStatus status;
  final bool valid;

  @override
  List<Object> get props => [email, password, status, valid];

  LoginState copyWith({
    Email? email,
    LoginPassword? password,
    FormzSubmissionStatus? status,
    bool? valid,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      valid: valid ?? this.valid,
    );
  }
}
