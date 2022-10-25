// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_template/feed/feed.dart';
import 'package:news_blocks/news_blocks.dart';

void main() {
  group('FeedState', () {
    test('initial has correct status', () {
      expect(
        FeedState.initial().status,
        equals(FeedStatus.initial),
      );
    });

    test('supports value comparisons', () {
      expect(
        FeedState.initial(),
        equals(FeedState.initial()),
      );
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          FeedState.initial().copyWith(),
          equals(FeedState.initial()),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        expect(
          FeedState.initial().copyWith(
            status: FeedStatus.loading,
          ),
          equals(
            FeedState(
              status: FeedStatus.loading,
            ),
          ),
        );
      });

      test(
          'returns object with updated feed '
          'when feed is passed', () {
        final feed = {
          Category.health: [SectionHeaderBlock(title: 'Health')],
        };

        expect(
          FeedState(status: FeedStatus.populated).copyWith(feed: feed),
          equals(
            FeedState(
              status: FeedStatus.populated,
              feed: feed,
            ),
          ),
        );
      });

      test(
          'returns object with updated hasMoreNews '
          'when hasMoreNews is passed', () {
        final hasMoreNews = {
          Category.health: false,
        };

        expect(
          FeedState(status: FeedStatus.populated)
              .copyWith(hasMoreNews: hasMoreNews),
          equals(
            FeedState(
              status: FeedStatus.populated,
              hasMoreNews: hasMoreNews,
            ),
          ),
        );
      });
    });
  });
}
