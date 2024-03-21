import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

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
    on<AppDeleteAccountRequested>(_onDeleteAccountRequested);
    on<AppOpened>(_onAppOpened);

    _userSubscription = _userRepository.user.listen(_userChanged);
  }

  /// The number of app opens after which the login overlay is shown
  /// for an unauthenticated user.
  static const _appOpenedCountForLoginOverlay = 5;

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;

  late StreamSubscription<User> _userSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;

    switch (state.status) {
      case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return user != User.anonymous && user.isNewUser
            ? emit(AppState.onboardingRequired(user))
            : user == User.anonymous
                ? emit(const AppState.unauthenticated())
                : emit(AppState.authenticated(user));
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

  Future<void> _onDeleteAccountRequested(
    AppDeleteAccountRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      // We are disabling notifications when a user deletes their account
      // because the user should not receive any notifications after their
      // account is deleted.
      unawaited(_notificationsRepository.toggleNotifications(enable: false));
      await _userRepository.deleteAccount();
    } catch (error, stackTrace) {
      await _userRepository.logOut();
      addError(error, stackTrace);
    }
  }

  Future<void> _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    if (state.user.isAnonymous) {
      final appOpenedCount = await _userRepository.fetchAppOpenedCount();

      if (appOpenedCount == _appOpenedCountForLoginOverlay - 1) {
        emit(state.copyWith(showLoginOverlay: true));
      }

      if (appOpenedCount < _appOpenedCountForLoginOverlay + 1) {
        await _userRepository.incrementAppOpenedCount();
      }
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
