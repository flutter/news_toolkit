import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('PostGridGroupBlock', () {
    test('can be (de)serialized', () {
      const category = Category(id: 'science', name: 'Science');
      final block = PostGridGroupBlock(
        categoryId: category.id,
        tiles: [
          PostGridTileBlock(
            id: 'id',
            categoryId: category.id,
            author: 'author',
            publishedAt: DateTime(2022, 3, 12),
            imageUrl: 'imageUrl',
            title: 'title',
          ),
        ],
      );

      expect(PostGridGroupBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
