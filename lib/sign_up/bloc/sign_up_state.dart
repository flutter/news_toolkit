part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
    bool? showDeleteIcon,
  }) : showDeleteIcon = showDeleteIcon ?? false;

  final Email email;
  final FormzStatus status;
  final bool showDeleteIcon;

  @override
  List<Object> get props => [email, status, showDeleteIcon];

  SignUpState copyWith({
    Email? email,
    FormzStatus? status,
    bool? showDeleteIcon,
  }) {
    return SignUpState(
      email: email ?? this.email,
      status: status ?? this.status,
      showDeleteIcon: showDeleteIcon ?? this.showDeleteIcon,
    );
  }
}
