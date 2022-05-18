// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('RelatedArticlesResponse', () {
    test('can be (de)serialized', () {
      final sectionHeaderA = SectionHeaderBlock(title: 'sectionA');
      final sectionHeaderB = SectionHeaderBlock(title: 'sectionB');
      final response = RelatedArticlesResponse(
        relatedArticles: [sectionHeaderA, sectionHeaderB],
        totalCount: 2,
      );

      expect(
        RelatedArticlesResponse.fromJson(response.toJson()),
        equals(response),
      );
    });
  });
}
