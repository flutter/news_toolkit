part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const SignUpPassword.pure(),
    this.status = FormzStatus.pure,
    this.showDeleteIcon = false,
  });

  final Email email;
  final SignUpPassword password;
  final FormzStatus status;
  final bool showDeleteIcon;

  @override
  List<Object> get props => [email, password, status, showDeleteIcon];

  SignUpState copyWith({
    Email? email,
    SignUpPassword? password,
    FormzStatus? status,
    bool? showDeleteIcon,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      showDeleteIcon: showDeleteIcon ?? this.showDeleteIcon,
    );
  }
}
