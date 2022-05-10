import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
        ? AspectRatio(
            aspectRatio: 3 / 2,
            child: Stack(
              key: const Key('postLargeImage_stack'),
              children: [
                Image.network(
                  imageUrl,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.black.withOpacity(0),
                        AppColors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
              ],
            ),
          )
        : Image.network(imageUrl);
  }
}
