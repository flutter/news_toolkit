import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('PostGridTileBlock', () {
    test('can be (de)serialized', () {
      final block = PostGridTileBlock(
        id: 'id',
        category: PostCategory.science,
        author: 'author',
        publishedAt: DateTime(2022, 3, 12),
        imageUrl: 'imageUrl',
        title: 'title',
      );

      expect(PostGridTileBlock.fromJson(block.toJson()), equals(block));
    });

    group('PostGridTitleBlockExt', () {
      const id = 'id';
      const category = PostCategory.science;
      const author = 'author';
      final publishedAt = DateTime(2022, 3, 12);
      const imageUrl = 'imageUrl';
      const title = 'title';

      final gridTile = PostGridTileBlock(
        id: id,
        category: category,
        author: author,
        publishedAt: publishedAt,
        imageUrl: imageUrl,
        title: title,
      );

      test('toPostLargeBlock creates PostLargeBlock instance', () {
        final largeBlock = PostLargeBlock(
          id: id,
          category: category,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
          isContentOverlaid: true,
        );

        expect(gridTile.toPostLargeBlock(), equals(largeBlock));
      });

      test('toPostMediumBlock creates PostMediumBlock instance', () {
        final mediumBlock = PostMediumBlock(
          id: id,
          category: category,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
          isContentOverlaid: true,
        );

        expect(gridTile.toPostMediumBlock(), equals(mediumBlock));
      });
    });
  });
}
