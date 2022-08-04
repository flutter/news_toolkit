import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:google_news_template/ads/ads.dart';
import 'package:platform/platform.dart' as platform;
import 'package:very_good_analysis/very_good_analysis.dart';

/// {@template interstitial_ad_failed_to_load_exception}
/// An exception thrown when loading an interstitial ad fails.
/// {@endtemplate}
class InterstitialAdFailedToLoadException implements Exception {
  /// {@macro interstitial_ad_failed_to_load_exception}
  InterstitialAdFailedToLoadException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template interstitial_ad}
/// A widget that shows an interstitial ad when loaded.
/// https://developers.google.com/admob/flutter/interstitial
/// {@endtemplate}
class InterstitialAd extends StatefulWidget {
  /// {@macro interstitial_ad}
  const InterstitialAd({
    super.key,
    required this.child,
    this.adUnitId,
    this.adLoader = ads.InterstitialAd.load,
    this.currentPlatform = const platform.LocalPlatform(),
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The unit id of this interstitial ad.
  ///
  /// Defaults to [androidTestUnitId] on Android
  /// and [iosTestUnitAd] on iOS.
  final String? adUnitId;

  /// The loader of this interstitial ad.
  final InterstitialAdLoader adLoader;

  /// The current platform where this interstitial ad is displayed.
  final platform.Platform currentPlatform;

  /// The Android test unit id of this interstitial ad.
  @visibleForTesting
  static const androidTestUnitId = 'ca-app-pub-3940256099942544/1033173712';

  /// The iOS test unit id of this interstitial ad.
  @visibleForTesting
  static const iosTestUnitAd = 'ca-app-pub-3940256099942544/4411468910';

  @override
  State<InterstitialAd> createState() => _InterstitialAdState();
}

class _InterstitialAdState extends State<InterstitialAd> {
  ads.InterstitialAd? _ad;

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
                ? InterstitialAd.androidTestUnitId
                : InterstitialAd.iosTestUnitAd),
        request: const ads.AdRequest(),
        adLoadCallback: ads.InterstitialAdLoadCallback(
          onAdLoaded: _onAdLoaded,
          onAdFailedToLoad: _onAdFailedToLoad,
        ),
      );

  void _onAdLoaded(ads.InterstitialAd ad) {
    _ad = ad;
    if (mounted) {
      ad
        ..fullScreenContentCallback = ads.FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) => ad.dispose(),
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _reportError(InterstitialAdFailedToLoadException(error));
          },
        )
        ..show();
    }
  }

  void _onAdFailedToLoad(ads.LoadAdError error) =>
      _reportError(InterstitialAdFailedToLoadException(error));

  void _reportError(Exception exception) => FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: StackTrace.current,
        ),
      );
}
