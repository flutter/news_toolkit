// ignore_for_file: prefer_const_constructors

import 'package:{{project_name.snakeCase()}}/feed/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_repository/news_repository.dart';

void main() {
  group('FeedEvent', () {
    group('FeedRequested', () {
      test('supports value comparisons', () {
        final event1 = FeedRequested(category: Category.health);
        final event2 = FeedRequested(category: Category.health);

        expect(event1, equals(event2));
      });
    });

    group('FeedRefreshRequested', () {
      test('supports value comparisons', () {
        final event1 = FeedRefreshRequested(category: Category.science);
        final event2 = FeedRefreshRequested(category: Category.science);

        expect(event1, equals(event2));
      });
    });
  });
}
