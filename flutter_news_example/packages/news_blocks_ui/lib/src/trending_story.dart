import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template trending_story}
/// A reusable trending story news block widget.
/// {@endtemplate}
class TrendingStory extends StatelessWidget {
  /// {@macro trending_story}
  const TrendingStory({required this.title, required this.block, super.key});

  /// Title of the trending story.
  final String title;

  /// The associated [TrendingStoryBlock] instance.
  final TrendingStoryBlock block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.md,
          ),
          child: Text(
            title,
            style: theme.labelSmall?.apply(color: AppColors.secondary),
          ),
        ),
        PostSmall(block: block.content),
      ],
    );
  }
}
