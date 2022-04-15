part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final FormzStatus status;

  @override
  List<Object> get props => [email, status];

  ResetPasswordState copyWith({
    Email? email,
    FormzStatus? status,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }
}
