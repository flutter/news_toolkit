import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template post_large_image}
/// Block post large image widget.
/// {@endtemplate}
class PostLargeImage extends StatelessWidget {
  /// {@macro post_large_image}
  const PostLargeImage({
    super.key,
    required this.imageUrl,
    required this.isContentOverlaid,
  });

  /// The url of image displayed in this post.
  final String imageUrl;

  /// Whether this image is displayed in overlay.
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    return isContentOverlaid
        ? OverlaidImage(
            imageUrl: imageUrl,
            gradientColor: AppColors.black.withOpacity(0.7),
          )
        : InlineImage(imageUrl: imageUrl);
  }
}
