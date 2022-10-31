import 'package:news_blocks/news_blocks.dart';

import 'package:test/test.dart';

void main() {
  group('PostSmallBlock', () {
    test('can be (de)serialized', () {
      final block = PostSmallBlock(
        id: 'id',
        category: PostCategory.health,
        author: 'author',
        publishedAt: DateTime(2022, 3, 11),
        imageUrl: 'imageUrl',
        title: 'title',
      );

      expect(PostSmallBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
