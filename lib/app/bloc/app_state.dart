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
    this.showLoginOverlay = false,
    this.isUserSubscribed = false,
  });

  AppState.authenticated(
    User user,
  ) : this(
          status: AppStatus.authenticated,
          user: user,
          isUserSubscribed: user.subscriptionPlan != SubscriptionPlan.none,
        );

  const AppState.onboardingRequired(User user)
      : this(
          status: AppStatus.onboardingRequired,
          user: user,
          isUserSubscribed: false,
        );

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final bool showLoginOverlay;
  final bool isUserSubscribed;

  @override
  List<Object?> get props => [
        status,
        user,
        showLoginOverlay,
        isUserSubscribed,
      ];

  AppState copyWith({
    AppStatus? status,
    User? user,
    bool? showLoginOverlay,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      showLoginOverlay: showLoginOverlay ?? this.showLoginOverlay,
      isUserSubscribed:
          (user ?? this.user).subscriptionPlan != SubscriptionPlan.none,
    );
  }
}
