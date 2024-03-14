import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template banner_ad}
/// A reusable banner ad block widget.
/// {@endtemplate}
class BannerAd extends StatelessWidget {
  /// {@macro banner_ad}
  const BannerAd({
    required this.block,
    required this.adFailedToLoadTitle,
    super.key,
  });

  /// The associated [BannerAdBlock] instance.
  final BannerAdBlock block;

  /// The title displayed when this ad fails to load.
  final String adFailedToLoadTitle;

  @override
  Widget build(BuildContext context) {
    return BannerAdContainer(
      size: block.size,
      child: BannerAdContent(
        size: block.size,
        adFailedToLoadTitle: adFailedToLoadTitle,
      ),
    );
  }
}
