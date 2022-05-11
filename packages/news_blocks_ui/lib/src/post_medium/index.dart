import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/post_medium/post_medium_description_layout.dart';
import 'package:news_blocks_ui/src/post_medium/post_medium_overlaid_layout.dart';

/// {@template post_medium}
/// A reusable post medium block widget.
/// {@endtemplate}
class PostMedium extends StatelessWidget {
  /// {@macro post_medium}
  const PostMedium({
    Key? key,
    required this.block,
    this.onPressed,
  }) : super(key: key);

  /// The associated [PostMediumBlock] instance.
  final PostMediumBlock block;

  /// An optional callback which is invoked when the action is triggered.
  /// A [Uri] from the associated [BlockAction] is provided to the callback.
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overlaidTheme = theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        subtitle2: theme.textTheme.subtitle2?.copyWith(
          color: AppColors.highEmphasisPrimary,
        ),
      ),
    );
    final defaultTheme = theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        headline6: theme.textTheme.headline6?.copyWith(
          color: AppColors.highEmphasisSurface,
        ),
        bodyText2: theme.textTheme.bodyText2?.copyWith(
          color: AppColors.mediumEmphasisSurface,
        ),
        caption: theme.textTheme.caption?.copyWith(
          color: AppColors.mediumEmphasisSurface,
        ),
      ),
    );

    return Theme(
      data: block.isContentOverlaid ? overlaidTheme : defaultTheme,
      child: GestureDetector(
        onTap: () =>
            block.hasNavigationAction ? onPressed?.call(block.action!) : null,
        child: block.isContentOverlaid
            ? PostMediumOverlaidLayout(
                title: block.title,
                imageUrl: block.imageUrl!,
              )
            : PostMediumDescriptionLayout(
                title: block.title,
                imageUrl: block.imageUrl!,
                description: block.description!,
                publishedAt: block.publishedAt,
                author: block.author,
              ),
      ),
    );
  }
}
