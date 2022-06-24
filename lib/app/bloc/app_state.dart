part of 'app_bloc.dart';

enum AppStatus {
  onboardingRequired,
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user = User.anonymous,
    this.userSubscriptionPlan,
    bool? showLoginOverlay,
  }) : showLoginOverlay = showLoginOverlay ?? false;

  const AppState.authenticated(
    User user, {
    SubscriptionPlan? userSubscriptionPlan,
  }) : this(
          status: AppStatus.authenticated,
          user: user,
          userSubscriptionPlan: userSubscriptionPlan,
        );

  const AppState.onboardingRequired(User user)
      : this(status: AppStatus.onboardingRequired, user: user);

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final SubscriptionPlan? userSubscriptionPlan;
  final bool showLoginOverlay;

  bool get isUserSubscribed =>
      userSubscriptionPlan != null &&
      userSubscriptionPlan != SubscriptionPlan.none;

  @override
  List<Object?> get props => [
        status,
        user,
        userSubscriptionPlan,
        showLoginOverlay,
      ];

  AppState copyWith({
    AppStatus? status,
    User? user,
    SubscriptionPlan? userSubscriptionPlan,
    bool? showLoginOverlay,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      userSubscriptionPlan: userSubscriptionPlan ?? this.userSubscriptionPlan,
      showLoginOverlay: showLoginOverlay ?? this.showLoginOverlay,
    );
  }
}
