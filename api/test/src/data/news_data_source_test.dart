// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:test/test.dart';

class MyNewsDataSource extends NewsDataSource {
  @override
  Future<Feed> getFeed() => throw UnimplementedError();

  @override
  Future<List<Category>> getCategories() => throw UnimplementedError();
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

    group('getFeed', () {
      test('returns stubbed feed', () {
        expect(newsDataSource.getFeed(), completion(isA<Feed>()));
      });
    });

    group('getCategories', () {
      test('returns stubbed categories', () {
        expect(
          newsDataSource.getCategories(),
          completion([
            Category.top,
            Category.technology,
            Category.sports,
          ]),
        );
      });
    });
  });
}
