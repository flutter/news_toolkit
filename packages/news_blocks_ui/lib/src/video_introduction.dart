import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template video_introduction}
/// A reusable video introduction block widget.
/// {@endtemplate}
class VideoIntroduction extends StatelessWidget {
  /// {@macro video_introduction}
  const VideoIntroduction({
    super.key,
    required this.block,
    required this.premiumText,
  });

  /// The associated [VideoIntroductionBlock] instance.
  final VideoIntroductionBlock block;

  /// Text displayed when the associated article is premium.
  final String premiumText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InlineVideo(
          videoUrl: block.videoUrl,
          progressIndicator: const ProgressIndicator(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: PostContent(
            categoryName: block.category.name,
            title: block.title,
            premiumText: premiumText,
          ),
        ),
      ],
    );
  }
}
