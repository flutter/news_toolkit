import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/post_large/post_large.dart';

/// {@template post_header_content}
/// A post widget displaying general text info of a post.
/// {@endtemplate}
class PostHeaderContent extends StatelessWidget {
  /// {@macro post_header_content}
  const PostHeaderContent({
    Key? key,
    required this.title,
    required this.date,
    this.categoryName,
    this.description,
    this.author,
    this.onShare,
    this.isPremium = false,
    required this.premiumText,
    required this.isContentOverlaid,
  }) : super(key: key);

  /// Title of post.
  final String title;

  /// Date of post.
  final DateTime date;

  /// Category of post.
  final String? categoryName;

  /// Description of post.
  final String? description;

  /// Author of post.
  final String? author;

  /// Share callback.
  final VoidCallback? onShare;

  /// Whether this post requires a premium subscription to access.
  ///
  /// Defaults to false.
  final bool isPremium;

  /// Text displayed when post is premium content.
  final String premiumText;

  /// Whether category is displayed in reversed color theme.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  String get _captionText => '$author  •  ${date.mDY}';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
            ),
          Text(
            title,
            style: textTheme.headline3,
            maxLines: isContentOverlaid ? 3 : null,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (author?.isNotEmpty ?? false)
                Text(
                  _captionText,
                  style: textTheme.caption,
                ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: textTheme.caption?.color,
                ),
                onPressed: onShare,
              ),
            ],
          )
        ],
      ),
    );
  }
}
