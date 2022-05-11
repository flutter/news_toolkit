import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template post_large_image}
/// Block post large image widget.
/// {@endtemplate}
class PostLargeImage extends StatelessWidget {
  /// {@macro post_large_image}
  const PostLargeImage({
    Key? key,
    required this.imageUrl,
    required this.isContentOverlaid,
  }) : super(key: key);

  /// Url of image displayed in large post.
  final String imageUrl;

  /// Whether this image is displayed in overlay.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: isContentOverlaid
          ? OverlaidImage(
              imageUrl: imageUrl,
              gradientColor: AppColors.black.withOpacity(0.7),
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
    );
  }
}
