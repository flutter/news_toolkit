// ignore_for_file: prefer_const_constructors

import 'package:{{project_name.snakeCase()}}_api/api.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('RelatedArticles', () {
    test('can be (de)serialized', () {
      final blockA = SectionHeaderBlock(title: 'sectionA');
      final blockB = SectionHeaderBlock(title: 'sectionB');
      final relatedArticles = RelatedArticles(
        blocks: [blockA, blockB],
        totalBlocks: 2,
      );

      expect(
        RelatedArticles.fromJson(relatedArticles.toJson()),
        equals(relatedArticles),
      );
    });
  });
}
