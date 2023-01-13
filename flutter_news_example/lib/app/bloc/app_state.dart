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
    this.overallArticleViews = 0,
  });

  const AppState.authenticated(
    User user,
  ) : this(
          status: AppStatus.authenticated,
          user: user,
        );

  const AppState.onboardingRequired(User user)
      : this(
          status: AppStatus.onboardingRequired,
          user: user,
        );

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final bool showLoginOverlay;
  final int overallArticleViews;
  bool get isUserSubscribed => user.subscriptionPlan != SubscriptionPlan.none;

  @override
  List<Object?> get props => [
        status,
        user,
        showLoginOverlay,
        isUserSubscribed,
        overallArticleViews,
      ];

  AppState copyWith({
    AppStatus? status,
    User? user,
    bool? showLoginOverlay,
    int? overallArticleViews,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      showLoginOverlay: showLoginOverlay ?? this.showLoginOverlay,
      overallArticleViews: overallArticleViews ?? this.overallArticleViews,
    );
  }
}
