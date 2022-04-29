import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template news_data_source}
/// An interface for a news content data source.
/// {@endtemplate}
abstract class NewsDataSource {
  /// {@macro news_data_source}
  const NewsDataSource();

  /// Returns a news [Feed].
  Future<Feed> getNewsFeed();
}

/// {@template in_memory_news_data_source}
/// An implementation of [NewsDataSource] which
/// is powered by in-memory news content.
/// {@endtemplate}
class InMemoryNewsDataSource implements NewsDataSource {
  /// {@macro in_memory_news_data_store}
  const InMemoryNewsDataSource();

  @override
  Future<Feed> getNewsFeed() async => _topNewsFeed;
}

/// The static news feed content.

const _topNewsBlocks = <NewsBlock>[SectionHeaderBlock(title: 'Breaking News')];
final _topNewsFeed = Feed(
  blocks: _topNewsBlocks,
  totalBlocks: _topNewsBlocks.length,
);
