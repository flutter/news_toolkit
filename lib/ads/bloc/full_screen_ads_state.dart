part of 'full_screen_ads_bloc.dart';

enum FullScreenAdsStatus {
  initial,
  loadingInterstitialAd,
  loadingInterstitialAdFailed,
  loadingInterstitialAdSucceeded,
  showingInterstitialAd,
  showingInterstitialAdFailed,
  showingInterstitialAdSucceeded,
  loadingRewardedAd,
  loadingRewardedAdFailed,
  loadingRewardedAdSucceeded,
  showingRewardedAd,
  showingRewardedAdFailed,
  showingRewardedAdSucceeded,
}

class FullScreenAdsState extends Equatable {
  const FullScreenAdsState({
    required this.status,
    this.interstitialAd,
    this.rewardedAd,
    this.earnedReward,
  });

  const FullScreenAdsState.initial()
      : this(status: FullScreenAdsStatus.initial);

  final ads.InterstitialAd? interstitialAd;
  final ads.RewardedAd? rewardedAd;
  final ads.RewardItem? earnedReward;
  final FullScreenAdsStatus status;

  @override
  List<Object?> get props => [interstitialAd, rewardedAd, earnedReward, status];

  FullScreenAdsState copyWith({
    ads.InterstitialAd? interstitialAd,
    ads.RewardedAd? rewardedAd,
    ads.RewardItem? earnedReward,
    FullScreenAdsStatus? status,
  }) =>
      FullScreenAdsState(
        interstitialAd: interstitialAd ?? this.interstitialAd,
        rewardedAd: rewardedAd ?? this.rewardedAd,
        earnedReward: earnedReward ?? this.earnedReward,
        status: status ?? this.status,
      );
}

class FullScreenAdsConfig {
  const FullScreenAdsConfig({
    this.interstitialAdUnitId,
    this.rewardedAdUnitId,
  });

  /// The unit id of an interstitial ad.
  final String? interstitialAdUnitId;

  /// The unit id of an interstitial ad.
  final String? rewardedAdUnitId;

  /// The Android test unit id of an interstitial ad.
  static const androidTestInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  /// The Android test unit id of a rewarded ad.
  static const androidTestRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  /// The iOS test unit id of an interstitial ad.
  static const iosTestInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/4411468910';

  /// The iOS test unit id of a rewarded ad.
  static const iosTestRewardedAdUnitId =
      'ca-app-pub-3940256099942544/1712485313';
}
