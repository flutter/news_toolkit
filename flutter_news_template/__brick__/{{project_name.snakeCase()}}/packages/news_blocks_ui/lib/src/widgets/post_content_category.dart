import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template post_content_category}
/// A widget displaying the category of a post.
/// {@endtemplate}
class PostContentCategory extends StatelessWidget {
  /// {@macro post_content_category}
  const PostContentCategory({
    required this.categoryName,
    required this.isContentOverlaid,
    required this.isVideoContent,
    super.key,
  });

  /// Category of post.
  final String categoryName;

  /// Whether this category should be overlaid on the image.
  final bool isContentOverlaid;

  /// Whether content is a part of a video article.
  final bool isVideoContent;

  @override
  Widget build(BuildContext context) {
    // Category label hierarchy
    final backgroundColor =
        isContentOverlaid ? AppColors.secondary : AppColors.transparent;

    final isCategoryBackgroundDark = isContentOverlaid;

    final textColor = isVideoContent
        ? AppColors.orange
        : isCategoryBackgroundDark
            ? AppColors.white
            : AppColors.secondary;

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
                categoryName.toUpperCase(),
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
