import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template text_paragraph}
/// A reusable text paragraph news block widget.
/// {@endtemplate}
class TextParagraph extends StatelessWidget {
  /// {@macro text_paragraph}
  const TextParagraph({super.key, required this.block});

  /// The associated [TextParagraphBlock] instance.
  final TextParagraphBlock block;

  @override
  Widget build(BuildContext context) {
    return Text(
      block.text,
      style: Theme.of(context)
          .textTheme
          .bodyText1
          ?.apply(color: AppColors.mediumEmphasisSurface),
    );
  }
}
