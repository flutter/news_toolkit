import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template post_medium_overlaid_layout}
/// A reusable post medium widget that overlays the post content on the image.
/// {@endtemplate}
class PostMediumOverlaidLayout extends StatelessWidget {
  /// {@macro post_medium_overlaid_layout}
  const PostMediumOverlaidLayout({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  /// Title of post.
  final String title;

  /// The url of this post image displayed in overlay.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        OverlaidImage(
          imageUrl: imageUrl,
          gradientColor: AppColors.black.withOpacity(0.7),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.subtitle2
                ?.copyWith(color: AppColors.highEmphasisPrimary),
          ),
        ),
      ],
    );
  }
}
