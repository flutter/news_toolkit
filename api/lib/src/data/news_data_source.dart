import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template news_data_source}
/// An interface for a news content data source.
/// {@endtemplate}
abstract class NewsDataSource {
  /// {@macro news_data_source}
  const NewsDataSource();

  /// Returns a news [Feed].
  Future<Feed> getFeed();

  /// Returns a list of all available news categories.
  Future<List<Category>> getCategories();
}

/// {@template in_memory_news_data_source}
/// An implementation of [NewsDataSource] which
/// is powered by in-memory news content.
/// {@endtemplate}
class InMemoryNewsDataSource implements NewsDataSource {
  /// {@macro in_memory_news_data_store}
  const InMemoryNewsDataSource();

  @override
  Future<Feed> getFeed() async => _topNewsFeed;

  @override
  Future<List<Category>> getCategories() async => _newsData.keys.toList();
}

/// The static news feed content.

// Top News
const _topNewsBlocks = <NewsBlock>[SectionHeaderBlock(title: 'Breaking News')];
final _topNewsFeed = Feed(
  blocks: _topNewsBlocks,
  totalBlocks: _topNewsBlocks.length,
);

// Technology
const _technologyBlocks = <NewsBlock>[SectionHeaderBlock(title: 'Technology')];
final _technologyFeed = Feed(
  blocks: _technologyBlocks,
  totalBlocks: _technologyBlocks.length,
);

// Sports
const _sportsBlocks = <NewsBlock>[SectionHeaderBlock(title: 'Sports')];
final _sportsFeed = Feed(
  blocks: _sportsBlocks,
  totalBlocks: _sportsBlocks.length,
);

final _newsData = <Category, Feed>{
  Category.top: _topNewsFeed,
  Category.technology: _technologyFeed,
  Category.sports: _sportsFeed,
};
