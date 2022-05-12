// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('ArticleResponse', () {
    test('can be (de)serialized', () {
      final blockA = SectionHeaderBlock(title: 'sectionA');
      final blockB = SectionHeaderBlock(title: 'sectionB');
      final response = ArticleResponse(
        content: [blockA, blockB],
        totalCount: 2,
      );

      expect(ArticleResponse.fromJson(response.toJson()), equals(response));
    });
  });
}
