import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class SlideshowView extends StatelessWidget {
  const SlideshowView({
    super.key,
    required this.block,
  });

  final SlideshowBlock block;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Slideshow(
      block: block,
      categoryTitle: l10n.slideshow.toUpperCase(),
    );
  }
}
