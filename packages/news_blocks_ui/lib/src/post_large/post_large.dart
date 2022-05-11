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
  }) : super(key: key);

  /// The associated [PostLargeBlock] instance.
  final PostLargeBlock block;

  /// Text displayed when post is premium content.
  final String premiumText;

  @override
  Widget build(BuildContext context) {
    return PostLargeContainer(
      isContentOverlaid: block.isContentOverlaid,
      children: [
        PostLargeImage(
          isContentOverlaid: block.isContentOverlaid,
          imageUrl: block.imageUrl!,
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

  /// Whether the content of this post should be overlaid on the image.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    return isContentOverlaid
        ? Stack(alignment: Alignment.bottomLeft, children: children)
        : Column(children: children);
  }
}
