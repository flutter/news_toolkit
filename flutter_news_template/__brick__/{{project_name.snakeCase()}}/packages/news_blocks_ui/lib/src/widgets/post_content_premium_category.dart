import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template post_content_premium_category}
/// A widget displaying a premium label on a post.
/// {@endtemplate}
class PostContentPremiumCategory extends StatelessWidget {
  /// {@macro post_content_premium_category}
  const PostContentPremiumCategory({
    required this.premiumText,
    required this.isVideoContent,
    super.key,
  });

  /// Text displayed when post is premium content.
  final String premiumText;

  /// Whether content is a part of a video article.
  final bool isVideoContent;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.redWine;
    const textColor = AppColors.white;
    const horizontalSpacing = AppSpacing.xs;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: const BoxDecoration(color: backgroundColor),
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
                    .labelSmall
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
