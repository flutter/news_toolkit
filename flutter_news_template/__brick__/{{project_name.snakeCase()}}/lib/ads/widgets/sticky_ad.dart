import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template sticky_ad}
/// A bottom-anchored, adaptive ad widget.
/// https://developers.google.com/admob/flutter/banner/anchored-adaptive
/// {@endtemplate}
class StickyAd extends StatefulWidget {
  /// {@macro sticky_ad}
  const StickyAd({super.key});

  static const padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg + AppSpacing.xs,
    vertical: AppSpacing.lg,
  );

  @override
  State<StickyAd> createState() => _StickyAdState();
}

class _StickyAdState extends State<StickyAd> {
  var _adLoaded = false;
  var _adClosed = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final adWidth =
        (deviceWidth - StickyAd.padding.left - StickyAd.padding.right)
            .truncate();

    return !_adClosed
        ? Stack(
            children: [
              if (_adLoaded) const StickyAdCloseIconBackground(),
              StickyAdContainer(
                key: const Key('stickyAd_container'),
                shadowEnabled: _adLoaded,
                child: BannerAdContent(
                  size: BannerAdSize.anchoredAdaptive,
                  anchoredAdaptiveWidth: adWidth,
                  onAdLoaded: () => setState(() => _adLoaded = true),
                  showProgressIndicator: false,
                ),
              ),
              if (_adLoaded)
                StickyAdCloseIcon(
                  onAdClosed: () => setState(() => _adClosed = true),
                ),
            ],
          )
        : const SizedBox();
  }
}

@visibleForTesting
class StickyAdContainer extends StatelessWidget {
  const StickyAdContainer({
    required this.child,
    required this.shadowEnabled,
    super.key,
  });

  final Widget child;
  final bool shadowEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md + AppSpacing.xxs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: shadowEnabled ? AppColors.white : AppColors.transparent,
          boxShadow: [
            if (shadowEnabled)
              BoxShadow(
                color: AppColors.black.withOpacity(0.3),
                blurRadius: 3,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: SafeArea(
          left: false,
          top: false,
          right: false,
          child: Padding(
            padding: StickyAd.padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class StickyAdCloseIcon extends StatelessWidget {
  const StickyAdCloseIcon({
    required this.onAdClosed,
    super.key,
  });

  final VoidCallback onAdClosed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppSpacing.lg,
      child: GestureDetector(
        onTap: onAdClosed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxs),
            child: Assets.icons.closeCircleFilled.svg(),
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class StickyAdCloseIconBackground extends StatelessWidget {
  const StickyAdCloseIconBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppSpacing.lg,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.3),
              blurRadius: 3,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxs),
          child: Assets.icons.closeCircleFilled.svg(),
        ),
      ),
    );
  }
}
