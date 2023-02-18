import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template banner_ad_container}
/// A reusable banner ad container widget.
/// {@endtemplate}
class BannerAdContainer extends StatelessWidget {
  /// {@macro banner_ad_container}
  const BannerAdContainer({required this.size, required this.child, super.key});

  /// The size of this banner ad.
  final BannerAdSize size;

  /// The [Widget] displayed in this container.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = size == BannerAdSize.normal
        ? AppSpacing.lg + AppSpacing.xs
        : AppSpacing.xlg + AppSpacing.xs + AppSpacing.xxs;

    final verticalPadding = size == BannerAdSize.normal
        ? AppSpacing.lg
        : AppSpacing.xlg + AppSpacing.sm;

    return ColoredBox(
      key: const Key('bannerAdContainer_coloredBox'),
      color: AppColors.brightGrey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: child,
      ),
    );
  }
}
