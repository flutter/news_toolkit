// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';

void main() {
  group('FeedEvent', () {
    group('FetchFeed', () {
      test('supports value comparisons', () {
        final event1 = FetchFeed();
        final event2 = FetchFeed();

        expect(event1, equals(event2));
      });
    });
  });
}
