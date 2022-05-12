import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template text_caption}
/// A reusable text caption news block widget.
/// {@endtemplate}
class TextCaption extends StatelessWidget {
  /// {@macro text_caption}
  const TextCaption({super.key, required this.block});

  /// The associated [TextCaption] instance.
  final TextCaptionBlock block;

  /// The color values of this text caption.
  static const _colorValues = <TextCaptionColor, Color>{
    TextCaptionColor.normal: AppColors.highEmphasisSurface,
    TextCaptionColor.light: AppColors.mediumEmphasisSurface,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colorValues.containsKey(block.color)
        ? _colorValues[block.color]
        : AppColors.highEmphasisSurface;

    return Text(
      block.text,
      style: Theme.of(context).textTheme.caption?.apply(
            color: color,
          ),
    );
  }
}
