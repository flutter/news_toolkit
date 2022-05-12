import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template text_lead_paragraph}
/// A reusable text lead paragraph news block widget.
/// {@endtemplate}
class TextLeadParagraph extends StatelessWidget {
  /// {@macro text_lead_paragraph}
  const TextLeadParagraph({super.key, required this.block});

  /// The associated [TextLeadParagraphBlock] instance.
  final TextLeadParagraphBlock block;

  @override
  Widget build(BuildContext context) {
    return Text(
      block.text,
      style: Theme.of(context)
          .textTheme
          .headline6
          ?.copyWith(color: AppColors.highEmphasisSurface),
    );
  }
}
