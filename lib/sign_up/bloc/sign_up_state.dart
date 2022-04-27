part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final FormzStatus status;

  @override
  List<Object> get props => [email, status];

  SignUpState copyWith({
    Email? email,
    FormzStatus? status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}
