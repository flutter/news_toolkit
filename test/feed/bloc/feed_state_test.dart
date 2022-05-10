// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template_api/client.dart';

void main() {
  group('FeedState', () {
    group('FeedInitial', () {
      test('supports value comparisons', () {
        final state1 = FeedInitial();
        final state2 = FeedInitial();

        expect(state1, equals(state2));
      });
    });

    group('FeedLoading', () {
      test('supports value comparisons', () {
        final state1 = FeedLoading();
        final state2 = FeedLoading();

        expect(state1, equals(state2));
      });
    });

    group('FeedPopulated', () {
      test('supports value comparisons', () {
        const feed = FeedResponse(
          feed: [],
          totalCount: 0,
        );

        final state1 = FeedPopulated(feed);
        final state2 = FeedPopulated(feed);

        expect(state1, equals(state2));
      });
    });

    group('FeedError', () {
      test('supports value comparisons', () {
        final state1 = FeedError();
        final state2 = FeedError();

        expect(state1, equals(state2));
      });
    });
  });
}
