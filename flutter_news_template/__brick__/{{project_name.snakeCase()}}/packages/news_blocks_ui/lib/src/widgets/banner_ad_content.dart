import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';
import 'package:platform/platform.dart' as platform;

/// {@template banner_ad_failed_to_load_exception}
/// An exception thrown when loading a banner ad fails.
/// {@endtemplate}
class BannerAdFailedToLoadException implements Exception {
  /// {@macro banner_ad_failed_to_load_exception}
  BannerAdFailedToLoadException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template banner_ad_failed_to_get_size_exception}
/// An exception thrown when getting a banner ad size fails.
/// {@endtemplate}
class BannerAdFailedToGetSizeException implements Exception {
  /// {@macro banner_ad_failed_to_get_size_exception}
  BannerAdFailedToGetSizeException();
}

/// Signature for [BannerAd] builder.
typedef BannerAdBuilder = BannerAd Function({
  required AdSize size,
  required String adUnitId,
  required BannerAdListener listener,
  required AdRequest request,
});

/// Signature for [AnchoredAdaptiveBannerAdSize] provider.
typedef AnchoredAdaptiveAdSizeProvider = Future<AnchoredAdaptiveBannerAdSize?>
    Function(
  Orientation orientation,
  int width,
);

/// {@template banner_ad_content}
/// A reusable content of a banner ad.
/// {@endtemplate}
class BannerAdContent extends StatefulWidget {
  /// {@macro banner_ad_content}
  const BannerAdContent({
    required this.size,
    this.adFailedToLoadTitle,
    this.adsRetryPolicy = const AdsRetryPolicy(),
    this.anchoredAdaptiveWidth,
    this.adUnitId,
    this.adBuilder = BannerAd.new,
    this.anchoredAdaptiveAdSizeProvider =
        AdSize.getAnchoredAdaptiveBannerAdSize,
    this.currentPlatform = const platform.LocalPlatform(),
    this.onAdLoaded,
    this.showProgressIndicator = true,
    super.key,
  });

  /// The size of this banner ad.
  final BannerAdSize size;

  /// The title displayed when this ad fails to load.
  final String? adFailedToLoadTitle;

  /// The retry policy for loading ads.
  final AdsRetryPolicy adsRetryPolicy;

  /// The width of this banner ad for [BannerAdSize.anchoredAdaptive].
  ///
  /// Defaults to the width of the device.
  final int? anchoredAdaptiveWidth;

  /// The unit id of this banner ad.
  ///
  /// Defaults to [androidTestUnitId] on Android
  /// and [iosTestUnitAd] on iOS.
  final String? adUnitId;

  /// The builder of this banner ad.
  final BannerAdBuilder adBuilder;

  /// The provider for this banner ad for [BannerAdSize.anchoredAdaptive].
  final AnchoredAdaptiveAdSizeProvider anchoredAdaptiveAdSizeProvider;

  /// The current platform where this banner ad is displayed.
  final platform.Platform currentPlatform;

  /// Called once when this banner ad loads.
  final VoidCallback? onAdLoaded;

  /// Whether the progress indicator should be shown when the ad is loading.
  ///
  /// Defaults to true.
  final bool showProgressIndicator;

  /// The Android test unit id of this banner ad.
  @visibleForTesting
  static const androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';

  /// The iOS test unit id of this banner ad.
  @visibleForTesting
  static const iosTestUnitAd = 'ca-app-pub-3940256099942544/2934735716';

  /// The size values of this banner ad.
  ///
  /// The width of [BannerAdSize.anchoredAdaptive] depends on
  /// [anchoredAdaptiveWidth] and is defined in
  /// [_BannerAdContentState._getAnchoredAdaptiveAdSize].
  /// The height of such an ad is determined by Google.
  static const _sizeValues = <BannerAdSize, AdSize>{
    BannerAdSize.normal: AdSize.banner,
    BannerAdSize.large: AdSize.mediumRectangle,
    BannerAdSize.extraLarge: AdSize(width: 300, height: 600),
  };

  @override
  State<BannerAdContent> createState() => _BannerAdContentState();
}

class _BannerAdContentState extends State<BannerAdContent>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _ad;
  AdSize? _adSize;
  bool _adLoaded = false;
  bool _adFailedToLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    unawaited(_loadAd());
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adFailedToLoadTitle = widget.adFailedToLoadTitle;
    return SizedBox(
      key: const Key('bannerAdContent_sizedBox'),
      width: (_adSize?.width ?? 0).toDouble(),
      height: (_adSize?.height ?? 0).toDouble(),
      child: Center(
        child: _adLoaded
            ? AdWidget(ad: _ad!)
            : _adFailedToLoad && adFailedToLoadTitle != null
                ? Text(adFailedToLoadTitle)
                : widget.showProgressIndicator
                    ? const ProgressIndicator(color: AppColors.transparent)
                    : const SizedBox(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadAd() async {
    AdSize? adSize;
    if (widget.size == BannerAdSize.anchoredAdaptive) {
      adSize = await _getAnchoredAdaptiveAdSize();
    } else {
      adSize = BannerAdContent._sizeValues[widget.size];
    }
    setState(() => _adSize = adSize);

    if (_adSize == null) {
      return _reportError(
        BannerAdFailedToGetSizeException(),
        StackTrace.current,
      );
    }

    await _loadAdInstance();
  }

  Future<void> _loadAdInstance({int retry = 0}) async {
    if (!mounted) return;

    try {
      final adCompleter = Completer<Ad>();

      setState(
        () => _ad = widget.adBuilder(
          adUnitId: widget.adUnitId ??
              (widget.currentPlatform.isAndroid
                  ? BannerAdContent.androidTestUnitId
                  : BannerAdContent.iosTestUnitAd),
          request: const AdRequest(),
          size: _adSize!,
          listener: BannerAdListener(
            onAdLoaded: adCompleter.complete,
            onAdFailedToLoad: (_, error) {
              adCompleter.completeError(error);
            },
          ),
        )..load(),
      );

      _onAdLoaded(await adCompleter.future);
    } catch (error, stackTrace) {
      _reportError(BannerAdFailedToLoadException(error), stackTrace);

      if (retry < widget.adsRetryPolicy.maxRetryCount) {
        final nextRetry = retry + 1;
        await Future<void>.delayed(
          widget.adsRetryPolicy.getIntervalForRetry(nextRetry),
        );
        return _loadAdInstance(retry: nextRetry);
      } else {
        if (mounted) setState(() => _adFailedToLoad = true);
      }
    }
  }

  void _onAdLoaded(Ad ad) {
    if (mounted) {
      setState(() {
        _ad = ad as BannerAd;
        _adLoaded = true;
      });
      widget.onAdLoaded?.call();
    }
  }

  /// Returns an ad size for [BannerAdSize.anchoredAdaptive].
  ///
  /// Only supports the portrait mode.
  Future<AnchoredAdaptiveBannerAdSize?> _getAnchoredAdaptiveAdSize() async {
    final adWidth = widget.anchoredAdaptiveWidth ??
        MediaQuery.of(context).size.width.truncate();
    return widget.anchoredAdaptiveAdSizeProvider(
      Orientation.portrait,
      adWidth,
    );
  }

  void _reportError(Object exception, StackTrace stackTrace) =>
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stackTrace,
        ),
      );
}
