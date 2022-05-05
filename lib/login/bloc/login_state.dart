part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.valid = false,
  });

  final Email email;
  final FormzSubmissionStatus status;
  final bool valid;

  @override
  List<Object> get props => [email, status, valid];

  LoginState copyWith({
    Email? email,
    FormzSubmissionStatus? status,
    bool? valid,
  }) {
    return LoginState(
      email: email ?? this.email,
      status: status ?? this.status,
      valid: valid ?? this.valid,
    );
  }
}
