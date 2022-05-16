import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template image}
/// A reusable image news block widget.
/// {@endtemplate}
class Image extends StatelessWidget {
  /// {@macro image}
  const Image({super.key, required this.block});

  /// The associated [ImageBlock] instance.
  final ImageBlock block;

  @override
  Widget build(BuildContext context) {
    return InlineImage(
      imageUrl: block.imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          ProgressIndicator(progress: downloadProgress.progress),
    );
  }
}
