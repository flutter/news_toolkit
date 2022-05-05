// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/data/news_data_source.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

class MyNewsDataSource extends NewsDataSource {
  @override
  Future<Feed> getFeed({
    Category category = Category.top,
    int limit = 20,
    int offset = 0,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> getCategories() => throw UnimplementedError();
}

void main() {
  Matcher feedHaving({required List<NewsBlock> blocks}) {
    return predicate<Feed>((feed) => feed.blocks == blocks);
  }

  Matcher isAnEmptyFeed() {
    return predicate<Feed>(
      (feed) => feed.blocks.isEmpty && feed.totalBlocks == 0,
    );
  }

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
      test('returns stubbed feed (default category)', () {
        expect(
          newsDataSource.getFeed(),
          completion(feedHaving(blocks: topNewsBlocks)),
        );
      });

      test('returns stubbed feed (Category.technology)', () {
        expect(
          newsDataSource.getFeed(category: Category.technology),
          completion(feedHaving(blocks: technologyBlocks)),
        );
      });

      test('returns stubbed feed (Category.sports)', () {
        expect(
          newsDataSource.getFeed(category: Category.sports),
          completion(feedHaving(blocks: sportsBlocks)),
        );
      });

      test('returns empty feed for remaining categories', () async {
        final emptyCategories = [
          Category.business,
          Category.health,
          Category.entertainment,
          Category.science,
        ];
        for (final category in emptyCategories) {
          await expectLater(
            newsDataSource.getFeed(category: category),
            completion(isAnEmptyFeed()),
          );
        }
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
