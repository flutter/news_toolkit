// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('Feed', () {
    test('can be (de)serialized', () {
      final sectionHeaderA = SectionHeaderBlock(title: 'sectionA');
      final sectionHeaderB = SectionHeaderBlock(title: 'sectionB');
      final feed = Feed(
        blocks: [sectionHeaderA, sectionHeaderB],
        totalBlocks: 2,
      );

      expect(
        Feed.fromJson(feed.toJson()),
        isA<Feed>()
            .having(
              (f) => f.blocks,
              'blocks',
              containsAllInOrder(
                <Matcher>[
                  isA<SectionHeaderBlock>()
                      .having((b) => b.title, 'title', sectionHeaderA.title),
                  isA<SectionHeaderBlock>()
                      .having((b) => b.title, 'title', sectionHeaderB.title)
                ],
              ),
            )
            .having((f) => f.totalBlocks, 'totalBlocks', feed.totalBlocks),
      );
    });
  });
}
