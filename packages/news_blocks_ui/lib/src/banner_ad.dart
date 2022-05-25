import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template banner_ad}
/// A reusable banner ad block widget.
/// {@endtemplate}
class BannerAd extends StatelessWidget {
  /// {@macro banner_ad}
  const BannerAd({
    super.key,
    required this.block,
  });

  /// The associated [BannerAdBlock] instance.
  final BannerAdBlock block;

  @override
  Widget build(BuildContext context) {
    return BannerAdContainer(
      size: block.size,
      child: BannerAdContent(
        size: block.size,
      ),
    );
  }
}
