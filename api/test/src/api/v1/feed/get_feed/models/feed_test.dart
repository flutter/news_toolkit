// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/src/api/v1/feed/get_feed/models/feed.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('Feed', () {
    test('can be (de)serialized', () {
      final feed = Feed(blocks: [SectionHeaderBlock(title: 'example title')]);
      expect(
        Feed.fromJson(feed.toJson()),
        isA<Feed>().having(
          (f) => f.blocks,
          'blocks',
          containsAllInOrder(<Matcher>[isA<SectionHeaderBlock>()]),
        ),
      );
    });
  });
}
