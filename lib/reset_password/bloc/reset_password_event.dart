part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordEmailChanged extends ResetPasswordEvent {
  const ResetPasswordEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted();
}
