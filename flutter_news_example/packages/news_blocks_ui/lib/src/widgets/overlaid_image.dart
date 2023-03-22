import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// {@template overlaid_image}
/// A reusable image widget overlaid with colored gradient.
/// {@endtemplate}
class OverlaidImage extends StatelessWidget {
  /// {@macro overlaid_image}
  const OverlaidImage({
    required this.imageUrl,
    required this.gradientColor,
    super.key,
  });

  /// The aspect ratio of this image.
  static const aspectRatio = 3 / 2;

  /// The url of this image.
  final String imageUrl;

  /// The color of gradient.
  final Color gradientColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        key: const Key('overlaidImage_stack'),
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.transparent,
                  gradientColor.withOpacity(0.7),
                ],
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }
}
