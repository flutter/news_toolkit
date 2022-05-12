// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('Article', () {
    test('can be (de)serialized', () {
      final blockA = SectionHeaderBlock(title: 'sectionA');
      final blockB = SectionHeaderBlock(title: 'sectionB');
      final article = Article(
        blocks: [blockA, blockB],
        totalBlocks: 2,
      );

      expect(Article.fromJson(article.toJson()), equals(article));
    });
  });
}
