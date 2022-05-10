import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/widgets/overlaid_image.dart';

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
    return isContentOverlaid
        ? OverlaidImage(imageUrl: imageUrl, gradientColor: AppColors.black)
        : Image.network(imageUrl);
  }
}
