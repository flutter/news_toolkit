// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:google_news_template_api/src/api/v1/feed/get_feed/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryNewsDataSource', () {
    late NewsDataSource newsDataSource;

    setUp(() {
      newsDataSource = InMemoryNewsDataSource();
    });

    group('getNewsFeed', () {
      test('returns stubbed feed', () {
        expect(newsDataSource.getNewsFeed(), completion(isA<Feed>()));
      });
    });
  });
}
