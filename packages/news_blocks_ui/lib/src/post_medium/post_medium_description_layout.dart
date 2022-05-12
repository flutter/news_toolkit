import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template post_medium_description_layout}
/// A reusable post medium news block widget showing post description.
/// {@endtemplate}
class PostMediumDescriptionLayout extends StatelessWidget {
  /// {@macro post_medium_description_layout}
  const PostMediumDescriptionLayout({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    this.author,
    this.onShare,
  }) : super(key: key);

  /// Title of post.
  final String title;

  /// Description of post.
  final String description;

  /// The date when this post was published.
  final DateTime publishedAt;

  /// The author of this post.
  final String? author;

  /// Called when the share button is tapped.
  final VoidCallback? onShare;

  /// The url of the post image.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.headline6
                      ?.copyWith(color: AppColors.highEmphasisSurface),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AspectRatio(
                  aspectRatio: PostMedium.imageAspectRatio,
                  child: Image.network(
                    imageUrl,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Text(
            description,
            style: textTheme.bodyText2
                ?.copyWith(color: AppColors.mediumEmphasisSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          PostFooter(
            publishedAt: publishedAt,
            author: author,
            onShare: onShare,
          ),
        ],
      ),
    );
  }
}
