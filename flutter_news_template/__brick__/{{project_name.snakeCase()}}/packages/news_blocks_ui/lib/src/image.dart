import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template image}
/// A reusable image news block widget.
/// {@endtemplate}
class Image extends StatelessWidget {
  /// {@macro image}
  const Image({required this.block, super.key});

  /// The associated [ImageBlock] instance.
  final ImageBlock block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InlineImage(
        imageUrl: block.imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            ProgressIndicator(progress: downloadProgress.progress),
      ),
    );
  }
}
