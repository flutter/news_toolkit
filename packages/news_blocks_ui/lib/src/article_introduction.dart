import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/share_button.dart';

/// {@template article_introduction}
/// A reusable article introduction block widget.
/// {@endtemplate}
class ArticleIntroduction extends StatelessWidget {
  /// {@macro article_introduction}
  const ArticleIntroduction({
    super.key,
    required this.block,
    required this.premiumText,
    required this.shareText,
  });

  /// The associated [ArticleIntroductionBlock] instance.
  final ArticleIntroductionBlock block;

  /// Text displayed when article is premium content.
  final String premiumText;

  /// Text displayed over the share button.
  final String shareText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (block.imageUrl != null) InlineImage(imageUrl: block.imageUrl!),
        PostContent(
          categoryName: block.category.name,
          title: block.title,
          author: block.author,
          publishedAt: block.publishedAt,
          premiumText: premiumText,
        ),
        const Divider(),
        Align(
          alignment: Alignment.centerRight,
          child: ShareButton(shareText: shareText),
        ),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
