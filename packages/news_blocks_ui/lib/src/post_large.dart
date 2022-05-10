import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template post_large}
/// A reusable post large block widget.
/// {@endtemplate}
class PostLarge extends StatelessWidget {
  /// {@macro post_large}
  const PostLarge({
    Key? key,
    required this.block,
    required this.premiumText,
    this.onPressed,
  }) : super(key: key);

  /// The associated [PostLargeBlock] instance.
  final PostLargeBlock block;

  /// Text displayed when post is premium content.
  final String premiumText;

  /// An optional callback which is invoked when the action is triggered.
  /// A [Uri] from the associated [BlockAction] is provided to the callback.
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          block.hasNavigationAction ? onPressed?.call(block.action!) : null,
      child: PostLargeContainer(
        isContentOverlaid: block.isContentOverlaid,
        children: [
          PostLargeImage(
            isContentOverlaid: block.isContentOverlaid,
            imageUrl: block.imageUrl!,
          ),
          PostHeaderContent(
            author: block.author,
            categoryName: block.category.name,
            publishedAt: block.publishedAt,
            title: block.title,
            isPremium: block.isPremium,
            premiumText: premiumText,
            isContentOverlaid: block.isContentOverlaid,
          ),
        ],
      ),
    );
  }
}

/// {@template post_large_container}
/// A post container of large block widget which decides on build layout.
/// {@endtemplate}
@visibleForTesting
class PostLargeContainer extends StatelessWidget {
  /// {@macro post_large_container}
  const PostLargeContainer({
    Key? key,
    required this.children,
    required this.isContentOverlaid,
  }) : super(key: key);

  /// List containing children to be laid out.
  final List<Widget> children;

  /// Whether children should be laid out in stack.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overlaidTheme = theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        headline3: theme.textTheme.headline3?.copyWith(
          color: AppColors.highEmphasisPrimary,
        ),
        caption: theme.textTheme.caption?.copyWith(
          color: AppColors.mediumHighEmphasisPrimary,
        ),
      ),
    );
    final defaultTheme = theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        headline3: theme.textTheme.headline3?.copyWith(
          color: AppColors.highEmphasisSurface,
        ),
        caption: theme.textTheme.caption?.copyWith(
          color: AppColors.mediumEmphasisSurface,
        ),
      ),
    );

    return Theme(
      data: isContentOverlaid ? overlaidTheme : defaultTheme,
      child: isContentOverlaid
          ? AspectRatio(
              aspectRatio: 3 / 2,
              child: Stack(children: children),
            )
          : Column(children: children),
    );
  }
}
