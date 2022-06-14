import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
    required InAppPurchaseRepository inAppPurchaseRepository,
    required User user,
  })  : _userRepository = userRepository,
        _notificationsRepository = notificationsRepository,
        _inAppPurchaseRepository = inAppPurchaseRepository,
        super(
          user == User.anonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppUserSubscriptionPlanChanged>(_onUserSubscriptionPlanChanged);
    on<AppOnboardingCompleted>(_onOnboardingCompleted);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription = _userRepository.user.listen(_userChanged);
    _currentSubscriptionPlanSubscription = _inAppPurchaseRepository
        .currentSubscriptionPlan
        .listen(_currentSubscriptionPlanChanged);
  }

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;
  final InAppPurchaseRepository _inAppPurchaseRepository;

  late StreamSubscription<User> _userSubscription;
  late StreamSubscription<SubscriptionPlan>
      _currentSubscriptionPlanSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _currentSubscriptionPlanChanged(SubscriptionPlan plan) =>
      add(AppUserSubscriptionPlanChanged(plan));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    switch (state.status) {
      case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return event.user != User.anonymous && event.user.isNewUser
            ? emit(AppState.onboardingRequired(event.user))
            : event.user == User.anonymous
                ? emit(const AppState.unauthenticated())
                : emit(
                    AppState.authenticated(
                      event.user,
                      userSubscriptionPlan: state.userSubscriptionPlan,
                    ),
                  );
    }
  }

  void _onUserSubscriptionPlanChanged(
    AppUserSubscriptionPlanChanged event,
    Emitter<AppState> emit,
  ) =>
      emit(state.copyWith(userSubscriptionPlan: event.plan));

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
    _currentSubscriptionPlanSubscription.cancel();
    return super.close();
  }
}
