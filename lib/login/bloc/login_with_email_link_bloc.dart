import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'login_with_email_link_event.dart';
part 'login_with_email_link_state.dart';

class LoginWithEmailLinkBloc
    extends Bloc<LoginWithEmailLinkEvent, LoginWithEmailLinkState> {
  LoginWithEmailLinkBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginWithEmailLinkState()) {
    on<LoginWithEmailLinkSubmitted>(_onLoginWithEmailLinkSubmitted);

    _incomingEmailLinksSub = _userRepository.incomingEmailLinks
        .handleError(addError)
        .listen((emailLink) => add(LoginWithEmailLinkSubmitted(emailLink)));
  }

  final UserRepository _userRepository;

  late StreamSubscription<Uri> _incomingEmailLinksSub;

  Future<void> _onLoginWithEmailLinkSubmitted(
    LoginWithEmailLinkSubmitted event,
    Emitter<LoginWithEmailLinkState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoginWithEmailLinkStatus.loading));

      final currentUser = await _userRepository.user.first;
      if (!currentUser.isAnonymous) {
        throw LogInWithEmailLinkFailure(
          Exception(
            'The user is already logged in',
          ),
        );
      }

      final emailLink = event.emailLink;
      if (!emailLink.queryParameters.containsKey('continueUrl')) {
        throw LogInWithEmailLinkFailure(
          Exception(
            'No `continueUrl` parameter found in the received email link',
          ),
        );
      }

      final redirectUrl =
          Uri.tryParse(emailLink.queryParameters['continueUrl']!);

      if (!(redirectUrl?.queryParameters.containsKey('email') ?? false)) {
        throw LogInWithEmailLinkFailure(
          Exception(
            'No `email` parameter found in the received email link',
          ),
        );
      }

      await _userRepository.logInWithEmailLink(
        email: redirectUrl!.queryParameters['email']!,
        emailLink: emailLink.toString(),
      );

      emit(state.copyWith(status: LoginWithEmailLinkStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: LoginWithEmailLinkStatus.failure));
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _incomingEmailLinksSub.cancel();
    return super.close();
  }
}
