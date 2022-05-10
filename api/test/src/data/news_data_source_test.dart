// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/data/in_memory_news_data_source.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

class MyNewsDataSource extends NewsDataSource {
  @override
  Future<Article> getArticle({
    required String id,
    int limit = 20,
    int offset = 0,
  }) {
    throw UnimplementedError();
  }

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
  Matcher feedHaving({required List<NewsBlock> blocks, int? totalBlocks}) {
    return predicate<Feed>(
      (feed) {
        totalBlocks ??= feed.totalBlocks;
        if (blocks.length != feed.blocks.length) return false;
        if (totalBlocks != feed.totalBlocks) return false;
        for (var i = 0; i < blocks.length; i++) {
          if (blocks[i] != feed.blocks[i]) return false;
        }
        return true;
      },
    );
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
          completion(feedHaving(blocks: topNewsFeedBlocks)),
        );
      });

      test('returns stubbed feed (Category.technology)', () {
        expect(
          newsDataSource.getFeed(category: Category.technology),
          completion(feedHaving(blocks: technologyFeedBlocks)),
        );
      });

      test('returns stubbed feed (Category.sports)', () {
        expect(
          newsDataSource.getFeed(category: Category.sports),
          completion(feedHaving(blocks: sportsFeedBlocks)),
        );
      });

      test('returns empty feed for remaining categories', () async {
        final emptyCategories = [
          Category.business,
          Category.entertainment,
        ];
        for (final category in emptyCategories) {
          await expectLater(
            newsDataSource.getFeed(category: category),
            completion(isAnEmptyFeed()),
          );
        }
      });

      test('returns correct feed when limit is specified', () {
        expect(
          newsDataSource.getFeed(limit: 0),
          completion(
            feedHaving(blocks: [], totalBlocks: topNewsFeedBlocks.length),
          ),
        );

        expect(
          newsDataSource.getFeed(limit: 1),
          completion(
            feedHaving(
              blocks: topNewsFeedBlocks.take(1).toList(),
              totalBlocks: topNewsFeedBlocks.length,
            ),
          ),
        );

        expect(
          newsDataSource.getFeed(limit: 100),
          completion(
            feedHaving(
              blocks: topNewsFeedBlocks,
              totalBlocks: topNewsFeedBlocks.length,
            ),
          ),
        );
      });

      test('returns correct feed when offset is specified', () {
        expect(
          newsDataSource.getFeed(offset: 1),
          completion(
            feedHaving(
              blocks: topNewsFeedBlocks.sublist(1),
              totalBlocks: topNewsFeedBlocks.length,
            ),
          ),
        );

        expect(
          newsDataSource.getFeed(offset: 2),
          completion(
            feedHaving(
              blocks: topNewsFeedBlocks.sublist(2),
              totalBlocks: topNewsFeedBlocks.length,
            ),
          ),
        );

        expect(
          newsDataSource.getFeed(offset: 100),
          completion(
            feedHaving(
              blocks: [],
              totalBlocks: topNewsFeedBlocks.length,
            ),
          ),
        );
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
            Category.health,
            Category.science,
          ]),
        );
      });
    });
  });
}
