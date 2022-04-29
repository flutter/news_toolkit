// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('FeedResponse', () {
    test('can be (de)serialized', () {
      final sectionHeaderA = SectionHeaderBlock(title: 'sectionA');
      final sectionHeaderB = SectionHeaderBlock(title: 'sectionB');
      final response = FeedResponse(
        feed: [sectionHeaderA, sectionHeaderB],
        totalCount: 2,
      );

      expect(
        FeedResponse.fromJson(response.toJson()),
        isA<FeedResponse>()
            .having(
              (f) => f.feed,
              'feed',
              containsAllInOrder(
                <Matcher>[
                  isA<SectionHeaderBlock>()
                      .having((b) => b.title, 'title', sectionHeaderA.title),
                  isA<SectionHeaderBlock>()
                      .having((b) => b.title, 'title', sectionHeaderB.title)
                ],
              ),
            )
            .having((f) => f.totalCount, 'totalCount', response.totalCount),
      );
    });
  });
}
