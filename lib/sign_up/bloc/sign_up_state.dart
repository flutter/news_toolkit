part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const SignUpPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final SignUpPassword password;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, status];

  SignUpState copyWith({
    Email? email,
    SignUpPassword? password,
    FormzStatus? status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
