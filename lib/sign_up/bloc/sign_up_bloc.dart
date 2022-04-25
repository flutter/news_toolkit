import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._userRepository) : super(const SignUpState()) {
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpDeletedEmail>(_onDeleted);
    on<SignUpSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    final email = Email.dirty(event.email);
    if (event.email.isNotEmpty) {
      emit(
        state.copyWith(
          email: email,
          status: Formz.validate([email]),
          showDeleteIcon: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          email: email,
          status: Formz.validate([email]),
          showDeleteIcon: false,
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _userRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> _onDeleted(
    SignUpDeletedEmail event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(showDeleteIcon: false));
  }
}
