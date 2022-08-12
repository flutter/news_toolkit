import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('PostLargeBlock', () {
    test('can be (de)serialized', () {
      final block = PostLargeBlock(
        id: 'id',
        category: PostCategory.technology,
        author: 'author',
        publishedAt: DateTime(2022, 3, 9),
        imageUrl: 'imageUrl',
        title: 'title',
      );

      expect(PostLargeBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
