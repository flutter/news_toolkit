import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:platform/platform.dart';

part 'full_screen_ads_event.dart';
part 'full_screen_ads_state.dart';

/// Signature for the interstitial ad loader.
typedef InterstitialAdLoader = Future<void> Function({
  required String adUnitId,
  required ads.InterstitialAdLoadCallback adLoadCallback,
  required ads.AdRequest request,
});

/// Signature for the rewarded ad loader.
typedef RewardedAdLoader = Future<void> Function({
  required String adUnitId,
  required ads.RewardedAdLoadCallback rewardedAdLoadCallback,
  required ads.AdRequest request,
});

/// A bloc that manages pre-loading and showing interstitial and rewarded ads
/// with an [_adsRetryPolicy].
class FullScreenAdsBloc extends Bloc<FullScreenAdsEvent, FullScreenAdsState> {
  FullScreenAdsBloc({
    required AdsRetryPolicy adsRetryPolicy,
    required InterstitialAdLoader interstitialAdLoader,
    required RewardedAdLoader rewardedAdLoader,
    required LocalPlatform localPlatform,
    FullScreenAdsConfig? fullScreenAdsConfig,
  })  : _adsRetryPolicy = adsRetryPolicy,
        _interstitialAdLoader = interstitialAdLoader,
        _rewardedAdLoader = rewardedAdLoader,
        _localPlatform = localPlatform,
        _fullScreenAdsConfig =
            fullScreenAdsConfig ?? const FullScreenAdsConfig(),
        super(const FullScreenAdsState.initial()) {
    on<LoadInterstitialAdRequested>(_onLoadInterstitialAdRequested);
    on<LoadRewardedAdRequested>(_onLoadRewardedAdRequested);
    on<ShowInterstitialAdRequested>(_onShowInterstitialAdRequested);
    on<ShowRewardedAdRequested>(_onShowRewardedAdRequested);
    on<EarnedReward>(_onEarnedReward);
  }

  /// The retry policy for loading interstitial and rewarded ads.
  final AdsRetryPolicy _adsRetryPolicy;

  /// The config of interstitial and rewarded ads.
  final FullScreenAdsConfig _fullScreenAdsConfig;

  /// The loader of interstitial ads.
  final InterstitialAdLoader _interstitialAdLoader;

  /// The loader of rewarded ads.
  final RewardedAdLoader _rewardedAdLoader;

  /// The current platform.
  final LocalPlatform _localPlatform;

  Future<void> _onLoadInterstitialAdRequested(
    LoadInterstitialAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    try {
      final ad = Completer<ads.InterstitialAd>();

      emit(state.copyWith(status: FullScreenAdsStatus.loadingInterstitialAd));

      await _interstitialAdLoader(
        adUnitId: _fullScreenAdsConfig.interstitialAdUnitId ??
            (_localPlatform.isAndroid
                ? FullScreenAdsConfig.androidTestInterstitialAdUnitId
                : FullScreenAdsConfig.iosTestInterstitialAdUnitId),
        request: const ads.AdRequest(),
        adLoadCallback: ads.InterstitialAdLoadCallback(
          onAdLoaded: ad.complete,
          onAdFailedToLoad: ad.completeError,
        ),
      );

      final adResult = await ad.future;

      emit(
        state.copyWith(
          interstitialAd: adResult,
          status: FullScreenAdsStatus.loadingInterstitialAdSucceeded,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FullScreenAdsStatus.loadingInterstitialAdFailed,
        ),
      );

      addError(error, stackTrace);

      if (event.retry < _adsRetryPolicy.maxRetryCount) {
        final nextRetry = event.retry + 1;
        await Future<void>.delayed(
          _adsRetryPolicy.getIntervalForRetry(nextRetry),
        );
        add(LoadInterstitialAdRequested(retry: nextRetry));
      }
    }
  }

  Future<void> _onLoadRewardedAdRequested(
    LoadRewardedAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    try {
      final ad = Completer<ads.RewardedAd>();

      emit(state.copyWith(status: FullScreenAdsStatus.loadingRewardedAd));

      await _rewardedAdLoader(
        adUnitId: _fullScreenAdsConfig.rewardedAdUnitId ??
            (_localPlatform.isAndroid
                ? FullScreenAdsConfig.androidTestRewardedAdUnitId
                : FullScreenAdsConfig.iosTestRewardedAdUnitId),
        request: const ads.AdRequest(),
        rewardedAdLoadCallback: ads.RewardedAdLoadCallback(
          onAdLoaded: ad.complete,
          onAdFailedToLoad: ad.completeError,
        ),
      );

      final adResult = await ad.future;

      emit(
        state.copyWith(
          rewardedAd: adResult,
          status: FullScreenAdsStatus.loadingRewardedAdSucceeded,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FullScreenAdsStatus.loadingRewardedAdFailed,
        ),
      );

      addError(error, stackTrace);

      if (event.retry < _adsRetryPolicy.maxRetryCount) {
        final nextRetry = event.retry + 1;
        await Future<void>.delayed(
          _adsRetryPolicy.getIntervalForRetry(nextRetry),
        );
        add(LoadRewardedAdRequested(retry: nextRetry));
      }
    }
  }

  Future<void> _onShowInterstitialAdRequested(
    ShowInterstitialAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FullScreenAdsStatus.showingInterstitialAd));

      state.interstitialAd?.fullScreenContentCallback =
          ads.FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) => ad.dispose(),
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          addError(error);
        },
      );

      // Show currently available interstitial ad.
      await state.interstitialAd?.show();

      emit(
        state.copyWith(
          status: FullScreenAdsStatus.showingInterstitialAdSucceeded,
        ),
      );

      // Load the next interstitial ad.
      add(const LoadInterstitialAdRequested());
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FullScreenAdsStatus.showingInterstitialAdFailed,
        ),
      );

      addError(error, stackTrace);
    }
  }

  Future<void> _onShowRewardedAdRequested(
    ShowRewardedAdRequested event,
    Emitter<FullScreenAdsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FullScreenAdsStatus.showingRewardedAd));

      state.rewardedAd?.fullScreenContentCallback =
          ads.FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) => ad.dispose(),
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          addError(error);
        },
      );

      // Show currently available rewarded ad.
      await state.rewardedAd?.show(
        onUserEarnedReward: (ad, earnedReward) => add(
          EarnedReward(earnedReward),
        ),
      );

      emit(
        state.copyWith(
          status: FullScreenAdsStatus.showingRewardedAdSucceeded,
        ),
      );

      // Load the next rewarded ad.
      add(const LoadRewardedAdRequested());
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FullScreenAdsStatus.showingRewardedAdFailed,
        ),
      );

      addError(error, stackTrace);
    }
  }

  void _onEarnedReward(EarnedReward event, Emitter<FullScreenAdsState> emit) =>
      emit(state.copyWith(earnedReward: event.reward));
}
