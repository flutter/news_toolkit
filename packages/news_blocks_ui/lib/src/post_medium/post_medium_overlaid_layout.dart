import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template post_medium_overlaid_layout}
/// A reusable post medium news block widget that overlays an image.
/// {@endtemplate}
class PostMediumOverlaidLayout extends StatelessWidget {
  /// {@macro post_medium_overlaid_layout}
  const PostMediumOverlaidLayout({
    Key? key,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  /// Title of post.
  final String title;

  /// Url of image displayed in overlay.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.centerRight,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AspectRatio(
            aspectRatio: 3 / 2,
            child: OverlaidImage(
              imageUrl: imageUrl,
              gradientColor: AppColors.black.withOpacity(0.7),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Text(
              title,
              style: textTheme.subtitle2
                  ?.copyWith(color: AppColors.highEmphasisPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
