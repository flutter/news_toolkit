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
    this.showInterstitialAd = false,
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
  final bool showInterstitialAd;
  bool get isUserSubscribed => user.subscriptionPlan != SubscriptionPlan.none;

  @override
  List<Object?> get props => [
        status,
        user,
        showLoginOverlay,
        isUserSubscribed,
        showInterstitialAd,
      ];

  AppState copyWith({
    AppStatus? status,
    User? user,
    bool? showLoginOverlay,
    bool? showInterstitialAd,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      showLoginOverlay: showLoginOverlay ?? this.showLoginOverlay,
      showInterstitialAd: showInterstitialAd ?? this.showInterstitialAd,
    );
  }
}
