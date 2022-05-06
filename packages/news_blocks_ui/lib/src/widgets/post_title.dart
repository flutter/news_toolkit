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

  String get _captionText =>
      author.isNotEmpty ? '$author  •  ${date.mDY}' : date.mDY;

  @override
  Widget build(BuildContext context) {
    return ContentThemeOverrideBuilder(
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        final greyedColor = textTheme.caption?.color?.withOpacity(0.6);
        return Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            if (category.isNotEmpty)
              PostCategoryWidget(
                category: category,
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
      },
    );
  }
}

/// {@template post_category}
/// A widget displaying category text of a post.
/// {@endtemplate}
class PostCategoryWidget extends StatelessWidget {
  /// {@macro post_category}
  const PostCategoryWidget({Key? key, required this.category})
      : super(key: key);

  /// Category of post
  final String category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            category.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .overline
                ?.copyWith(color: AppColors.secondary),
          ),
        ),
        const SizedBox(height: AppSpacing.sm)
      ],
    );
  }
}
