import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('PostGridTileBlock', () {
    test('can be (de)serialized', () {
      const category = Category(id: 'science', name: 'Science');
      final block = PostGridTileBlock(
        id: 'id',
        categoryId: category.id,
        author: 'author',
        publishedAt: DateTime(2022, 3, 12),
        imageUrl: 'imageUrl',
        title: 'title',
      );

      expect(PostGridTileBlock.fromJson(block.toJson()), equals(block));
    });

    group('PostGridTitleBlockExt', () {
      const id = 'id';
      const category = Category(id: 'science', name: 'Science');
      const author = 'author';
      final publishedAt = DateTime(2022, 3, 12);
      const imageUrl = 'imageUrl';
      const title = 'title';
      const description = 'description';
      const action = NavigateToArticleAction(articleId: id);

      final gridTile = PostGridTileBlock(
        id: id,
        categoryId: category.id,
        author: author,
        publishedAt: publishedAt,
        imageUrl: imageUrl,
        title: title,
        description: description,
        action: action,
      );

      test('toPostLargeBlock creates PostLargeBlock instance', () {
        final largeBlock = PostLargeBlock(
          id: id,
          categoryId: category.id,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
          isContentOverlaid: true,
          description: description,
          action: action,
        );

        expect(gridTile.toPostLargeBlock(), equals(largeBlock));
      });

      test('toPostMediumBlock creates PostMediumBlock instance', () {
        final mediumBlock = PostMediumBlock(
          id: id,
          categoryId: category.id,
          author: author,
          publishedAt: publishedAt,
          imageUrl: imageUrl,
          title: title,
          isContentOverlaid: true,
          description: description,
          action: action,
        );

        expect(gridTile.toPostMediumBlock(), equals(mediumBlock));
      });
    });
  });
}
