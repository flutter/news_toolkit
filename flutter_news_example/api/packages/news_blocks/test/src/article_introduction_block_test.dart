import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('ArticleIntroductionBlock', () {
    test('can be (de)serialized', () {
      const category = Category(id: 'technology', name: 'Technology');
      final block = ArticleIntroductionBlock(
        categoryId: category.id,
        author: 'author',
        publishedAt: DateTime(2022, 3, 9),
        imageUrl: 'imageUrl',
        title: 'title',
      );

      expect(ArticleIntroductionBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
