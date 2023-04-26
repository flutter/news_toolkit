import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/sliver_grid_custom_delegates.dart';

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

    final deviceWidth = MediaQuery.of(context).size.width;
    final list = [...gridGroupBlock.tiles];
    final newList = List.generate(2, (index) => list[index % 4]);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      sliver: SliverGrid(
        gridDelegate: CustomMaxCrossAxisDelegate(
          maxCrossAxisExtent: deviceWidth / 2 - (AppSpacing.md / 2),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 3 / 2,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            print('Item $index rendered');
            if (index == 0) {
              return PostLarge(
                block: firstBlock.toPostLargeBlock(),
                premiumText: premiumText,
                isLocked: isLocked,
                onPressed: onPressed,
              );
            }

            return PostMedium(
              block: newList.toList()[index].toPostMediumBlock(),
              onPressed: onPressed,
            );
          },
          childCount: newList.length,
        ),
      ),
    );
  }
}
