import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template post_grid}
/// A reusable post grid view.
/// {@endtemplate}
class PostGrid extends StatelessWidget {
  /// {@macro post_grid}
  const PostGrid({
    required this.gridGroupBlock,
    required this.premiumText,
    this.isLocked = false,
    this.onPressed,
    super.key,
  });

  /// The associated [PostGridGroupBlock] instance.
  final PostGridGroupBlock gridGroupBlock;

  /// Text displayed when post is premium content.
  final String premiumText;

  /// Whether this post is a locked post.
  final bool isLocked;

  /// An optional callback which is invoked when the action is triggered.
  /// A [Uri] from the associated [BlockAction] is provided to the callback.
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (gridGroupBlock.tiles.isEmpty) return const SizedBox();

    final firstBlock = gridGroupBlock.tiles.first;
    final otherBlocks = gridGroupBlock.tiles.skip(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (gridGroupBlock.tiles.isNotEmpty)
            PostLarge(
              block: firstBlock.toPostLargeBlock(),
              premiumText: premiumText,
              isLocked: isLocked,
              onPressed: onPressed,
            ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth / 2 - (AppSpacing.md / 2);
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: otherBlocks
                    .map(
                      (tile) => ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: PostMedium(
                          block: tile.toPostMediumBlock(),
                          onPressed: onPressed,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
