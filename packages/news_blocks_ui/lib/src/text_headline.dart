import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template text_headline}
/// A reusable text headline news block widget.
/// {@endtemplate}
class TextHeadline extends StatelessWidget {
  /// {@macro text_headline}
  const TextHeadline({
    Key? key,
    required this.block,
  }) : super(key: key);

  /// The associated [TextHeadlineBlock] instance.
  final TextHeadlineBlock block;

  @override
  Widget build(BuildContext context) {
    return Text(
      block.text,
      style: Theme.of(context).textTheme.headline2,
    );
  }
}
