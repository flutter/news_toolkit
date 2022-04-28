part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final FormzStatus status;

  @override
  List<Object> get props => [email, status];

  LoginState copyWith({
    Email? email,
    FormzStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}
