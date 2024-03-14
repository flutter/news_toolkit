import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template video_introduction}
/// A reusable video introduction block widget.
/// {@endtemplate}
class VideoIntroduction extends StatelessWidget {
  /// {@macro video_introduction}
  const VideoIntroduction({required this.block, super.key});

  /// The associated [VideoIntroductionBlock] instance.
  final VideoIntroductionBlock block;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InlineVideo(
          videoUrl: block.videoUrl,
          progressIndicator: const ProgressIndicator(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: PostContent(
            categoryName: block.category.name,
            title: block.title,
            isVideoContent: true,
          ),
        ),
      ],
    );
  }
}
