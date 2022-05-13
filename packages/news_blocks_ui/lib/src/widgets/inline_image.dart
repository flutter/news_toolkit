import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// {@template inline_image}
/// Image widget displayed inline with the content.
/// {@endtemplate}
class InlineImage extends StatelessWidget {
  /// {@macro inline_image}
  const InlineImage({
    super.key,
    required this.imageUrl,
  });

  /// The aspect ratio of this image.
  static const _aspectRatio = 3 / 2;

  /// The url of this image.
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
