part of 'full_screen_ads_bloc.dart';

abstract class FullScreenAdsEvent extends Equatable {
  const FullScreenAdsEvent();

  @override
  List<Object> get props => [];
}

class LoadInterstitialAdRequested extends FullScreenAdsEvent {
  const LoadInterstitialAdRequested({this.retry = 0});

  final int retry;

  @override
  List<Object> get props => [retry];
}

class LoadRewardedAdRequested extends FullScreenAdsEvent {
  const LoadRewardedAdRequested({this.retry = 0});

  final int retry;

  @override
  List<Object> get props => [retry];
}

class ShowInterstitialAdRequested extends FullScreenAdsEvent {
  const ShowInterstitialAdRequested();
}

class ShowRewardedAdRequested extends FullScreenAdsEvent {
  const ShowRewardedAdRequested();
}

class EarnedReward extends FullScreenAdsEvent {
  const EarnedReward(this.reward);

  final ads.RewardItem reward;

  @override
  List<Object> get props => [reward];
}
