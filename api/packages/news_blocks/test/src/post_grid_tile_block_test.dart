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
  });
}
