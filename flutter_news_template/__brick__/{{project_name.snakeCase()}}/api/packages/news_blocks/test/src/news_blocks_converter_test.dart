// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('NewsBlocksConverter', () {
    test('can (de)serialize List<NewsBlock>', () {
      final converter = NewsBlocksConverter();
      final newsBlocks = <NewsBlock>[
        SectionHeaderBlock(title: 'title'),
        DividerHorizontalBlock(),
        SpacerBlock(spacing: Spacing.medium),
        PostSmallBlock(
          id: 'id',
          category: PostCategory.health,
          author: 'author',
          publishedAt: DateTime(2022, 3, 11),
          imageUrl: 'imageUrl',
          title: 'title',
          description: 'description',
        ),
      ];

      expect(
        converter.fromJson(converter.toJson(newsBlocks)),
        equals(newsBlocks),
      );
    });
  });
}
