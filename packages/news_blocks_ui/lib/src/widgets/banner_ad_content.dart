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

/// Signature for [BannerAd] builder.
typedef BannerAdBuilder = BannerAd Function({
  required AdSize size,
  required String adUnitId,
  required BannerAdListener listener,
  required AdRequest request,
});

/// {@template banner_ad_content}
/// A reusable content of a banner ad.
/// {@endtemplate}
class BannerAdContent extends StatefulWidget {
  /// {@macro banner_ad_content}
  const BannerAdContent({
    super.key,
    required this.size,
    this.adUnitId,
    this.adBuilder = BannerAd.new,
    this.currentPlatform = const platform.LocalPlatform(),
  });

  /// The size of this banner ad.
  final BannerAdSize size;

  /// The unit id of this banner ad.
  ///
  /// Defaults to [androidTestUnitId] on Android
  /// and [iosTestUnitAd] on iOS.
  final String? adUnitId;

  /// The builder of this banner ad.
  final BannerAdBuilder adBuilder;

  /// The current platform where this banner ad is displayed.
  final platform.Platform currentPlatform;

  /// The Android test unit id of this banner ad.
  @visibleForTesting
  static const androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';

  /// The iOS test unit id of this banner ad.
  @visibleForTesting
  static const iosTestUnitAd = 'ca-app-pub-3940256099942544/2934735716';

  /// The size values of this banner ad.
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
  late final BannerAd _ad;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    _ad = widget.adBuilder(
      adUnitId: widget.currentPlatform.isAndroid
          ? BannerAdContent.androidTestUnitId
          : BannerAdContent.iosTestUnitAd,
      request: const AdRequest(),
      size: BannerAdContent._sizeValues[widget.size]!,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _adLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: BannerAdFailedToLoadException(error),
              stack: StackTrace.current,
            ),
          );
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      key: const Key('bannerAdContent_sizedBox'),
      width: _ad.size.width.toDouble(),
      height: _ad.size.height.toDouble(),
      child: Center(
        child: _adLoaded
            ? AdWidget(ad: _ad)
            : const ProgressIndicator(color: AppColors.transparent),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
