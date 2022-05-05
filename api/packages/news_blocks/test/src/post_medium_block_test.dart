import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('PostMediumBlock', () {
    test('can be (de)serialized', () {
      final block = PostMediumBlock(
        id: 'id',
        category: PostCategory.sports,
        author: 'author',
        publishedAt: DateTime(2022, 3, 10),
        imageUrl: 'imageUrl',
        title: 'title',
      );

      expect(PostMediumBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
