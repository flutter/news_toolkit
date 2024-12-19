// ignore_for_file: prefer_const_constructors

import 'package:{{project_name.snakeCase()}}/feed/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';

void main() {
  group('FeedState', () {
    final healthCategory = Category(id: 'health', name: 'Health');

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
          healthCategory.id: [SectionHeaderBlock(title: 'Health')],
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
          healthCategory.id: false,
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
