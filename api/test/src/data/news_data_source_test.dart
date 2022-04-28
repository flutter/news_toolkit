// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:test/test.dart';

class MyNewsDataSource extends NewsDataSource {
  @override
  Future<Feed> getNewsFeed() => throw UnimplementedError();
}

void main() {
  group('NewsDataSource', () {
    test('can be extended', () {
      expect(MyNewsDataSource.new, returnsNormally);
    });
  });

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
