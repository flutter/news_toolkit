// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';
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
  });
}
