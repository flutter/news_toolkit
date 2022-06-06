import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template post_content_category}
/// A widget displaying the category of a post
/// or a premium label if the post is premium.
/// {@endtemplate}
class PostContentCategory extends StatelessWidget {
  /// {@macro post_content_category}
  const PostContentCategory({
    super.key,
    required this.categoryName,
    required this.isPremium,
    required this.premiumText,
    required this.isContentOverlaid,
    required this.isSubscriberExclusive,
    required this.isVideoContent,
  });

  /// Category of post.
  final String categoryName;

  /// Whether this post requires a premium subscription to access.
  final bool isPremium;

  /// Text displayed when post is premium content.
  final String premiumText;

  /// Whether this category should be overlaid on the image.
  final bool isContentOverlaid;

  /// Whether this post is subscriber exclusive.
  final bool isSubscriberExclusive;

  /// Whether content is a part of a video article.
  final bool isVideoContent;

  @override
  Widget build(BuildContext context) {
    // Category label hierarchy
    // isSubscriberExclusive > isPremium > isContentOverlaid
    final backgroundColor = isSubscriberExclusive
        ? AppColors.secondary
        : isPremium
            ? AppColors.redWine
            : isContentOverlaid
                ? AppColors.secondary
                : AppColors.transparent;

    final isCategoryBackgroundDark =
        isPremium || isContentOverlaid || isSubscriberExclusive;

    final textColor = isVideoContent
        ? AppColors.orange
        : isCategoryBackgroundDark
            ? AppColors.white
            : AppColors.secondary;
    final shouldCategoryNameDisplay =
        isPremium || isSubscriberExclusive ? premiumText : categoryName;
    final horizontalSpacing = isCategoryBackgroundDark ? AppSpacing.xs : 0.0;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalSpacing,
                0,
                horizontalSpacing,
                AppSpacing.xxs,
              ),
              child: Text(
                shouldCategoryNameDisplay.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .overline
                    ?.copyWith(color: textColor),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
