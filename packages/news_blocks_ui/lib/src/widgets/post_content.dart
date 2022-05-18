import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template post_content}
/// A post widget displaying post content.
/// {@endtemplate}
class PostContent extends StatelessWidget {
  /// {@macro post_content}
  const PostContent({
    super.key,
    required this.title,
    this.publishedAt,
    this.categoryName,
    this.description,
    this.author,
    this.onShare,
    this.isPremium = false,
    this.isContentOverlaid = false,
    this.isSubscriberExclusive = false,
    required this.premiumText,
  });

  /// Title of post.
  final String title;

  /// The date when this post was published.
  final DateTime? publishedAt;

  /// Category of post.
  final String? categoryName;

  /// Description of post.
  final String? description;

  /// Author of post.
  final String? author;

  /// Called when the share button is tapped.
  final VoidCallback? onShare;

  /// Whether this post requires a premium subscription to access.
  ///
  /// Defaults to false.
  final bool isPremium;

  /// Whether this post is subscriber exclusive.
  ///
  /// Defaults to false.
  final bool isSubscriberExclusive;

  /// Whether content is displayed overlaid.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  /// Text displayed when post is premium content.
  final String premiumText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: isContentOverlaid
          ? const EdgeInsets.symmetric(horizontal: AppSpacing.lg)
          : EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: AppSpacing.lg),
          if (categoryName?.isNotEmpty ?? false)
            PostContentCategory(
              categoryName: categoryName!,
              isPremium: isPremium,
              premiumText: premiumText,
              isContentOverlaid: isContentOverlaid,
              isSubscriberExclusive: isSubscriberExclusive,
            ),
          Text(
            title,
            style: textTheme.headline3?.copyWith(
              color: isContentOverlaid
                  ? AppColors.highEmphasisPrimary
                  : AppColors.highEmphasisSurface,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          PostFooter(
            publishedAt: publishedAt,
            author: author,
            onShare: onShare,
            isContentOverlaid: isContentOverlaid,
          ),
          const SizedBox(height: AppSpacing.xlg + AppSpacing.sm),
        ],
      ),
    );
  }
}
