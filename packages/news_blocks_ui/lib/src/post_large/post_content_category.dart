import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template post_content_category}
/// A widget displaying category text of a post.
/// {@endtemplate}
class PostContentCategory extends StatelessWidget {
  /// {@macro post_content_category}
  const PostContentCategory({
    Key? key,
    required this.categoryName,
    required this.isPremium,
    required this.premiumText,
    required this.isContentOverlaid,
  }) : super(key: key);

  /// Category of post.
  final String categoryName;

  /// Whether this post requires a premium subscription to access.
  final bool isPremium;

  /// Text displayed when post is premium content.
  final String premiumText;

  /// Wether this category is displayed over overlay.
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    // Premium category label is always prioritized over overlaid category view.
    final backgroundColor = isPremium
        ? AppColors.redWine
        : isContentOverlaid
            ? AppColors.secondary
            : AppColors.transparent;
    final textColor =
        isPremium || isContentOverlaid ? AppColors.white : AppColors.secondary;
    final categoryDisplay = isPremium ? premiumText : categoryName;
    final horizontalSpacing =
        backgroundColor != AppColors.transparent ? AppSpacing.xs : 0.0;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalSpacing,
                0,
                horizontalSpacing,
                AppSpacing.xxs,
              ),
              child: Text(
                categoryDisplay.toUpperCase(),
                style: Theme.of(context).textTheme.overline?.copyWith(
                      color: textColor,
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
