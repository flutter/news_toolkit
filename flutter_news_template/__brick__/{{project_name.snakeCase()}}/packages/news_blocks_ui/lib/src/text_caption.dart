import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template text_caption}
/// A reusable text caption news block widget.
/// {@endtemplate}
class TextCaption extends StatelessWidget {
  /// {@macro text_caption}
  const TextCaption({
    required this.block,
    this.colorValues = _defaultColorValues,
    super.key,
  });

  /// The associated [TextCaption] instance.
  final TextCaptionBlock block;

  /// The color values of this text caption.
  ///
  /// Defaults to [_defaultColorValues].
  final Map<TextCaptionColor, Color> colorValues;

  /// The default color values of this text caption.
  static const _defaultColorValues = <TextCaptionColor, Color>{
    TextCaptionColor.normal: AppColors.highEmphasisSurface,
    TextCaptionColor.light: AppColors.mediumEmphasisSurface,
  };

  @override
  Widget build(BuildContext context) {
    final color = colorValues.containsKey(block.color)
        ? colorValues[block.color]
        : AppColors.highEmphasisSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        block.text,
        style: Theme.of(context).textTheme.bodySmall?.apply(color: color),
      ),
    );
  }
}
