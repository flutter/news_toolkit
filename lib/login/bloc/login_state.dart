part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const LoginPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final LoginPassword password;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, status];

  LoginState copyWith({
    Email? email,
    LoginPassword? password,
    FormzStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
