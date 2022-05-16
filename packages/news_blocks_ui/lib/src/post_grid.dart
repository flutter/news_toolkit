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
    super.key,
    required this.gridGroupBlock,
    required this.premiumText,
    this.onPressed,
  });

  /// The associated [PostGridGroupBlock] instance.
  final PostGridGroupBlock gridGroupBlock;

  /// Text displayed when post is premium content.
  final String premiumText;

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
        children: [
          if (gridGroupBlock.tiles.isNotEmpty)
            PostLarge(
              block: firstBlock.toPostLargeBlock(),
              premiumText: premiumText,
              onPressed: onPressed,
            ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: OverlaidImage.aspectRatio,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            children: otherBlocks
                .map(
                  (tile) => PostMedium(
                    block: tile.toPostMediumBlock(),
                    onPressed: onPressed,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
