import 'package:flutter/material.dart' hide Spacer;
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class CategoryFeedItem extends StatelessWidget {
  const CategoryFeedItem({
    Key? key,
    required this.block,
  }) : super(key: key);

  /// The associated [NewsBlock] instance.
  final NewsBlock block;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;

    if (newsBlock is DividerHorizontalBlock) {
      return DividerHorizontal(block: newsBlock);
    } else if (newsBlock is SpacerBlock) {
      return Spacer(block: newsBlock);
    } else if (newsBlock is SectionHeaderBlock) {
      return SectionHeader(block: newsBlock);
    } else if (newsBlock is PostSmallBlock) {
      return PostSmall(block: newsBlock);
    } else {
      // Render an empty widget for the unsupported block type.
      return const SizedBox();
    }
  }
}
