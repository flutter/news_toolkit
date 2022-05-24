import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:platform/platform.dart' as platform;
import 'package:very_good_analysis/very_good_analysis.dart';

/// {@template rewarded_ad_failed_to_load_exception}
/// An exception thrown when loading a rewarded ad fails.
/// {@endtemplate}
class RewardedAdFailedToLoadException implements Exception {
  /// {@macro rewarded_ad_failed_to_load_exception}
  RewardedAdFailedToLoadException(this.error);

  /// The error which was caught.
  final Object error;
}

/// Signature for [RewardedAd] loader.
typedef RewardedAdLoader = Future<void> Function({
  required String adUnitId,
  required ads.RewardedAdLoadCallback rewardedAdLoadCallback,
  required ads.AdRequest request,
});

/// {@template rewarded_ad}
/// A widget that shows a rewarded ad when loaded.
/// https://developers.google.com/admob/flutter/interstitial
/// {@endtemplate}
class RewardedAd extends StatefulWidget {
  /// {@macro rewarded_ad}
  const RewardedAd({
    super.key,
    required this.child,
    required this.onUserEarnedReward,
    this.adUnitId,
    this.adLoader = ads.RewardedAd.load,
    this.currentPlatform = const platform.LocalPlatform(),
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Called when the user earns a reward from this rewarded ad.
  final ads.OnUserEarnedRewardCallback onUserEarnedReward;

  /// The unit id of this rewarded ad.
  ///
  /// Defaults to [androidTestUnitId] on Android
  /// and [iosTestUnitAd] on iOS.
  final String? adUnitId;

  /// The loader of this rewarded ad.
  final RewardedAdLoader adLoader;

  /// The current platform where this rewarded ad is displayed.
  final platform.Platform currentPlatform;

  /// The Android test unit id of this rewarded ad.
  @visibleForTesting
  static const androidTestUnitId = 'ca-app-pub-3940256099942544/5224354917';

  /// The iOS test unit id of this rewarded ad.
  @visibleForTesting
  static const iosTestUnitAd = 'ca-app-pub-3940256099942544/1712485313';

  @override
  State<RewardedAd> createState() => _RewardedAdState();
}

class _RewardedAdState extends State<RewardedAd> {
  ads.RewardedAd? _ad;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAd());
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  Future<void> _loadAd() => widget.adLoader(
        adUnitId: widget.adUnitId ??
            (widget.currentPlatform.isAndroid
                ? RewardedAd.androidTestUnitId
                : RewardedAd.iosTestUnitAd),
        request: const ads.AdRequest(),
        rewardedAdLoadCallback: ads.RewardedAdLoadCallback(
          onAdLoaded: _onAdLoaded,
          onAdFailedToLoad: _onAdFailedToLoad,
        ),
      );

  void _onAdLoaded(ads.RewardedAd ad) {
    _ad = ad;
    if (mounted) {
      ad
        ..fullScreenContentCallback = ads.FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) => ad.dispose(),
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _reportError(RewardedAdFailedToLoadException(error));
          },
        )
        ..show(onUserEarnedReward: widget.onUserEarnedReward);
    }
  }

  void _onAdFailedToLoad(ads.LoadAdError error) =>
      _reportError(RewardedAdFailedToLoadException(error));

  void _reportError(Exception exception) => FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
        ),
      );
}
