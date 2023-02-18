import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template post_large}
/// A reusable post large block widget.
/// {@endtemplate}
class PostLarge extends StatelessWidget {
  /// {@macro post_large}
  const PostLarge({
    required this.block,
    required this.premiumText,
    required this.isLocked,
    this.onPressed,
    super.key,
  });

  /// The associated [PostLargeBlock] instance.
  final PostLargeBlock block;

  /// Text displayed when post is premium content.
  final String premiumText;

  /// Whether this post is a locked post.
  final bool isLocked;

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
            isLocked: isLocked,
          ),
          PostContent(
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
    required this.children,
    required this.isContentOverlaid,
    super.key,
  });

  /// List containing children to be laid out.
  final List<Widget> children;

  /// Whether the content of this post should be overlaid on the image.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    return isContentOverlaid
        ? Stack(
            key: const Key('postLarge_stack'),
            alignment: Alignment.bottomLeft,
            children: children,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              key: const Key('postLarge_column'),
              children: children,
            ),
          );
  }
}
