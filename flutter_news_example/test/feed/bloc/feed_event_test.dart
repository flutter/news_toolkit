// ignore_for_file: prefer_const_constructors

import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_repository/news_repository.dart';

void main() {
  group('FeedEvent', () {
    final entertainmentCategory = Category(
      id: 'entertainment',
      name: 'Entertainment',
    );
    final healthCategory = Category(id: 'health', name: 'Health');

    group('FeedRequested', () {
      test('supports value comparisons', () {
        final event1 = FeedRequested(category: healthCategory);
        final event2 = FeedRequested(category: healthCategory);

        expect(event1, equals(event2));
      });
    });

    group('FeedRefreshRequested', () {
      test('supports value comparisons', () {
        final event1 = FeedRefreshRequested(category: entertainmentCategory);
        final event2 = FeedRefreshRequested(category: entertainmentCategory);

        expect(event1, equals(event2));
      });
    });
  });
}
