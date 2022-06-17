import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template post_content_category}
/// A widget displaying the category of a post
/// or a premium label if the post is premium.
/// {@endtemplate}
class PostContentPremiumCategory extends StatelessWidget {
  /// {@macro post_content_category}
  const PostContentPremiumCategory({
    super.key,
    required this.premiumText,
    required this.isSubscriberExclusive,
    required this.isVideoContent,
  });

  /// Text displayed when post is premium content.
  final String premiumText;

  /// Whether this post is subscriber exclusive.
  final bool isSubscriberExclusive;

  /// Whether content is a part of a video article.
  final bool isVideoContent;

  @override
  Widget build(BuildContext context) {
    // Category label hierarchy
    // isSubscriberExclusive > isPremium
    final backgroundColor =
        isSubscriberExclusive ? AppColors.secondary : AppColors.redWine;

    final textColor = isVideoContent ? AppColors.orange : AppColors.secondary;

    const horizontalSpacing = AppSpacing.xs;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                horizontalSpacing,
                0,
                horizontalSpacing,
                AppSpacing.xxs,
              ),
              child: Text(
                premiumText.toUpperCase(),
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
