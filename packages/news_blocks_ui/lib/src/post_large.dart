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
    this.premiumText = 'Premium',
  }) : super(key: key);

  /// The associated [PostLargeBlock] instance.
  final PostLargeBlock block;

  /// Text displayed when post is premium content.
  final String premiumText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(block.imageUrl),
        PostTitle(
          author: block.author,
          category: block.category.name,
          date: block.publishedAt,
          title: block.title,
          isPremium: block.isPremium,
          premiumText: premiumText,
        ),
      ],
    );
  }
}
