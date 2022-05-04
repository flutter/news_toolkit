import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._userRepository) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<SendEmailLinkSubmitted>(_onSendEmailLinkSubmitted);
    on<LoginWithEmailLinkSubmitted>(_onLoginWithEmailLinkSubmitted);
    on<LoginGoogleSubmitted>(_onGoogleSubmitted);
    on<LoginAppleSubmitted>(_onAppleSubmitted);
    on<LoginTwitterSubmitted>(_onTwitterSubmitted);
    on<LoginFacebookSubmitted>(_onFacebookSubmitted);

    _incomingEmailLinksSub = _userRepository.incomingEmailLinks
        .handleError(addError)
        .listen((emailLink) => add(LoginWithEmailLinkSubmitted(emailLink)));
  }

  final UserRepository _userRepository;

  late StreamSubscription<Uri> _incomingEmailLinksSub;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        valid: Formz.validate([email]),
      ),
    );
  }

  Future<void> _onSendEmailLinkSubmitted(
    SendEmailLinkSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.valid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.sendLoginEmailLink(
        email: state.email.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onLoginWithEmailLinkSubmitted(
    LoginWithEmailLinkSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final currentUser = await _userRepository.user.first;
      if (!currentUser.isAnonymous) {
        throw LogInWithEmailLinkFailure(
          Exception(
            'The user is already logged in',
          ),
          StackTrace.current,
        );
      }

      final emailLink = event.emailLink;
      if (!emailLink.queryParameters.containsKey('continueUrl')) {
        throw LogInWithEmailLinkFailure(
          Exception(
            'No `continueUrl` parameter found in the received email link',
          ),
          StackTrace.current,
        );
      }

      final redirectUrl =
          Uri.tryParse(emailLink.queryParameters['continueUrl']!);

      if (!(redirectUrl?.queryParameters.containsKey('email') ?? false)) {
        throw LogInWithEmailLinkFailure(
          Exception(
            'No `email` parameter found in the received email link',
          ),
          StackTrace.current,
        );
      }

      await _userRepository.logInWithEmailLink(
        email: redirectUrl!.queryParameters['email']!,
        emailLink: emailLink.toString(),
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onGoogleSubmitted(
    LoginGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onAppleSubmitted(
    LoginAppleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithApple();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onTwitterSubmitted(
    LoginTwitterSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithTwitter();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithTwitterCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onFacebookSubmitted(
    LoginFacebookSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithFacebook();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithFacebookCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _incomingEmailLinksSub.cancel();
    return super.close();
  }
}
