import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template video}
/// A reusable video news block widget.
/// {@endtemplate}
class Video extends StatelessWidget {
  /// {@macro video}
  const Video({required this.block, super.key});

  /// The associated [VideoBlock] instance.
  final VideoBlock block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InlineVideo(
        videoUrl: block.videoUrl,
        progressIndicator: const ProgressIndicator(),
      ),
    );
  }
}
