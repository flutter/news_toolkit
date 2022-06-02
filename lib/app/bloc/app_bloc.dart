import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
    required User user,
  })  : _userRepository = userRepository,
        _notificationsRepository = notificationsRepository,
        super(
          user == User.anonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppOnboardingCompleted>(_onOnboardingCompleted);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription = _userRepository.user.listen(_userChanged);
  }

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;
  late StreamSubscription<User> _userSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    // TODO(bselwe): Emit onboardingRequired on isNewUser
    // when onboarding pages are implemented.

    switch (state.status) {
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
      case AppStatus.onboardingRequired:
        return event.user == User.anonymous
            ? emit(const AppState.unauthenticated())
            : emit(AppState.authenticated(event.user));
    }
  }

  void _onOnboardingCompleted(
    AppOnboardingCompleted event,
    Emitter<AppState> emit,
  ) {
    if (state.status == AppStatus.onboardingRequired) {
      return state.user == User.anonymous
          ? emit(const AppState.unauthenticated())
          : emit(AppState.authenticated(state.user));
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    // We are disabling notifications when a user logs out because
    // the user should not receive any notifications when logged out.
    unawaited(_notificationsRepository.toggleNotifications(enable: false));

    unawaited(_userRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
