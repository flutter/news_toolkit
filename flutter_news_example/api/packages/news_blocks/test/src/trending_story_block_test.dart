// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('TrendingStoryBlock', () {
    test('can be (de)serialized', () {
      const category = Category(id: 'health', name: 'Health');
      final content = PostSmallBlock(
        id: 'id',
        categoryId: category.id,
        author: 'author',
        publishedAt: DateTime(2022, 3, 11),
        imageUrl: 'imageUrl',
        title: 'title',
      );
      final block = TrendingStoryBlock(content: content);

      expect(TrendingStoryBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
