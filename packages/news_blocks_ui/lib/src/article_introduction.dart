import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

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
    this.onSharePressed,
    this.onFacebookSharePressed,
  });

  /// The associated [ArticleIntroductionBlock] instance.
  final ArticleIntroductionBlock block;

  /// Text displayed when article is premium content.
  final String premiumText;

  /// Text displayed over the share button.
  final String shareText;

  /// An optional callback which is invoked when the share button is pressed.
  final VoidCallback? onSharePressed;

  /// An optional callback which is invoked when
  /// the Facebook share button is pressed.
  final VoidCallback? onFacebookSharePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (block.imageUrl != null) InlineImage(imageUrl: block.imageUrl!),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: PostContent(
            categoryName: block.category.name,
            title: block.title,
            author: block.author,
            publishedAt: block.publishedAt,
            premiumText: premiumText,
            isPremium: block.isPremium,
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: AppSpacing.lg),
                if (onFacebookSharePressed != null)
                  FacebookShareButton(
                    key: const Key('articleIntroduction_facebookShareButton'),
                    onTap: onFacebookSharePressed,
                  ),
              ],
            ),
            Row(
              children: [
                if (onSharePressed != null)
                  ShareButton(
                    key: const Key('articleIntroduction_shareButton'),
                    shareText: shareText,
                    color: AppColors.darkAqua,
                    onPressed: onSharePressed,
                  ),
                const SizedBox(width: AppSpacing.lg),
              ],
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
