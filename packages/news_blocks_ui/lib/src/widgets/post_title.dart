import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template post_general_info}
/// A post widget displaying general text info of a post.
/// {@endtemplate}
class PostTitle extends StatelessWidget {
  /// {@macro divider_horizontal}
  const PostTitle({
    Key? key,
    required this.title,
    required this.date,
    this.category = '',
    this.description = '',
    this.author = '',
    this.onShare,
    this.isPremium = false,
    required this.premiumText,
  }) : super(key: key);

  /// Title of post
  final String title;

  /// Date of post
  final DateTime date;

  /// Category of post
  final String category;

  /// Description of post
  final String description;

  /// Author of post
  final String author;

  /// Share callback
  final VoidCallback? onShare;

  /// Whether this post requires a premium subscription to access.
  ///
  /// Defaults to false.
  final bool isPremium;

  /// Text displayed when post is premium content
  final String premiumText;

  String get _captionText =>
      author.isNotEmpty ? '$author  •  ${date.mDY}' : date.mDY;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final greyedColor = textTheme.caption?.color?.withOpacity(0.6);
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        if (category.isNotEmpty)
          PostCategoryWidget(
            category: category,
            isPremium: isPremium,
            premiumText: premiumText,
          ),
        Text(
          title,
          style: textTheme.headline3,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (author.isNotEmpty)
              Text(
                _captionText,
                style: textTheme.caption?.copyWith(color: greyedColor),
              ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: greyedColor,
              ),
              onPressed: onShare,
            ),
          ],
        )
      ],
    );
  }
}

/// {@template post_category}
/// A widget displaying category text of a post.
/// {@endtemplate}
class PostCategoryWidget extends StatelessWidget {
  /// {@macro post_category}
  const PostCategoryWidget({
    Key? key,
    required this.category,
    required this.isPremium,
    required this.premiumText,
  }) : super(key: key);

  /// Category of post
  final String category;

  /// Whether this post requires a premium subscription to access.
  final bool isPremium;

  /// Text displayed when post is premium content
  final String premiumText;

  @override
  Widget build(BuildContext context) {
    final categoryDisplay = isPremium ? ' $premiumText ' : category;
    final overlineTheme = Theme.of(context).textTheme.overline;
    final categoryStyle = isPremium
        ? overlineTheme?.copyWith(
            color: AppColors.white,
            backgroundColor: AppColors.secondary,
          )
        : overlineTheme?.copyWith(color: AppColors.secondary);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            categoryDisplay.toUpperCase(),
            style: categoryStyle,
          ),
        ),
        const SizedBox(height: AppSpacing.sm)
      ],
    );
  }
}
